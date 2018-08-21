//
//  HeadphoneKey.h
//  DomeKey
//
//  Created by tw on 8/14/18.
//  Copyright © 2018 tw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DDHidLib/DDHidAppleMikey.h>

typedef enum KeyPress : BOOL {
    KeyPressDown = YES,
    KeyPressUp = NO
} KeyPress;

typedef enum HeadphoneButton : NSUInteger {
    HeadphoneButton_Play,
    HeadphoneButton_Up,
    HeadphoneButton_Down
} HeadphoneButton;

static const unsigned int TIMEOUT_MILLISECONDS = 1000;

@interface HeadphoneKey : NSObject {
    NSArray *_mikeys;
    NSMutableArray *_key_buffer;
}

- (void)handleDeadKey:(HeadphoneButton)button;
- (void)maybeRunAction;

@end
