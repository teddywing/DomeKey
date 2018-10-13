//
//  main.m
//  DomeKey
//
//  Created by tw on 8/6/18.
//  Copyright © 2018 tw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKApplication.h"
#import "AppDelegate.h"
#import "Mappings.h"
#import "dome_key_map.h"

int main(int argc, const char * argv[]) {
    Config *config = c_parse_args(argv, argc);

    if (config->args.reload) {
        return [Mappings dispatchReload];
    } else if (config->args.daemon) {
        @autoreleasepool {
            [NSApplication sharedApplication];
            AppDelegate *app = [[AppDelegate alloc] init];
            [NSApp setDelegate:app];

            // insert code here...
            NSLog(@"Hello, World!");

            NSEvent *event1 = [NSEvent otherEventWithType:NSSystemDefined
                               location:NSZeroPoint
                          modifierFlags:0xa00
                              timestamp:0.0
                           windowNumber:0
                                context:nil
                                subtype:NSScreenChangedEventType
                                  data1:(NX_KEYTYPE_PLAY << 16) | (0xa << 8)
                                  data2:-1];
            CGEventRef cg_event1 = [event1 CGEvent];
            CGEventPost(kCGHIDEventTap, cg_event1);
            CFRelease(cg_event1);
            NSEvent *event2 = [NSEvent otherEventWithType:NSSystemDefined
                               location:NSZeroPoint
                          modifierFlags:0xb00
                              timestamp:0.0
                           windowNumber:0
                                context:nil
                                subtype:NSScreenChangedEventType
                                  data1:(NX_KEYTYPE_PLAY << 16) | (0xb << 8)
                                  data2:-1];
            CGEventRef cg_event2 = [event2 CGEvent];
            CGEventPost(kCGHIDEventTap, cg_event2);
            CFRelease(cg_event2);

            [Mappings observeReloadNotification];

            [NSApp run];
        }
    }

    config_free(config);

    return 0;
}
