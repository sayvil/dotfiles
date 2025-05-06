#!/bin/bash

# filepath: /Users/skennon/Sites/_GIT/_mine/scripts/mopo-remote.sh

# Check if a directory is passed as an argument
if [ -n "$1" ]; then
	langDir="$1"
else
	langDir=$PWD
fi

# Verify that the directory exists
if [ ! -d "$langDir" ]; then
	echo "Error: Directory '$langDir' does not exist."
	exit 1
fi

echo "Processing .po files in directory: $langDir"

# Process all .po files in the directory, excluding node_modules
find "$langDir" -path "$langDir/node_modules" -prune -o -name '*.po' -print | while read -r f; do
	moFile="${f%.po}.mo"

	# Generate .mo file
	msgfmt -o "$moFile" "$f"
	echo "Generated $moFile"
done
