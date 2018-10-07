//
//  DKApplication.h
//  DomeKey
//
//  Created by tw on 10/6/18.
//  Copyright © 2018 tw. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DKApplication : NSApplication

- (void)mediaKeyEvent:(int)key state:(BOOL)state repeat:(BOOL)repeat;

@end
