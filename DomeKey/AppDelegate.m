//
//  AppDelegate.m
//  DomeKey
//
//  Created by tw on 8/16/18.
//  Copyright © 2018 tw. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    _headphone_key = [[HeadphoneKey alloc] init];
    [_headphone_key startMonitoringBluetoothEvents];

    _blargh = [MPRemoteCommandCenter sharedCommandCenter];

    [[_blargh togglePlayPauseCommand] addTarget:self action:@selector(mpmediaplayerplaypauesss:)];
}

- (void)mpmediaplayerBS
{
    MPRemoteCommandCenter *center = [MPRemoteCommandCenter sharedCommandCenter];

    [[center togglePlayPauseCommand] addTarget:self action:@selector(mpmediaplayerplaypauesss:)];
// pauseCommand
// playCommand
// togglePlayPauseCommand
// nextTrackCommand
// previousTrackCommand
}

- (MPRemoteCommandHandlerStatus) mpmediaplayerplaypauesss: (MPRemoteCommandEvent*) event
{
    NSLog(@"Played from MPMediaPlayer");

    return MPRemoteCommandHandlerStatusSuccess;
}

@end
