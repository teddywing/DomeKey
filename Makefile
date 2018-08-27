SOURCE_FILES = $(shell find DomeKey lib \
	-type f \
	-name '*.h' \
	-or -name '*.m' \
	-or -name '*.c')

RUST_DIR := lib/dome-key-map
RUST_LIB := target/debug/libdome_key_map.a


.PHONY: build
build: $(SOURCE_FILES)
	xcodebuild -scheme DomeKey -configuration Debug

$(RUST_LIB):
	$(MAKE) -C $(RUST_DIR) $@
