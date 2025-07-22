#!/bin/bash

# -----------------------------
# LLAMA-PARSE
# Parse pdfs and extract tables
# -----------------------------

DIR="$HOME/ownCloud/Documents/netis-fleet/OPEX/Bureau_Mauritius"
MD_FILE="$DIR/Live_Netis_Fuel_UG.md"
OUTPUT_XLSX="$DIR/Live_Netis_Fuel_UG.xlsx"

# LLAMA_CLOUD
/usr/bin/python3 - <<EOF
import asyncio
import json
import os
import time
from pathlib import Path

from dotenv import load_dotenv

dotenv_path = Path("$HOME/.env")
load_dotenv(dotenv_path=dotenv_path)

DATA_DIR = Path("$DIR")


def get_pdfs(data_dir=DATA_DIR) -> list[str]:
    files = []
    for f in os.listdir(data_dir):
        fname = os.path.join(data_dir, f)
        if os.path.isfile(fname) and f.lower().endswith(".pdf"):
            files.append(fname)
    return files


files = get_pdfs()

from llama_cloud_services import LlamaParse

parser = LlamaParse(
    # api_key="llx-...",  # can also be set in your env as LLAMA_CLOUD_API_KEY
    num_workers=4,  # if multiple files passed, split API calls
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

    from halo import Halo

    spinner = Halo(text=" ", spinner="dots", color="magenta")
    spinner.start()

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

    time.sleep(1)
    spinner.stop()


# Run the async function
asyncio.run(main())

EOF

# JSON
# csvjson "$DIR/../../fleet_consumption.tsv" | jq 'unique_by(.Mileage)'
# jq '.pages[].items[] | select(.type=="table").rows | unique' | jsonrepair --overwrite

# MD_OBJS async
# md_json_objs = await parser.get_json_result(files)
# print(md_json_objs)
# md_json_list = md_json_objs[0]["pages"]
# for i, page in enumerate(md_json_list):
#     print(f"Page {i}:", page.get("md", "No 'md' key"))

# MD
sed -n '/^|/p' "$MD_FILE" >tables.md
# Remove separator rows (---...)
sed -i '/^|[-| ]*|$/d; /^| *\(Date\|Time\) *|/d' tables.md

# XLSX
/usr/bin/python3 - <<EOF
import os
import re

import pandas as pd

# Read cleaned table data
with open("tables.md", "r") as file:
    lines = file.readlines()

table = []

from halo import Halo

with Halo(text="Extracting tables", spinner="dots") as spinner:
    for line in lines:
        if re.match(r"^\|.*\|$", line):  # Identify table rows
            columns = [
                col.strip() for col in line.strip().split("|")[1:-1]
            ]  # Ignore first & last empty splits
            if columns:
                table.append(columns)

    # Check if the  first row is as long as the table rows,
    # if not likely not a table
    if len(table) > 0 and len(table[0]) != len(table[1]):

        # Check if the table is empty
        if len(table) == 0:
            print("Empty table. Exiting...\n")
        exit()

    # Check if the all rows have the same number of columns
    if not all(len(row) == len(table[0]) for row in table):
        print("Invalid row in table. Exiting...\n")
        exit()

    # DataFrame
    df = pd.DataFrame(table[1:], columns=table[0])  # First row as headers, rest as data

    # Spreadsheet
    df.to_excel("$OUTPUT_XLSX", sheet_name="ORDERS", index=False)
    table_workbook = os.path.basename("$OUTPUT_XLSX")
    spinner.succeed("Saved workbook")
EOF

# Archive
cleanup() {
    # echo "Cleaning up..."
    mv tables.md "$DIR"/../../WinAutomation/
}
trap cleanup EXIT
