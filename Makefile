SOURCE_FILES := $(shell find DomeKey lib \
	-type f \
	-name '*.h' \
	-or -name '*.m' \
	-or -name '*.c')

RUST_DIR := lib/dome-key-map
RUST_LOCAL_LIB := target/debug/libdome_key_map.a
RUST_LIB := $(RUST_DIR)/$(RUST_LOCAL_LIB)
RUST_SOURCE_FILES := $(shell find $(RUST_DIR)/src -type f -name '*.rs')

RUST_LOCAL_LIB_RELEASE := target/release/libdome_key_map.a
RUST_LIB_RELEASE := $(RUST_DIR)/$(RUST_LOCAL_LIB_RELEASE)

DEBUG_PRODUCT := build/Build/Products/Debug/DomeKey
RELEASE_PRODUCT := build/Build/Products/Release/DomeKey


.PHONY: build
build: $(DEBUG_PRODUCT)

$(DEBUG_PRODUCT): $(SOURCE_FILES) $(RUST_LIB)
	xcodebuild -scheme DomeKey -configuration Debug -derivedDataPath build

$(RUST_LIB): $(RUST_SOURCE_FILES)
	$(MAKE) -C $(RUST_DIR) $(RUST_LOCAL_LIB)

.PHONY: clean
clean:
	xcodebuild -scheme DomeKey -configuration Debug -derivedDataPath build clean

.PHONY: run
run: build
	$(DEBUG_PRODUCT) --daemon

.PHONY: build-release
build-release: $(RELEASE_PRODUCT)

$(RELEASE_PRODUCT): $(SOURCE_FILES) $(RUST_LIB_RELEASE)
	xcodebuild -scheme DomeKey -configuration Release -derivedDataPath build

$(RUST_LIB_RELEASE): $(RUST_SOURCE_FILES)
	$(MAKE) -C $(RUST_DIR) $(RUST_LOCAL_LIB_RELEASE)

.PHONY: clean-release
clean-release:
	xcodebuild -scheme DomeKey -configuration Release -derivedDataPath build  clean

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

.PHONY: dist-all
dist-all: dist/dome-key

dist:
	mkdir -p dist

dist/dome-key: $(RELEASE_PRODUCT) dist
	cp $< $@
