//
//  HeadphoneKeyEventDelegate.h
//  DomeKey
//
//  Created by tw on 3/22/19.
//  Copyright © 2019 tw. All rights reserved.
//

#ifndef HeadphoneKeyEventDelegate_h
#define HeadphoneKeyEventDelegate_h

#include "dome_key_map.h"

@protocol HeadphoneKeyEventDelegate

- (void)headphoneButtonWasPressed:(HeadphoneButton)button;

@end

#endif /* HeadphoneKeyEventDelegate_h */
