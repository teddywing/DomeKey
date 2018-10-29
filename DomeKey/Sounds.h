//
//  Sounds.h
//  DomeKey
//
//  Created by tw on 10/29/18.
//  Copyright © 2018 tw. All rights reserved.
//

#import <AppKit/Appkit.h>

@interface Sounds : NSObject {
    NSSound *_mode_activated;
    NSSound *_mode_deactivated;
}

- (void)playModeActivated;
- (void)playModeDeactivated;

@end
