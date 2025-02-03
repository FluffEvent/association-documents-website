#!/bin/sh

set -e

# Get app files directory
DIR='./app/app'
if [ $# -gt 0 ]; then
	DIR="$1"
	shift
fi
if [ ! -d "$DIR" ]; then
	echo "Directory '$DIR' does not exist"
	exit 1
fi


REPO='FluffEvent/association-documents'
BASE_URL="https://raw.githubusercontent.com/$REPO/refs/heads/main"

# List files to download
FILES=$(cat <<EOF
R%C3%A8glement%20Int%C3%A9rieur.md|reglement-interieur.md
Statuts.md|statuts.md
EOF
)

# Iterate over files
for FILE_INPUT in $FILES; do

	# Extract file path and destination
	IFS='|' read -r FILE_PATH FILE_DESTINATION <<-EOF
	$FILE_INPUT
	EOF

	echo "Handling file '$FILE_DESTINATION'..."

	# Get the latest commit hash for the file
	COMMIT_HASH=$(
		curl -fsSL "https://api.github.com/repos/$REPO/commits/main?path=$FILE_PATH" \
		| jq -r '.sha'
	)

	# Download file
	curl -fsSL "$BASE_URL/$FILE_PATH" \
		-o "/tmp/$FILE_DESTINATION"

	# Create destination file
	mkdir -p "$DIR/src/content/documents"
	touch "$DIR/src/content/documents/$FILE_DESTINATION"

	# Append front matter to destination file
	echo '---' > "$DIR/src/content/documents/$FILE_DESTINATION"
	echo 'version: "'"$COMMIT_HASH"'"' >> "$DIR/src/content/documents/$FILE_DESTINATION"
	echo '---' >> "$DIR/src/content/documents/$FILE_DESTINATION"

	# Append downloaded file content to destination file
	echo '' >> "$DIR/src/content/documents/$FILE_DESTINATION"
	cat "/tmp/$FILE_DESTINATION" >> "$DIR/src/content/documents/$FILE_DESTINATION"

	# Remove downloaded file
	rm "/tmp/$FILE_DESTINATION"

done
