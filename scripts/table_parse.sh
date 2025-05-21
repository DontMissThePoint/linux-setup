#!/bin/sh

set -e

DIR="$HOME/ownCloud/Documents/netis-fleet/OPEX/Bureau_Mauritius"
OUTPUT_XLSX="$DIR/Live_Netis_Fuel_UG.xlsx"

# Llama Prompt
# llama-parse parse "$DIR/Live_Netis_Fuel_UG.pdf" \
# 	-o "$DIR/Live_Netis_Fuel_UG.md" \
# 	-f markdown \
# 	-pi "Recognize vehicle IDs. Split date and time into two different columns. Remove comma separators from cell values. Convert mileage columns to numeric datatype. Also align all columns in the table."

# JSON
# csvjson "$DIR/../../fleet_consumption.tsv" | jq 'unique_by(.Mileage)'
# csvjson "$DIR/Live_Netis_Fuel_UG.csv" | jsonrepair -o "$DIR/Live_Netis_Fuel_UG.json"
# jq '.pages[].items[] | select(.type=="table").rows | unique' | jsonrepair --overwrite

# markdown
# MD_FILE="$DIR/Live_Netis_Fuel_UG.md"

# Extract tables
GREEN='\033[0;32m'
NC='\033[0m' # No Color
echo "${GREEN}Extracting tables...${NC}"
# sed -n '/^|/p' "$MD_FILE" >"tables.md"

# # Remove separator rows (---...)
# sed '/^|[-| ]*|$/d' tables.md >tables_no_separators.md
# sed '/^| *Date *|/d' tables_no_separators.md >tables_cleaned.md

# XLSX
"$HOMEBREW_PREFIX"/bin/python3 - <<EOF
import os
from dotenv import load_dotenv

load_dotenv()

from llama_cloud_services import LlamaParse

# sync
result = parser.parse("$DIR/Live_Netis_Fuel_UG.pdf")

# sync batch
# results = parser.parse(["./my_file1.pdf", "./my_file2.pdf"])

# async
# result = await parser.aparse("./my_file.pdf")

# async batch
# results = await parser.aparse(["./my_file1.pdf", "./my_file2.pdf"])

parser = LlamaParse(
    # api_key="llx-...",  # can also be set in your env as LLAMA_CLOUD_API_KEY
    num_workers=4,       # if multiple files passed, split in $(num_workers) API calls
    verbose=True,
    language="en",       # optionally define a language, default=en
    result_type="markdown",
    system_prompt_append="Recognize vehicle IDs. Split date and time into two different columns. Remove comma separators from cell values. Convert mileage columns to numeric datatype.",
    user_prompt="Also align all columns in the table."
)

# import pandas as pd
# import re
# import os
#
# # Read cleaned table data
# with open("tables_cleaned.md", "r") as file:
#     lines = file.readlines()
#
# table = []
#
# for line in lines:
#     if re.match(r'^\|.*\|$', line):  # Identify table rows
#         columns = [col.strip() for col in line.strip().split('|')[1:-1]]  # Ignore first & last empty splits
#         if columns:
#             table.append(columns)
#
# # DataFrame
# df = pd.DataFrame(table[1:], columns=table[0])  # First row as headers, rest as data
#
# # Spreadsheet
# df.to_excel("$OUTPUT_XLSX", sheet_name="NFB_UG", index=False)
# table_workbook = os.path.basename("$OUTPUT_XLSX")
# # print("Saving workbook:", table_workbook)
EOF

# echo "✅ Excel file saved as: $OUTPUT_XLSX"
# Cleanup
# rm -f "tables.md" "tables_no_separators.md" "tables_cleaned.md"
echo "${GREEN}✅ Excel file saved as: $OUTPUT_XLSX${NC}"
