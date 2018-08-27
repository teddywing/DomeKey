//
//  KeyboardSimulator.h
//  DomeKey
//
//  Created by tw on 8/27/18.
//  Copyright © 2018 tw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyboardSimulator : NSObject

+ (CGKeyCode)keyCodeForChar:(NSString *)aChar;
+ (void)simpleKeyPressWithKey:(NSString *)aChar;

@end
