//
//  HeadphoneKeyEventBluetooth.h
//  DomeKey
//
//  Created by tw on 3/22/19.
//  Copyright © 2019 tw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOBluetooth/IOBluetooth.h>

#import "HeadphoneKeyEventDelegate.h"
#import "dome_key_map.h"

@interface HeadphoneKeyEventBluetooth : NSObject <
    IOBluetoothDevicePairDelegate,
    IOBluetoothL2CAPChannelDelegate
> {
    id <HeadphoneKeyEventDelegate> _delegate;
    IOBluetoothL2CAPChannel *_l2cap_channel;
}

- (instancetype)initWithDelegate:(id <HeadphoneKeyEventDelegate>)delegate;

@end
