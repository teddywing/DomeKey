//
//  HeadphoneKey.h
//  DomeKey
//
//  Created by tw on 8/14/18.
//  Copyright © 2018 tw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDHidAppleMikey.h"

#import "Mappings.h"
#import "Sounds.h"
#import "dome_key_map.h"
#import "log.h"

typedef enum KeyPress : BOOL {
    KeyPressDown = YES,
    KeyPressUp = NO
} KeyPress;

static const Milliseconds TIMEOUT_DEFAULT = 500;

@interface HeadphoneKey : NSObject {
    NSArray *_mikeys;
    NSMutableArray *_key_buffer;
    Mappings *_mappings;
    Milliseconds _timeout;
}

- (instancetype)initWithConfig:(Config *)config;
- (void)handleDeadKey:(HeadphoneButton)button;
- (void)runAction;

@end
