//
//  char_to_key_code.h
//  DomeKey
//
//  Created by tw on 8/27/18.
//  Copyright © 2018 tw. All rights reserved.
//

#ifndef char_to_key_code_h
#define char_to_key_code_h

#import <Carbon/Carbon.h>

NSString* keyCodeToString(CGKeyCode keyCode);
NSNumber* charToKeyCode(const char c);

#endif /* char_to_key_code_h */
