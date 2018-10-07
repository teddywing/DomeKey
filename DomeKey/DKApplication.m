//
//  DKApplication.m
//  DomeKey
//
//  Created by tw on 10/6/18.
//  Copyright © 2018 tw. All rights reserved.
//

#import "DKApplication.h"

@implementation DKApplication

// https://weblog.rogueamoeba.com/2007/09/29/
- (void)sendEvent:(NSEvent *)theEvent
{
    if ([theEvent type] == NSSystemDefined && [theEvent subtype] == 8) {
        int key_code = (([theEvent data1] & 0xFFFF0000) >> 16);
        int key_flags = ([theEvent data1] & 0x0000FFFF);
        int key_state = (((key_flags & 0xFF00) >> 8)) == 0xA;
        int key_repeat = (key_flags & 0x1);

        [self mediaKeyEvent:key_code state:key_state repeat:key_repeat];
    }

    [super sendEvent:theEvent];
}

// https://weblog.rogueamoeba.com/2007/09/29/
- (void)mediaKeyEvent:(int)key state:(BOOL)state repeat:(BOOL)repeat
{
    BOOL pressed_and_released = !state;

    if (pressed_and_released) {
        switch (key) {
        case NX_KEYTYPE_PLAY:
            NSLog(@"Play");

            break;
        case NX_KEYTYPE_FAST:
            NSLog(@"Fast");

            break;
        case NX_KEYTYPE_REWIND:
            NSLog(@"Rewind");

            break;
        }
    }
}

@end
