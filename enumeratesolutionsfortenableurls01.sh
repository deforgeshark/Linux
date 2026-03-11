#!/usr/bin/env bash

INPUT="/home/forge/Scripts/sticktheminhere.txt"
OUTPUT="/home/forge/templog.txt"

: > "$OUTPUT"   # Clear output file before starting

while IFS= read -r url; do
    # Skip empty lines and comments
    [[ -z "$url" || "$url" =~ ^[[:space:]]*# ]] && continue

    echo "Processing: $url"

    snippet=$(curl -s "$url" \
      | grep -zoP 'solution\K.{0,100}' \
      | head -c 100)

    if [[ -z "$snippet" ]]; then
        echo "$url    [no occurrence of 'solution']" >> "$OUTPUT"
    else
        echo "$url    $snippet" >> "$OUTPUT"
    fi

done < "$INPUT"

echo "Done. Output saved to $OUTPUT"
