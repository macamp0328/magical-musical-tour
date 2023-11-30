#!/bin/bash

# Output file
OUTPUT_FILE="repo_contents.txt"
echo "" > "$OUTPUT_FILE"

echo $PATH

# Read ignore patterns if .consolidateignore exists
IGNORE_PATTERNS=()
if [ -f .consolidateignore ]; then
  while IFS= read -r line; do
    IGNORE_PATTERNS+=("$line")
  done < .consolidateignore
fi

# Function to check if a file should be ignored
should_ignore() {
  for pattern in "${IGNORE_PATTERNS[@]}"; do
    if [[ $1 == $pattern ]]; then
      return 0
    fi
  done
  return 1
}

# Loop through all files and concatenate
find . -type f -not -path '*/\.*' -not -name "$OUTPUT_FILE" -print0 | while IFS= read -r -d $'\0' file; do
    echo "===== $file =====" >> repo_contents.txt
    cat "$file" >> repo_contents.txt
    echo "" >> repo_contents.txt
done
