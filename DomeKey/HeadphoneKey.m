//
//  HeadphoneKey.m
//  DomeKey
//
//  Created by tw on 8/14/18.
//  Copyright © 2018 tw. All rights reserved.
//

#import "HeadphoneKey.h"

@implementation HeadphoneKey

- (instancetype)init
{
    self = [super init];
    if (self) {
        _key_buffer = [[NSMutableArray alloc] initWithCapacity:5];
        _in_mode = NULL;
        _state = state_new();

        // Should never be used. We initialise it just in case, but the real
        // default should always come from a `Config`, set in the Rust library.
        _timeout = TIMEOUT_DEFAULT;

        logger_init();
        state_load_map_group(_state);

        _mikeys = [DDHidAppleMikey allMikeys];
        [_mikeys makeObjectsPerformSelector:@selector(setDelegate:)
            withObject:self];
        [_mikeys makeObjectsPerformSelector:@selector(setListenInExclusiveMode:)
            withObject:(id)kCFBooleanTrue];
        [_mikeys makeObjectsPerformSelector:@selector(startListening)];
    }
    return self;
}

- (instancetype)initWithTimeout:(Milliseconds)timeout
{
    self = [self init];
    if (self) {
        _timeout = timeout;
    }
    return self;
}

- (void)dealloc
{
    state_free(_state);
}

- (void)ddhidAppleMikey:(DDHidAppleMikey *)mikey
                  press:(unsigned)usageId
               upOrDown:(BOOL)upOrDown
{
    if (upOrDown == KeyPressUp) {
        switch (usageId) {
        case kHIDUsage_Csmr_PlayOrPause:
            NSLog(@"Middle");
            [self handleDeadKey:HeadphoneButton_Play];
            break;
        case kHIDUsage_Csmr_VolumeIncrement:
            NSLog(@"Top");
            [self handleDeadKey:HeadphoneButton_Up];
            break;
        case kHIDUsage_Csmr_VolumeDecrement:
            NSLog(@"Bottom");
            [self handleDeadKey:HeadphoneButton_Down];
            break;
        }
    }
}

- (void)startMonitoringBluetoothEvents
{
    // https://github.com/jguice/mac-bt-headset-fix/blob/master/Spotify%20Bluetooth%20Headset%20Listener/KDMAppDelegate.m
    [NSEvent
        addGlobalMonitorForEventsMatchingMask:(NSKeyDownMask | NSSystemDefinedMask)
        handler:^(NSEvent *theEvent) {
            int key_code = (([theEvent data1] & 0xFFFF0000) >> 16);
            int key_flags = ([theEvent data1] & 0x0000FFFF);
            int key_state = (((key_flags & 0xFF00) >> 8)) == 0xA;

            NSLog(@"Key from global monitor pressed");

            // TODO: Fix magic numbers
            if (key_code == 10 && key_flags == 6972) {
                switch ([theEvent data2]) {
                case 786608:
                case 786637:
                    NSLog(@"Play");

                    break;
                case 786611:
                    NSLog(@"Next");

                    break;
                case 786612:
                    NSLog(@"Previous");

                    break;
                case 786613:
                    NSLog(@"Fast-forward");

                    break;
                case 786614:
                    NSLog(@"Rewind");

                    break;
                }
            }
        }];
}

- (void)handleDeadKey:(HeadphoneButton)button
{
    NSNumber *storable_button = [NSNumber numberWithUnsignedInteger:button];
    [_key_buffer addObject:storable_button];

    [NSObject cancelPreviousPerformRequestsWithTarget:self
        selector:@selector(runAction)
        object:nil];

    NSTimeInterval timeout_seconds = _timeout / 1000.0;
    [self performSelector:@selector(runAction)
        withObject:nil
        afterDelay:timeout_seconds];
}

- (void)runAction
{
    NSLog(@"%@", _key_buffer);

    NSUInteger count = [_key_buffer count];
    HeadphoneButton buttons[count];

    for (int i = 0; i < count; i++) {
        buttons[i] = (HeadphoneButton)[[_key_buffer objectAtIndex:i] intValue];
    }

    Trigger trigger = {
        .buttons = buttons,
        .length = count
    };

    c_run_key_action(_state, trigger, _in_mode);

    [_key_buffer removeAllObjects];
}

@end
