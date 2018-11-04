#include "log.h"

void teprintf(char const *fmt, ...) {
    // Format the current time
    time_t raw_time;
    size_t buffer_size = 35;
    char buffer[buffer_size];
    time(&raw_time);
    struct tm *now = localtime(&raw_time);
    strftime(buffer, buffer_size, "%Y-%m-%dT%H:%M:%S%z", now);

    // Prefix the time to the format string
    char *timestampped_fmt = malloc(strlen(buffer) + strlen(fmt) + 5);
    strcpy(timestampped_fmt, buffer);
    strcat(timestampped_fmt, " - ");
    strcat(timestampped_fmt, fmt);
    strcat(timestampped_fmt, "\n");

    // Print the log message
    va_list args;
    va_start(args, fmt);
    vfprintf(stderr, timestampped_fmt, args);
    va_end(args);

    free(timestampped_fmt);
}
