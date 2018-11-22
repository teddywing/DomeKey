//
//  main.m
//  DomeKey
//
//  Created by tw on 8/6/18.
//  Copyright © 2018 Teddy Wing. All rights reserved.
//
//  This file is part of DomeKey.
//
//  *Purchasing policy notice:* All users of the software are expected to
//  purchase a license from Teddy Wing unless they have a good reason not to
//  pay. Users who can't purchase a license may apply to receive one for free
//  at inquiry@domekey.teddywing.com. Users are free to:
//
//  * download, build, and modify the app;
//  * share the modified source code;
//  * share the purchased or custom-built binaries (with unmodified license
//    and contact info), provided that the purchasing policy is explained to
//    all potential users.
//
//  This software is available under a modified version of the Open Community
//  Indie Software License:
//
//  Permission to use, copy, modify, and/or distribute this software for any
//  purpose is hereby granted, subject to the following conditions:
//
//  * all copies retain the above copyright notice, the above purchasing
//    policy notice and this permission notice unmodified;
//
//  * all copies retain the name of the software (DomeKey), the name of the
//    author (Teddy Wing), and contact information (including, but not limited
//    to, inquiry@domekey.teddywing.com, and domekey.teddywing.com URLs)
//    unmodified;
//
//  * no fee is charged for distribution of the software;
//
//  * the best effort is made to explain the purchasing policy to all users of
//    the software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", AND THE AUTHOR AND COPYRIGHT HOLDERS
//  DISCLAIM ALL WARRANTIES, EXPRESS OR IMPLIED, WITH REGARD TO THIS SOFTWARE,
//  INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
//  A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY
//  DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA, OR PROFITS, WHETHER
//  IN AN ACTION OF CONTRACT, NEGLIGENCE, OR OTHER TORTIOUS ACTION, ARISING
//  OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
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
