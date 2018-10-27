#ifndef LOG_H
#define LOG_H

#define LogDebug(...) \
    if ([[[[NSProcessInfo processInfo] environment] \
        objectForKey:@"DOME_KEY_DEBUG"] isEqualToString:@"1"]) { \
        NSLog(__VA_ARGS__); \
    }

#endif /* LOG_H */
