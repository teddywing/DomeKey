#ifndef ERRORS_H
#define ERRORS_H

#define eprintf(...) fprintf( \
    stderr, \
    "dome-key: error: " \
    __VA_ARGS__ \
)

#endif /* ERRORS_H */
