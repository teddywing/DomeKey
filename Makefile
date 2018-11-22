SOURCE_FILES := $(shell find DomeKey lib \
	-type f \
	-name '*.h' \
	-or -name '*.m' \
	-or -name '*.c')
VERSION := $(shell sed -n '/VERSION/ s/^.*"\([[:digit:]\.]*\)".*$$/\1/p' DomeKey/main.m)

RUST_DIR := lib/dome-key-map
RUST_LOCAL_LIB := target/debug/libdome_key_map.a
RUST_LIB := $(RUST_DIR)/$(RUST_LOCAL_LIB)
RUST_SOURCE_FILES := $(shell find $(RUST_DIR)/src -type f -name '*.rs')

RUST_LOCAL_LIB_RELEASE := target/release/libdome_key_map.a
RUST_LIB_RELEASE := $(RUST_DIR)/$(RUST_LOCAL_LIB_RELEASE)

DEBUG_PRODUCT := build/Build/Products/Debug/DomeKey
RELEASE_PRODUCT := build/Build/Products/Release/DomeKey
ARCHIVE_PRODUCT := build/Release.xcarchive/Products/usr/local/bin/DomeKey

LAUNCHD_PLIST := pkg/com.teddywing.dome-key.plist


# Build debug

.PHONY: build
build: $(DEBUG_PRODUCT)

$(DEBUG_PRODUCT): $(SOURCE_FILES) $(RUST_LIB)
	xcodebuild -scheme DomeKey -configuration Debug -derivedDataPath build

$(RUST_LIB): $(RUST_SOURCE_FILES)
	$(MAKE) -C $(RUST_DIR) $(RUST_LOCAL_LIB)


# Build release

.PHONY: build-release
build-release: $(RELEASE_PRODUCT)

$(RELEASE_PRODUCT): $(SOURCE_FILES) $(RUST_LIB_RELEASE)
	xcodebuild -scheme DomeKey -configuration Release -derivedDataPath build

$(RUST_LIB_RELEASE): $(RUST_SOURCE_FILES)
	$(MAKE) -C $(RUST_DIR) $(RUST_LOCAL_LIB_RELEASE)


# Archive

.PHONY: archive
archive: $(ARCHIVE_PRODUCT)

$(ARCHIVE_PRODUCT): clean-release
	xcodebuild -project DomeKey.xcodeproj \
		-scheme DomeKey \
		-configuration Release \
		archive \
		-archivePath build/Release.xcarchive


# Sounds

DomeKey/sound_data.h: sounds/*.mp3
	: > $@
	sed -e 's,^\([^$$]\),// \1,' -e 's,^$$,//,' LICENSE >> $@
	echo >> $@
	echo '#ifndef SOUND_DATA_H' >> $@
	echo '#define SOUND_DATA_H' >> $@
	echo >> $@
	$(foreach f,$^,xxd -include  $(f) >> $@;)
	echo >> $@
	echo '#endif /* SOUND_DATA_H */' >> $@


# Clean

.PHONY: clean
clean:
	xcodebuild -scheme DomeKey -configuration Debug -derivedDataPath build clean

.PHONY: clean-release
clean-release:
	xcodebuild -scheme DomeKey -configuration Release -derivedDataPath build  clean


# Run

.PHONY: run
run: build
	$(DEBUG_PRODUCT) --daemon


# Documentation

.PHONY: doc
doc: doc/dome-key.1 doc/dome-key-mappings.7

.PHONY: clean-doc
doc-clean: doc/dome-key.1.intermediate.txt
	rm $<

doc/dome-key.1: doc/dome-key.1.intermediate.txt
	a2x --no-xmllint --format manpage $<

doc/dome-key.1.intermediate.txt: doc/dome-key.1.txt $(LAUNCHD_PLIST) LICENSE
	sed 's/^/	/' $(LAUNCHD_PLIST) | \
		perl -0777 -pe '$$plist = <STDIN>; s/\$$\{PLIST}\n/$${plist}/' $< > "$@.0"
	perl -0777 -pe '$$license = <STDIN>; s/\$$\{LICENSE}\n/$${license}/' \
		< LICENSE "$@.0" > $@
	rm "$@.0"

doc/dome-key-mappings.7: doc/dome-key-mappings.7.txt
	a2x --no-xmllint --format manpage $<

.PHONY: doc-html
doc-html: doc/dome-key.1.html doc/dome-key-mappings.7.html

doc/dome-key.1.html: doc/dome-key.1.intermediate.txt
	a2x --no-xmllint --format xhtml $<

doc/dome-key-mappings.7.html: doc/dome-key-mappings.7.txt
	a2x --no-xmllint --format xhtml $<


# Distribution

.PHONY: dist-all
dist-all: dist/dome-key dist/dome-key.1 dist/dome-key-mappings.7

dist:
	mkdir -p dist

dist/dome-key: $(ARCHIVE_PRODUCT) dist
	cp $< $@

dist/dome-key.1: doc/dome-key.1 dist
	cp $< $@

dist/dome-key-mappings.7: doc/dome-key-mappings.7 dist
	cp $< $@


# Packaging

.PHONY: pkg
pkg: HomebrewFormula/dome-key.rb

HomebrewFormula/dome-key.rb: pkg/dome-key.in.rb \
		pkg/com.teddywing.dome-key.plist \
		DomeKey/main.m \
		dome-key_$(VERSION).tar.bz2
	pkg/generate_homebrew_formula.py > $@

.PHONY: tar
tar: dome-key_$(VERSION).tar.bz2

dome-key_$(VERSION).tar.bz2: dist-all
	tar cjv -s /dist/dome-key_$(VERSION)/ -f $@ dist
