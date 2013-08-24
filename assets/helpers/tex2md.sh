#!/bin/bash

SRC="$1"
DEST="$2"

cat "$SRC" |\
sed 's/PoemTitle/chapter/' |\
pandoc --smart --normalize --from=latex --to=markdown |\
sed 's/\([^\\]\)\\$/\1\\\\/' > "$DEST"

