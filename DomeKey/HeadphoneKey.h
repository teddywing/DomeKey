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

@interface HeadphoneKey : NSObject {
    NSArray *_mikeys;
}

@end
