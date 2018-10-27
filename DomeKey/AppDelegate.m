//
//  AppDelegate.m
//  DomeKey
//
//  Created by tw on 8/16/18.
//  Copyright © 2018 tw. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (instancetype)initWithConfig:(Config *)config
{
    self = [super init];
    if (self) {
        _config = config;
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    _headphone_key = [[HeadphoneKey alloc] initWithTimeout:_config->timeout];
    [_headphone_key startMonitoringBluetoothEvents];
}

@end
