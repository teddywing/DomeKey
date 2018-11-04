//
//  main.m
//  DomeKey
//
//  Created by tw on 8/6/18.
//  Copyright © 2018 tw. All rights reserved.
//

#include <sysexits.h>

#import <Foundation/Foundation.h>

#import "AppDelegate.h"
#import "LicenseHandler.h"
#import "Mappings.h"
#import "dome_key_map.h"
#import "log.h"

static const char *VERSION = "1.0";

int main(int argc, const char * argv[]) {
    Config *config = dome_key_config_get();

    if (!config) {
        teprintf("Unable to get config");
        return EX_CONFIG;
    }

    config = dome_key_parse_args(argv, argc, config);

    dome_key_logger_init();

    if (config->args.license) {
        [LicenseHandler addLicense:[NSString
            stringWithCString:config->args.license
            encoding:NSUTF8StringEncoding]];

        return EX_OK;
    } else {
        [LicenseHandler check];
    }

    if (config->args.reload) {
        return [Mappings dispatchReload];
    } else if (config->args.daemon) {
        @autoreleasepool {
            [NSApplication sharedApplication];
            AppDelegate *app = [[AppDelegate alloc] initWithConfig:config];
            [NSApp setDelegate:app];

            [NSApp run];
        }
    } else if (config->args.version) {
        printf("DomeKey version %s\n", VERSION);
    }

    dome_key_config_free(config);

    return EX_OK;
}
