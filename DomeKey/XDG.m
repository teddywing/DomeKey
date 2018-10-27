//
//  XDG.m
//  DomeKey
//
//  Created by tw on 10/24/18.
//  Copyright © 2018 tw. All rights reserved.
//

#import "XDG.h"

static NSString * const DOME_KEY_DIR = @"dome-key";

@implementation XDG

+ (NSURL *)dataPath
{
    NSString *xdg_data_home = [[[NSProcessInfo processInfo] environment]
        objectForKey:@"XDG_DATA_HOME"];

    if (!xdg_data_home) {
        xdg_data_home = [@"~/.local/share" stringByExpandingTildeInPath];
    }

    return [NSURL fileURLWithPath:xdg_data_home isDirectory:YES];
}

+ (NSURL *)domeKeyDataPath
{
    return [[self dataPath]
        URLByAppendingPathComponent:DOME_KEY_DIR
        isDirectory:YES];
}

@end
