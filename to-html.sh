#!/bin/sh
for i in ./src-tex_epub/*.tex; do echo $i; pandoc --smart --normalize -f latex -t html -o ./src-html/`basename $i`.html "$i"; done
