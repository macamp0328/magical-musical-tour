#!/bin/bash

# Output file
OUTPUT_FILE="repo_contents.txt"
echo "" > "$OUTPUT_FILE"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# util_scripts/.consolidateignore

# Read ignore patterns if .consolidateignore exists and disregard comments and blank lines
IGNORE_PATTERNS=()
if [ -f "$DIR/.consolidateignore" ]; then
  while IFS= read -r line; do
    # Skip comments and blank lines
    if [[ $line =~ ^[[:space:]]*# || -z $line ]]; then
      continue
    fi
    IGNORE_PATTERNS+=("$line")
  done < "$DIR/.consolidateignore"
fi

# Print ignore patterns for debugging
echo "Ignore Patterns:"
for pattern in "${IGNORE_PATTERNS[@]}"; do
  echo "$pattern"
done
echo "End of Ignore Patterns"

# Function to check if a file should be ignored
should_ignore() {
  for pattern in "${IGNORE_PATTERNS[@]}"; do
    # Remove trailing slash from directory patterns
    if [[ ${pattern: -1} == "/" ]]; then
      pattern=${pattern%/}
    fi
    # Check if file path contains directory pattern or ends with file type pattern
    if [[ $1 == *"$pattern"* || $1 == *"$pattern" ]]; then
      return 0
    fi
  done
  return 1
}

# Loop through all files, check if they should be ignored, and concatenate
find . -type f -not -name "$OUTPUT_FILE" -print0 | while IFS= read -r -d $'\0' file; do
  if ! should_ignore "$file"; then
    echo -e "\n\n===== START OF $file =====\n" >> "$OUTPUT_FILE"
    echo -e "File: $file" >> "$OUTPUT_FILE"
    echo -e "Size: $(du -h "$file" | cut -f1)" >> "$OUTPUT_FILE"
    echo -e "Last Modified: $(date -r "$file")\n" >> "$OUTPUT_FILE"
    head -n 100 "$file" >> "$OUTPUT_FILE"
    echo -e "\n===== END OF $file =====\n" >> "$OUTPUT_FILE"
  fi
done
