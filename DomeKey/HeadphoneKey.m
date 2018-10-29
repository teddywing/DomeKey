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
        _state = dome_key_state_new();

        // Should never be used. We initialise it just in case, but the real
        // default should always come from a `Config`, set in the Rust library.
        _timeout = TIMEOUT_DEFAULT;

        // TODO: Think about moving this logger higher up
        dome_key_logger_init();
        dome_key_state_load_map_group(_state);

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
    dome_key_state_free(_state);
}

- (void)ddhidAppleMikey:(DDHidAppleMikey *)mikey
                  press:(unsigned)usageId
               upOrDown:(BOOL)upOrDown
{
    if (upOrDown == KeyPressUp) {
        switch (usageId) {
        case kHIDUsage_Csmr_PlayOrPause:
            LogDebug(@"Middle");
            [self handleDeadKey:HeadphoneButton_Play];
            break;
        case kHIDUsage_Csmr_VolumeIncrement:
            LogDebug(@"Top");
            [self handleDeadKey:HeadphoneButton_Up];
            break;
        case kHIDUsage_Csmr_VolumeDecrement:
            LogDebug(@"Bottom");
            [self handleDeadKey:HeadphoneButton_Down];
            break;
        }
    }
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
    LogDebug(@"%@", _key_buffer);

    NSUInteger count = [_key_buffer count];
    HeadphoneButton buttons[count];

    for (int i = 0; i < count; i++) {
        buttons[i] = (HeadphoneButton)[[_key_buffer objectAtIndex:i] intValue];
    }

    Trigger trigger = {
        .buttons = buttons,
        .length = count
    };

    dome_key_run_key_action(_state, trigger, PlayAudio_No);

    [_key_buffer removeAllObjects];
}

@end
