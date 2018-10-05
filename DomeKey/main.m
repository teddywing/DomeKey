//
//  main.m
//  DomeKey
//
//  Created by tw on 8/6/18.
//  Copyright © 2018 tw. All rights reserved.
//

#import <Foundation/Foundation.h>
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

            [Mappings observeReloadNotification];

            [NSApp run];
        }
    }

    config_free(config);

    return 0;
}
