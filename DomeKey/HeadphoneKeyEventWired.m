//
//  HeadphoneKeyEventWired.m
//  DomeKey
//
//  Created by tw on 3/22/19.
//  Copyright © 2019 tw. All rights reserved.
//

#import "HeadphoneKeyEventWired.h"

@implementation HeadphoneKeyEventWired

- (instancetype)initWithDelegate:(id <HeadphoneKeyEventDelegate>)delegate
{
    self = [self init];
    if (self) {
        _delegate = delegate;

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
            LogDebug(@"Middle");
            [_delegate headphoneButtonWasPressed:HeadphoneButton_Play];
            break;
        case kHIDUsage_Csmr_VolumeIncrement:
            LogDebug(@"Top");
            [_delegate headphoneButtonWasPressed:HeadphoneButton_Up];
            break;
        case kHIDUsage_Csmr_VolumeDecrement:
            LogDebug(@"Bottom");
            [_delegate headphoneButtonWasPressed:HeadphoneButton_Down];
            break;
        }
    }
}

@end
