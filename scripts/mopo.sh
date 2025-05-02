#!/bin/bash

# Set the language directory to the current working directory
if [ -n "$1" ]; then
  langDir="$1"
else
langDir=$PWD
fi

if [ ! -d "$langDir" ]; then
  echo "Error: Directory '$langDir' does not exist."
  exit 1
fi

echo "Processing .po files in directory: $langDir"

# Process all .po files in the directory
find "$langDir" -name '*.po' | while read -r f; do
	moFile="${f%.po}.mo"

	# Generate .mo file
	msgfmt -o "$moFile" "$f"
	echo "Generated $moFile"
done
