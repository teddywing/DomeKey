//
//  KeyboardSimulator.m
//  DomeKey
//
//  Created by tw on 8/27/18.
//  Copyright © 2018 tw. All rights reserved.
//

#import "KeyboardSimulator.h"

@implementation KeyboardSimulator

+ (CGKeyCode)keyCodeForChar:(NSString *)aChar
{
    return (CGKeyCode)0;
}

+ (void)simpleKeyPressWithKey:(NSString *)aChar
{
    CGEventSourceRef source = CGEventSourceCreate(
        kCGEventSourceStateHIDSystemState
    );

    CGKeyCode key_code = [self keyCodeForChar:aChar];

    CGEventRef key_down = CGEventCreateKeyboardEvent(source, key_code, true);
    CGEventRef key_up = CGEventCreateKeyboardEvent(source, key_code, false);

    CGEventPost(kCGHIDEventTap, key_down);
    CGEventPost(kCGHIDEventTap, key_up);

    CFRelease(key_down);
    CFRelease(key_up);
    CFRelease(source);
}

@end
