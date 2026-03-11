#!/usr/bin/env bash
set -euo pipefail

INPUT="/home/forge/Scripts/sticktheminhere.txt"
OUTPUT="/home/forge/templog.txt"

: > "$OUTPUT"  # truncate output

while IFS= read -r url; do
  # Skip empty lines and comments
  [[ -z "$url" || "$url" =~ ^[[:space:]]*# ]] && continue

  # Fetch and extract next 100 chars after 'solution'
  snippet=$(curl -s --fail --max-time 20 "$url" \
    | perl -0777 -ne 'if(/solution(.*)/s){print substr($1,0,100)}')

  status=$?
  if [[ $status -ne 0 ]]; then
    printf "%s\t%s\n" "$url" "[curl failed or timed out]" >> "$OUTPUT"
    continue
  fi

  if [[ -z "$snippet" ]]; then
    printf "%s\t%s\n" "$url" "[no occurrence of 'solution']" >> "$OUTPUT"
  else
    printf "%s\t%s\n" "$url" "$snippet" >> "$OUTPUT"
  fi
done < "$INPUT"

echo "Done. Wrote results to: $OUTPUT"
