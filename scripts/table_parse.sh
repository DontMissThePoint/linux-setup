#!/bin/sh

set -e

DIR="$HOME/ownCloud/Documents/netis-fleet/OPEX/Bureau_Mauritius"

# Table extraction
llama-parse parse "$DIR/Live_Netis_Fuel_UG.pdf" \
  -o "$DIR/Live_Netis_Fuel_UG.json" \
  -f json \
  -pi "Split date and time into two different columns. Remove comma separators from cell values. Convert mileage columns to numeric datatype. Also align all columns in the sheets. Concatenate the tables."

# Input JSON
input_json="$DIR/Live_Netis_Fuel_UG.json"
output_xlsx="$DIR/Live_Netis_Fuel_UG.xlsx"
temp_tsv=$(mktemp)

# Extract all tables
# Identify objects with type "table" and extract their rows
jq -r '.[] | select(.type == "table") | .rows[] | @tsv' "$input_json" > "$temp_tsv"

# Extract the header from the first table's rows
header=$(jq -r '.[] | select(.type == "table") | .rows[0] | keys_unsorted | @tsv' "$input_json")
echo "$header" | cat - "$temp_tsv" > "${temp_tsv}_with_header"

# XLSX
/usr/bin/python3 - <<EOF
import pandas as pd

# Read the TSV file
df = pd.read_csv("${temp_tsv}_with_header", sep="\t")

# Write to Excel
df.to_excel("$output_xlsx", index=False, engine="openpyxl")
EOF

# Clean up temporary files
rm "$temp_tsv" "${temp_tsv}_with_header"
echo "Tables extracted and saved to $output_xlsx"
