//
//  Mappings.h
//  DomeKey
//
//  Created by tw on 10/4/18.
//  Copyright © 2018 tw. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <notify.h>

@interface Mappings : NSObject

+ (void)observeReloadNotification;
+ (uint32_t)dispatchReload;

@end
