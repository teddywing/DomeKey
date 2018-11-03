//
//  Mappings.h
//  DomeKey
//
//  Created by tw on 10/4/18.
//  Copyright © 2018 tw. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <notify.h>

#import "dome_key_map.h"

@interface Mappings : NSObject

- (State *)state;

- (void)observeReloadNotification;

- (void)reloadMappings;
+ (void)reloadMappings;
+ (uint32_t)dispatchReload;

@end
