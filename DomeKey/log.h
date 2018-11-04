#ifndef LOG_H
#define LOG_H

#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define LogDebug(...) \
    if ([[[[NSProcessInfo processInfo] environment] \
        objectForKey:@"DOME_KEY_DEBUG"] isEqualToString:@"1"]) { \
        NSLog(__VA_ARGS__); \
    }


// Print a log message prefixed with a timestamp to stderr. Format:
// 2018-11-04T14:35:58+0100 - Format string
void teprintf(char const *fmt, ...);

#endif /* LOG_H */
