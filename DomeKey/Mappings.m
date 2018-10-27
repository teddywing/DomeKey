//
//  Mappings.m
//  DomeKey
//
//  Created by tw on 10/4/18.
//  Copyright © 2018 tw. All rights reserved.
//

#import "Mappings.h"

#define NOTIFICATION_NAME_RELOAD "com.teddywing.DomeKey.reload_mappings"

static const CFStringRef CFNOTIFICATION_NAME_RELOAD = CFSTR(NOTIFICATION_NAME_RELOAD);

@implementation Mappings

+ (void)observeReloadNotification
{
    CFNotificationCenterRef center = CFNotificationCenterGetDarwinNotifyCenter();

    if (center) {
        CFNotificationCenterAddObserver(
            center,
            NULL,
            reload_mappings,
            CFNOTIFICATION_NAME_RELOAD,
            NULL,
            CFNotificationSuspensionBehaviorDeliverImmediately
        );
    }
}

void reload_mappings(
    CFNotificationCenterRef center,
    void *observer,
    CFStringRef name,
    const void *object,
    CFDictionaryRef userInfo
) {
    if (CFStringCompare(name, CFNOTIFICATION_NAME_RELOAD, 0) ==
            kCFCompareEqualTo) {
        // Reload mappings
        NSLog(@"TODO: reload mappings");
    }
}

+ (uint32_t)dispatchReload
{
    uint32_t status = notify_post(NOTIFICATION_NAME_RELOAD);
    if (status != 0) {
        // Notification failed
        NSLog(@"Reload notification failed");
    }

    return status;
}

@end
