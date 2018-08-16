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
            break;
        case kHIDUsage_Csmr_VolumeIncrement:
            NSLog(@"Top");
            break;
        case kHIDUsage_Csmr_VolumeDecrement:
            NSLog(@"Bottom");
            break;
        }
    }
}

@end
