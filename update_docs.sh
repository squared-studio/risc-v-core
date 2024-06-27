#!/bin/bash

(find $(realpath ./rtl/) -type f -name "*.v" -o -name "*.sv") > ___list
# @$(foreach file, $(DES_LIB), $(if $(shell echo $(file) | sed "s/.*__no_upload__.*//g"), $(MAKE) gen_doc FILE=$(file), echo "");)

mkdir -p docs/rtl
rm -rf docs/rtl/*.md
rm -rf docs/rtl/*_top.svg
git submodule update --init ./sub/documenter

while IFS= read -r line; do
	echo "Creating document for ${line}"
  python ./sub/documenter/sv_documenter.py ${line} ./docs/rtl
done < "___list"

rm -rf ___list
