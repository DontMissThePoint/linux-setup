#!/bin/bash

# Function to convert a single .txt file to markdown
convert_to_markdown() {
  input_file="$1"
  output_file="${input_file%.txt}.md"
  pandoc -t markdown -o "$output_file" "$input_file"
  echo "Converted: $input_file to $output_file"
  rm "$input_file"  # Delete the original .txt file
}

# Find all .txt files in subfolders and convert them
find . -type f -name "*.txt" | while read -r txt_file; do
  convert_to_markdown "$txt_file"
done
