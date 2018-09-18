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

        _mikeys = [DDHidAppleMikey allMikeys];
        [_mikeys makeObjectsPerformSelector:@selector(setDelegate:)
            withObject:self];
        [_mikeys makeObjectsPerformSelector:@selector(setListenInExclusiveMode:)
            withObject:(id)kCFBooleanTrue];
        [_mikeys makeObjectsPerformSelector:@selector(startListening)];
    }
    return self;
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

- (void)handleDeadKey:(HeadphoneButton)button
{
    NSNumber *storable_button = [NSNumber numberWithUnsignedInteger:button];
    [_key_buffer addObject:storable_button];

    [NSObject cancelPreviousPerformRequestsWithTarget:self
        selector:@selector(runAction)
        object:nil];

    NSTimeInterval timeout_seconds = TIMEOUT_MILLISECONDS / 1000.0;
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

    const CKeyActionResult *result = c_run_key_action(trigger, NULL);

    if (result->kind &&
            *result->kind == ActionKind_Map) {
        const char *c = result->action;
        int i = 0;
        while (*c) {
            [KeyboardSimulator simpleKeyPressWithKey:result->action[i]];
            i++;
            *c++;
        }
    }

    [_key_buffer removeAllObjects];
}

@end
