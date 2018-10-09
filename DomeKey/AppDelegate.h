//
//  AppDelegate.h
//  DomeKey
//
//  Created by tw on 8/16/18.
//  Copyright © 2018 tw. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HeadphoneKey.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    HeadphoneKey *_headphone_key;
    MPRemoteCommandCenter *_blargh;
}

- (void)mpmediaplayerBS;

@end
