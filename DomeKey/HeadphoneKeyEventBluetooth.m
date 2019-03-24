//
//  HeadphoneKeyEventBluetooth.m
//  DomeKey
//
//  Created by tw on 3/22/19.
//  Copyright © 2019 tw. All rights reserved.
//

#import "HeadphoneKeyEventBluetooth.h"

@implementation HeadphoneKeyEventBluetooth

- (instancetype)initWithDelegate:(id <HeadphoneKeyEventDelegate>)delegate
{
    self = [self init];
    if (self) {
        _delegate = delegate;

        MPRemoteCommandCenter *cc = [MPRemoteCommandCenter sharedCommandCenter];
        [cc playCommand];
        [cc pauseCommand];
        [cc stopCommand];
        [cc togglePlayPauseCommand];
        // [cc nextTrackCommand];
        // [cc seekForwardCommand];
        // [cc previousTrackCommand];
        // [cc seekBackwardCommand];
    }
    return self;
}

MPRemoteCommandHandler key_pressed(HeadphoneButton button) {
}

@end
