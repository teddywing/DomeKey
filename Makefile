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

.PHONY: clean
clean:
	xcodebuild -scheme DomeKey -configuration Debug clean

.PHONY: run
run: build
	$(DEBUG_PRODUCT) --daemon

DomeKey/sound_data.h: sounds/*.mp3
	: > $@
	echo '#ifndef SOUND_DATA_H' >> $@
	echo '#define SOUND_DATA_H' >> $@
	echo >> $@
	$(foreach f,$^,xxd -include  $(f) >> $@;)
	echo >> $@
	echo '#endif /* SOUND_DATA_H */' >> $@

doc/dome-key.1: doc/dome-key.1.txt
	a2x --no-xmllint --format manpage $<

.PHONY: doc
doc: doc/dome-key.1
