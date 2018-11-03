//
//  HeadphoneKey.m
//  DomeKey
//
//  Created by tw on 8/14/18.
//  Copyright © 2018 tw. All rights reserved.
//

#import "HeadphoneKey.h"

static const Sounds *sounds_inst;
static BOOL _play_audio;

@implementation HeadphoneKey

- (instancetype)init
{
    self = [super init];
    if (self) {
        _key_buffer = [[NSMutableArray alloc] initWithCapacity:5];

        _mappings = [[Mappings alloc] init];
        [_mappings reloadMappings];
        [_mappings observeReloadNotification];

        // Should never be used. We initialise it just in case, but the real
        // default should always come from a `Config`, set in the Rust library.
        _timeout = TIMEOUT_DEFAULT;

        _play_audio = NO;

        _mikeys = [DDHidAppleMikey allMikeys];
        [_mikeys makeObjectsPerformSelector:@selector(setDelegate:)
            withObject:self];
        [_mikeys makeObjectsPerformSelector:@selector(setListenInExclusiveMode:)
            withObject:(id)kCFBooleanTrue];
        [_mikeys makeObjectsPerformSelector:@selector(startListening)];
    }
    return self;
}

- (instancetype)initWithConfig:(Config *)config
{
    self = [self init];
    if (self) {
        _timeout = config->timeout;
        _play_audio = config->args.audio;

        if (_play_audio) {
            sounds_inst = [[Sounds alloc] init];
        }
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

    dome_key_run_key_action([_mappings state], trigger, on_mode_change);

    [_key_buffer removeAllObjects];
}

void on_mode_change(ModeChange mode_change) {
    if (!_play_audio) {
        return;
    }

    switch (mode_change) {
    case ModeChange_Activated:
        [sounds_inst playModeActivated];

        break;
    case ModeChange_Deactivated:
        [sounds_inst playModeDeactivated];

        break;
    }
}

@end
