#!/bin/sh

sed -n \
	's/[[:space:]]*try(string_case_insensitive("\([[:alnum:]]\{1,\}\)"))/\1/p' \
	lib/dome-key-map/src/parser.rs
