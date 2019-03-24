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
// 200418
    NSLog(@"Device class major: %u", [device deviceClassMajor]);
    NSLog(@"Device class minor: %u", [device deviceClassMinor]);
    NSLog(@"Class of device: %u", [device classOfDevice]);
    NSLog(@"Service class major: %u", [device serviceClassMajor]);

    // for (int i = 0; i < [[device services] count]; i++) {
    //     NSLog(@"Service: %@", [[device services] objectAtIndex:i]);
    // }

    if ([device deviceClassMajor] == kBluetoothDeviceClassMajorAudio) {
        NSLog(@"Major audio");
    }
    if ([device deviceClassMinor] == kBluetoothDeviceClassMinorAudioHeadphones) {
        NSLog(@"Minor audio");
    }
    if ([device serviceClassMajor] == kBluetoothServiceClassMajorAudio) {
        NSLog(@"Service major audio");
    }
    if ([device deviceClassMajor] == kBluetoothDeviceClassMajorAudio
            && [device deviceClassMinor] == kBluetoothDeviceClassMinorAudioHeadphones
            && [device serviceClassMajor] == kBluetoothServiceClassMajorAudio) {
        NSLog(@"Is audio device");
    }

    IOBluetoothSDPServiceRecord *service_record = [device
        getServiceRecordForUUID:[[IOBluetoothSDPUUID alloc]
            initWithUUID16:kBluetoothSDPUUID16ServiceClassAVRemoteControlController]];
    if (service_record) {
        NSLog(@"Is remote controller");
    }
}

@end
