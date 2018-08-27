SOURCE_FILES = $(shell find DomeKey lib \
	-type f \
	-name '*.h' \
	-or -name '*.m' \
	-or -name '*.c')


.PHONY: build
build: $(SOURCE_FILES)
	xcodebuild -scheme DomeKey -configuration Debug
