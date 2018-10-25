#define eprintf(...) fprintf( \
    stderr, \
    "dome-key: error: " \
    __VA_ARGS__ \
)
