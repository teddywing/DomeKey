//
//  LicenseHandler.m
//  DomeKey
//
//  Created by tw on 10/24/18.
//  Copyright © 2018 tw. All rights reserved.
//

#import "LicenseHandler.h"

static NSString * const LICENSE_FILE_NAME = @"license.plist";

@implementation LicenseHandler

+ (void)check
{
    if ([self licenseFileExists]) {
        if (![self validateLicense]) {
            eprintf(
                "The license file '%s' is invalid. "
                "Try adding your license again using the `--license` flag.\n",
                [[[self licensePath] path] UTF8String]
            );

            // TODO: then do trial
        }
    }
    else {
        // run do_trial();
        printf("TODO: do trial\n");
    }
}

+ (void)addLicense:(NSString *)filePath
{
    // printf("current directory: %s\n", [[[NSFileManager defaultManager] currentDirectoryPath] UTF8String]);

    NSError *error = nil;

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
        [[NSWorkspace sharedWorkspace]
            recycleURLs:[NSArray arrayWithObject:[self licensePath]]
            completionHandler:^(NSDictionary<NSURL *,NSURL *> *newURLs, NSError *error) {
                if (error) {
                    eprintf("%s\n", [[error localizedDescription] UTF8String]);
                }
            }];
    }

    // Copy license file into path
    // Validate license
    // If license doesn't validate, remove copied file
    // If license does validate, print a success message
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

@end
