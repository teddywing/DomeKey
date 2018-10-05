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

int main(int argc, const char * argv[]) {
    if (argc == 2 && strcmp(argv[1], "--reload-mappings") == 0) {
        [Mappings dispatchReload];

        return 0; // TODO: Return result of `notify_post`, and still log
    }

    @autoreleasepool {
        [NSApplication sharedApplication];
        AppDelegate *app = [[AppDelegate alloc] init];
        [NSApp setDelegate:app];

        // insert code here...
        NSLog(@"Hello, World!");

        [Mappings observeReloadNotification];

        [NSApp run];
    }
    return 0;
}
