#!/bin/sh

set -e

#######################################
#   Table extration with User prompt  #
#######################################
DIR="$HOME/ownCloud/Documents/netis-fleet/OPEX/Bureau_Mauritius"

# Llama Prompt
llama-parse parse "$DIR/Live_Netis_Fuel_UG.pdf" \
  -o "$DIR/Live_Netis_Fuel_UG.md" \
  -f markdown \
  -pi "Split date and time into two different columns. Remove comma separators from cell values. Convert mileage columns to numeric datatype. Also align all columns in the sheets. Concatenate the tables."

# markdown
MD_FILE="$DIR/Live_Netis_Fuel_UG.md"
OUTPUT_XLSX="$DIR/Live_Netis_Fuel_UG.xlsx"

# Extract tables
GREEN='\033[0;32m'
NC='\033[0m' # No Color
echo "${GREEN}Extracting tables...${NC}"
sed -n '/^|/p' "$MD_FILE" > "tables.md"

# Remove separator rows (---...)
sed '/^|[-| ]*|$/d' tables.md > tables_no_separators.md
sed '/^| *Date *|/d' tables_no_separators.md > tables_cleaned.md

# XLSX
/usr/bin/python3 - <<EOF
import pandas as pd
import re

# Read cleaned table data
with open("tables_cleaned.md", "r") as file:
    lines = file.readlines()

table = []

for line in lines:
    if re.match(r'^\|.*\|$', line):  # Identify table rows
        columns = [col.strip() for col in line.strip().split('|')[1:-1]]  # Ignore first & last empty splits
        if columns:
            table.append(columns)

# DataFrame
df = pd.DataFrame(table[1:], columns=table[0])  # First row as headers, rest as data

# Spreadsheet
df.to_excel("$OUTPUT_XLSX", sheet_name="NFB_UG", index=False)

print("Excel file saved:", "$OUTPUT_XLSX")
EOF

# Cleanup
rm -f "tables.md" "tables_no_separators.md" "tables_cleaned.md"
echo "Done."
