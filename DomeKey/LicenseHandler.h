//
//  LicenseHandler.h
//  DomeKey
//
//  Created by tw on 10/24/18.
//  Copyright © 2018 tw. All rights reserved.
//

#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>

#import "AquaticPrime.h"
#import "XDG.h"
#import "errors.h"

@interface LicenseHandler : NSObject

+ (void)check;
+ (void)addLicense:(NSString *)filePath;

@end
