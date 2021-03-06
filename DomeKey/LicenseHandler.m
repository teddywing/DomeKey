//
//  LicenseHandler.m
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

#import "LicenseHandler.h"

static NSString * const LICENSE_FILE_NAME = @"license.plist";

@implementation LicenseHandler

+ (void)check
{
    if ([self licenseFileExists]) {
        if (![self validateLicense]) {
            [self printInvalidLicenseMessage];

            dome_key_do_trial();
        }
    }
    else {
        dome_key_do_trial();
    }
}

+ (void)addLicense:(NSString *)filePath
{
    NSError *error = nil;

    [self trashFileAtURL:[self licensePath]];

    // Copy license file to XDG_DATA_HOME
    BOOL copied = [[NSFileManager defaultManager]
        copyItemAtPath:[filePath stringByExpandingTildeInPath]
        toPath:[[self licensePath] path]
        error:&error];

    if (!copied) {
        eprintf("%s\n", [[error localizedDescription] UTF8String]);
    }

    BOOL validated = [self validateLicense];

    if (validated) {
        printf("Thank you for registering DomeKey!\n");
    }
    else {
        [self printInvalidLicenseMessage];

        [self trashFileAtURL:[self licensePath]];
    }
}

+ (void)trashFileAtURL:(NSURL *)theURL
{
    NSError *error = nil;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"
#ifdef AVAILABLE_MAC_OS_X_VERSION_10_8_AND_LATER
    // NSTrashDirectory availability starts in 10.8
    NSURL *trash_url = [[NSFileManager defaultManager]
        URLForDirectory:NSTrashDirectory
        inDomain:NSUserDomainMask
        appropriateForURL:nil
        create:NO
        error:&error];

    if (error) {
        eprintf("%s\n", [[error localizedDescription] UTF8String]);
    }
#else
    NSURL *trash_url = [NSURL
        fileURLWithPath:[NSHomeDirectory()
            stringByAppendingPathComponent:@".Trash"]
        isDirectory:YES];
#endif
#pragma clang diagnostic pop

    BOOL moved = [[NSFileManager defaultManager]
        moveItemAtURL:theURL
        toURL:[trash_url
            URLByAppendingPathComponent:[self trashedLicenseFilename]]
        error:&error];

    if (
        !moved &&
        !(
            [error code] == NSFileNoSuchFileError &&
            [error domain] == NSCocoaErrorDomain
        )
    ) {
        eprintf("%s\n", [[error localizedDescription] UTF8String]);
    }
}

+ (NSString *)trashedLicenseFilename
{
    NSDate *now = [NSDate date];
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:@"yyyy-MM-dd-HH.mm.ss"];
    NSString *date_string = [date_formatter stringFromDate:now];
    return [NSString
        stringWithFormat:@"dome-key-license-%@.plist",
        date_string];
}

+ (NSURL *)licensePath
{
    return [[XDG domeKeyDataPath]
        URLByAppendingPathComponent:LICENSE_FILE_NAME
        isDirectory:NO];
}

+ (BOOL)licenseFileExists
{
    NSURL *path = [self licensePath];

    return [[NSFileManager defaultManager]
        fileExistsAtPath:[path path]];
}

+ (BOOL)validateLicense
{
    NSURL *path = [self licensePath];
    CFURLRef cf_path = CFBridgingRetain(path);

    CFMutableStringRef key = CFStringCreateMutable(NULL, 0);
    CFStringAppend(key, CFSTR("0xD536F17DA75620927B"));
    CFStringAppend(key, CFSTR("D"));
    CFStringAppend(key, CFSTR("D"));
    CFStringAppend(key, CFSTR("029DDFF1"));
    CFStringAppend(key, CFSTR("E"));
    CFStringAppend(key, CFSTR("3"));
    CFStringAppend(key, CFSTR("3"));
    CFStringAppend(key, CFSTR("F620B3AFEE024F3A8FC724BF93A"));
    CFStringAppend(key, CFSTR("906AF20712D39EB5C931BF63068612"));
    CFStringAppend(key, CFSTR("B0741791485D470745E7C71DC8287A"));
    CFStringAppend(key, CFSTR(""));
    CFStringAppend(key, CFSTR("1"));
    CFStringAppend(key, CFSTR("1"));
    CFStringAppend(key, CFSTR("9517FC3C60CC3FBF6DA13A0A2F0C"));
    CFStringAppend(key, CFSTR(""));
    CFStringAppend(key, CFSTR("D"));
    CFStringAppend(key, CFSTR("D"));
    CFStringAppend(key, CFSTR("5F14977DEEB6E32C3B039AADCD3D"));
    CFStringAppend(key, CFSTR("0C97BD94FC4E0714C2F"));
    CFStringAppend(key, CFSTR("8"));
    CFStringAppend(key, CFSTR("8"));
    CFStringAppend(key, CFSTR("B010622D2"));
    CFStringAppend(key, CFSTR("36FB7"));
    CFStringAppend(key, CFSTR("5"));
    CFStringAppend(key, CFSTR("5"));
    CFStringAppend(key, CFSTR("9AEF648830DA73C584DE402"));
    CFStringAppend(key, CFSTR("4AFD071F4F4E90021B"));

    BOOL is_key_loaded = APSetKey(key);
    BOOL validated = NO;

    if (is_key_loaded) {
        validated = APVerifyLicenseFile(cf_path);
    }

    CFRelease(cf_path);

    return validated;
}

+ (void)printInvalidLicenseMessage
{
    eprintf(
        "The license file '%s' is invalid. "
        "Try adding your license again using the `--license` flag.\n",
        [[[self licensePath] path] UTF8String]
    );
}

@end
