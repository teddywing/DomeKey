//
//  AppDelegate.h
//  DomeKey
//
//  Created by tw on 8/16/18.
//  Copyright © 2018 tw. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HeadphoneKey.h"
#import "dome_key_map.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    HeadphoneKey *_headphone_key;
    MPRemoteCommandCenter *_blargh;
    Config *_config;
}

- (instancetype)initWithConfig:(Config *)config;
- (void)mpmediaplayerBS;

@end
