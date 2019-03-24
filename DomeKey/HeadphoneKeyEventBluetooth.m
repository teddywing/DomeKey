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

        IOBluetoothUserNotification *notification = [IOBluetoothDevice
            registerForConnectNotifications:self
            selector:@selector(connectNotification:forDevice:)];
        if (!notification) {
            // TODO: error
            NSLog(@"Connection notification error");
        }
    }
    return self;
}

- (void)devicePairingFinished:(id)sender
    error:(IOReturn)error
{
    NSLog(@"Paired: %@", sender);
}

- (void)connectNotification:(IOBluetoothUserNotification *)notification
    forDevice:(IOBluetoothDevice *)device
{
    NSLog(@"Paired notification: %@ ; Device: %@", notification, device);
}

@end
