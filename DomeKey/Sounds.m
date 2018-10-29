//
//  Sounds.m
//  DomeKey
//
//  Created by tw on 10/29/18.
//  Copyright © 2018 tw. All rights reserved.
//

#import "Sounds.h"

#import "sound_data.h"

@implementation Sounds

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mode_activated = [[NSSound alloc] initWithData:[NSData
            dataWithBytes:sounds_mode_activated_mp3
            length:sounds_mode_activated_mp3_len]];
        _mode_deactivated = [[NSSound alloc] initWithData:[NSData
            dataWithBytes:sounds_mode_deactivated_mp3
            length:sounds_mode_deactivated_mp3_len]];
    }
    return self;
}

- (void)playModeActivated
{
    [_mode_activated play];
}

- (void)playModeDeactivated
{
    [_mode_deactivated play];
}

@end
