//
//  HeadphoneKey.m
//  DomeKey
//
//  Created by tw on 8/14/18.
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

#import "HeadphoneKey.h"

static const Sounds *sounds_inst;
static BOOL _play_audio;

@implementation HeadphoneKey

- (instancetype)init
{
    self = [super init];
    if (self) {
        _wired_headphone_event = [[HeadphoneKeyEventWired alloc]
            initWithDelegate:self];

        _key_buffer = [[NSMutableArray alloc] initWithCapacity:5];

        _mappings = [[Mappings alloc] init];
        [_mappings reloadMappings];
        [_mappings observeReloadNotification];

        // Should never be used. We initialise it just in case, but the real
        // default should always come from a `Config`, set in the Rust library.
        _timeout = TIMEOUT_DEFAULT;

        _play_audio = NO;
    }
    return self;
}

- (instancetype)initWithConfig:(Config *)config
{
    self = [self init];
    if (self) {
        _timeout = config->timeout;
        _play_audio = config->args.audio;

        if (_play_audio) {
            sounds_inst = [[Sounds alloc] init];
        }
    }
    return self;
}

- (void)headphoneButtonWasPressed:(HeadphoneButton)button
{
    [self handleDeadKey:button];
}

- (void)handleDeadKey:(HeadphoneButton)button
{
    NSNumber *storable_button = [NSNumber numberWithUnsignedInteger:button];
    [_key_buffer addObject:storable_button];

    [NSObject cancelPreviousPerformRequestsWithTarget:self
        selector:@selector(runAction)
        object:nil];

    NSTimeInterval timeout_seconds = _timeout / 1000.0;
    [self performSelector:@selector(runAction)
        withObject:nil
        afterDelay:timeout_seconds];
}

- (void)runAction
{
    LogDebug(@"%@", _key_buffer);

    NSUInteger count = [_key_buffer count];
    HeadphoneButton buttons[count];

    for (int i = 0; i < count; i++) {
        buttons[i] = (HeadphoneButton)[[_key_buffer objectAtIndex:i] intValue];
    }

    Trigger trigger = {
        .buttons = buttons,
        .length = count
    };

    dome_key_run_key_action([_mappings state], trigger, on_mode_change);

    [_key_buffer removeAllObjects];
}

void on_mode_change(ModeChange mode_change) {
    if (!_play_audio) {
        return;
    }

    switch (mode_change) {
    case ModeChange_Activated:
        [sounds_inst playModeActivated];

        break;
    case ModeChange_Deactivated:
        [sounds_inst playModeDeactivated];

        break;
    }
}

@end
