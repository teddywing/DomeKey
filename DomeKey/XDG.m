//
//  XDG.m
//  DomeKey
//
//  Created by tw on 10/24/18.
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
