SOURCE_FILES := $(shell find DomeKey lib \
	-type f \
	-name '*.h' \
	-or -name '*.m' \
	-or -name '*.c')

RUST_DIR := lib/dome-key-map
RUST_LIB := target/debug/libdome_key_map.a

DEBUG_PRODUCT := ~/Library/Developer/Xcode/DerivedData/DomeKey-*/Build/Products/Debug/DomeKey


.PHONY: build
build: $(DEBUG_PRODUCT)

$(DEBUG_PRODUCT): $(SOURCE_FILES) | $(RUST_LIB)
	xcodebuild -scheme DomeKey -configuration Debug

$(RUST_LIB):
	$(MAKE) -C $(RUST_DIR) $@

.PHONY: run
run: build
	$(DEBUG_PRODUCT)
