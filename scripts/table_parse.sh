#!/bin/sh

set -e

# -----------------------------
# LLAMA-PARSE
# Parse pdfs and extract tables
# -----------------------------

DIR="$HOME/ownCloud/Documents/netis-fleet/OPEX/Bureau_Mauritius"
MD_FILE="$DIR/Live_Netis_Fuel_UG.md"
OUTPUT_XLSX="$DIR/Live_Netis_Fuel_UG.xlsx"

# LLAMA_CLOUD
/usr/bin/python3 - <<EOF
import os
import json
import asyncio

from dotenv import load_dotenv
from pathlib import Path

dotenv_path = Path("$HOME/.env")
load_dotenv(dotenv_path=dotenv_path)

DATA_DIR = Path("$DIR")

def get_pdfs(data_dir=DATA_DIR) -> list[str]:
    files = []
    for f in os.listdir(data_dir):
        fname = os.path.join(data_dir, f)
        if os.path.isfile(fname) and f.lower().endswith('.pdf'):
            files.append(fname)
    return files

files = get_pdfs()

from llama_cloud_services import LlamaParse

parser = LlamaParse(
    # api_key="llx-...",  # can also be set in your env as LLAMA_CLOUD_API_KEY
    num_workers=4,        # if multiple files passed, split API calls
    verbose=True,
    language="en",
    parse_mode="parse_page_with_llm",
    system_prompt_append="Recognize vehicle IDs. Split date and time into two different columns. Remove comma separators from cell values. Convert mileage columns to numeric datatype.",
    user_prompt="You are provided a document with tables that span multiple pages. Combine all rows to form a dataset. Align the columns.",
    # invalidate_cache=False,
    show_progress=False,
    result_type="markdown",
)

async def main():

  print("Parsing text...")

  documents = []

  for file_path in files:
    extra_info = {"file_name": file_path}
    with open(file_path, "rb") as f:
      # must provide extra_info with file_name key when passing file object
      docs = parser.load_data(f, extra_info=extra_info)
      documents.extend(docs)

  # Write the output to a file
  with open("$MD_FILE", "w", encoding="utf-8") as f:
    for doc in documents:
      f.write(doc.text)

  # result = await parser.aparse(files)
  # documents = result.get_text_documents(split_by_page=True)
  # print(documents[0].get_content()[10:1000])

  # agentic_json_output = await parser.get_json_result(files)[0]
  # for page in agentic_json_output["pages"]:
  #       print(f"Page {page['page']}: {page['items']}")

  # md_json_objs = await parser.get_json_result(files)
  # print(md_json_objs)
  # md_json_list = md_json_objs[0]["pages"]
  # for i, page in enumerate(md_json_list):
  #     print(f"Page {i}:", page.get("md", "No 'md' key"))

# Run the async function
asyncio.run(main())

EOF

# JSON
# csvjson "$DIR/../../fleet_consumption.tsv" | jq 'unique_by(.Mileage)'
# jq '.pages[].items[] | select(.type=="table").rows | unique' | jsonrepair --overwrite

# save all tables
GREEN='\033[0;32m'
NC='\033[0m' # No Color
echo "${GREEN} ░ Extracting..${NC}"
sed -n '/^|/p' "$MD_FILE" >tables.md

# Remove separator rows (---...)
sed -i '/^|[-| ]*|$/d; /^| *\(Date\|Time\) *|/d' tables.md

# XLSX
/usr/bin/python3 - <<EOF
import pandas as pd
import re
import os

# Read cleaned table data
with open("tables.md", "r") as file:
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
df.to_excel("$OUTPUT_XLSX", sheet_name="FUELINGS", index=False)
table_workbook = os.path.basename("$OUTPUT_XLSX")
EOF

# Archive
mv tables.md "$DIR"/../../WinAutomation/
echo "${GREEN} ✔ ${NC}Saved workbook"
