//
//  HeadphoneKeyEventWired.h
//  DomeKey
//
//  Created by tw on 3/22/19.
//  Copyright © 2019 tw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDHidAppleMikey.h"

#import "HeadphoneKeyEventDelegate.h"
#import "log.h"

typedef enum KeyPress : BOOL {
    KeyPressDown = YES,
    KeyPressUp = NO
} KeyPress;

@interface HeadphoneKeyEventWired : NSObject {
    NSArray *_mikeys;
    id <HeadphoneKeyEventDelegate> _delegate;
}

- (instancetype)initWithDelegate:(id <HeadphoneKeyEventDelegate>)delegate;

@end
