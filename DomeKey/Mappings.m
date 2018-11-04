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

static State *_state;

@implementation Mappings

- (void)dealloc
{
    dome_key_state_free(_state);
}

- (State *)state
{
    return _state;
}

- (void)observeReloadNotification
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
        // TODO: Mappings reloaded message

        [Mappings reloadMappings];
    }
}

- (void)reloadMappings
{
    [Mappings reloadMappings];
}

+ (void)reloadMappings
{
    dome_key_state_free(_state);
    _state = dome_key_state_new();
    dome_key_state_load_map_group(_state);
}

+ (uint32_t)dispatchReload
{
    uint32_t status = notify_post(NOTIFICATION_NAME_RELOAD);
    if (status != 0) {
        // Notification failed
        teprintf("Reload notification failed");
    }
    else {
        // Run `dome_key_state_load_map_group()` to print any error messages
        // from parsing.
        State *tmp = dome_key_state_new();
        dome_key_state_load_map_group(tmp);
        dome_key_state_free(tmp);
    }

    return status;
}

@end
