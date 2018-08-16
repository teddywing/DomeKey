//
//  main.m
//  DomeKey
//
//  Created by tw on 8/6/18.
//  Copyright © 2018 tw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        [NSApplication sharedApplication];
        AppDelegate *app = [[AppDelegate alloc] init];
        [NSApp setDelegate:app];

        // insert code here...
        NSLog(@"Hello, World!");

        [NSApp run];
    }
    return 0;
}
