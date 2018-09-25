SOURCE_FILES := $(shell find DomeKey lib \
	-type f \
	-name '*.h' \
	-or -name '*.m' \
	-or -name '*.c')

RUST_DIR := lib/dome-key-map
RUST_LOCAL_LIB := target/debug/libdome_key_map.a
RUST_LIB := $(RUST_DIR)/$(RUST_LOCAL_LIB)
RUST_SOURCE_FILES := $(shell find $(RUST_DIR)/src -type f -name '*.rs')

DEBUG_PRODUCT := ~/Library/Developer/Xcode/DerivedData/DomeKey-*/Build/Products/Debug/DomeKey


.PHONY: build
build: $(DEBUG_PRODUCT)

$(DEBUG_PRODUCT): $(SOURCE_FILES) $(RUST_LIB)
	xcodebuild -scheme DomeKey -configuration Debug

$(RUST_LIB): $(RUST_SOURCE_FILES)
	$(MAKE) -C $(RUST_DIR) $(RUST_LOCAL_LIB)

.PHONY: run
run: build
	$(DEBUG_PRODUCT)
