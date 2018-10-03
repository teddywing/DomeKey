//
//  HeadphoneKey.h
//  DomeKey
//
//  Created by tw on 8/14/18.
//  Copyright © 2018 tw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DDHidLib/DDHidAppleMikey.h>

#import "dome_key_map.h"
#import "KeyboardSimulator.h"

typedef enum KeyPress : BOOL {
    KeyPressDown = YES,
    KeyPressUp = NO
} KeyPress;

static const unsigned int TIMEOUT_MILLISECONDS = 1000;

@interface HeadphoneKey : NSObject {
    NSArray *_mikeys;
    NSMutableArray *_key_buffer;
//    const Trigger *_in_mode;
    Trigger *_in_mode;
    State *_state;
}

- (void)handleDeadKey:(HeadphoneButton)button;
- (void)runAction;

@end
