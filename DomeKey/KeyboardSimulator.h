//
//  KeyboardSimulator.h
//  DomeKey
//
//  Created by tw on 8/27/18.
//  Copyright © 2018 tw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "char_to_key_code.h"

@interface KeyboardSimulator : NSObject

+ (void)simpleKeyPressWithKey:(const char)aChar;

@end
