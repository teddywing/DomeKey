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
    if (!service_record) {
        NSLog(@"Not a remote control capable pair of headphones");
        return;
    }

    // BluetoothL2CAPPSM *psm = NULL;
    IOReturn ret;
    // ret = [service_record getL2CAPPSM:psm];
    // if (ret != kIOReturnSuccess) {
    //     NSLog(@"L2CAP PSM error: %d", ret);
    //     return;
    // }

    IOBluetoothL2CAPChannel *l2cap;
    ret = [device openL2CAPChannelAsync:&l2cap
        // withPSM:*psm // (BluetoothL2CAPPSM)kBluetoothL2CAPPSMAVCTP
        // Appears to only work for the Play/Pause button
        withPSM:(BluetoothL2CAPPSM)kBluetoothL2CAPPSMAVCTP
        delegate:self];
    if (ret != kIOReturnSuccess) {
        _l2cap_channel = nil;
        NSLog(@"L2CAP channel open error: %d", ret);
        return;
    }

    _l2cap_channel = l2cap;
}

- (void)l2capChannelData:(IOBluetoothL2CAPChannel *)l2capChannel
    data:(void *)dataPointer
    length:(size_t)dataLength
{
    // for (size_t i = 0; i < dataLength; i++) {
    //     NSLog(@"L2CAP data: ?", dataPointer[i]);
    // }
    NSData *data = [NSData dataWithBytes:dataPointer length:dataLength];
    NSLog(@"L2CAP data: %@", data);
}

- (void)l2capChannelOpenComplete:(IOBluetoothL2CAPChannel *)l2capChannel
    status:(IOReturn)error
{
    NSLog(@"L2CAP channel open");
}

- (void)l2capChannelClosed:(IOBluetoothL2CAPChannel *)l2capChannel
{
    NSLog(@"L2CAP channel closed");
}

@end
