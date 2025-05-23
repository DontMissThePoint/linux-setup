#!/bin/sh

set -e

GREEN='\033[0;32m'
NC='\033[0m' # No Color

# JSON
# csvjson "$DIR/../../fleet_consumption.tsv" | jq 'unique_by(.Mileage)'
# jq '.pages[].items[] | select(.type=="table").rows | unique' | jsonrepair --overwrite

# XLSX
/usr/bin/python3 - <<EOF
import os
import json
import markdown
import asyncio

from dotenv import load_dotenv
from pathlib import Path

dotenv_path = Path("$HOME/.env")
load_dotenv(dotenv_path=dotenv_path)

DATA_DIR = "$HOME/ownCloud/Documents/netis-fleet/OPEX/Bureau_Mauritius"
output_xlsx = DATA_DIR / "Live_Netis_Fuel_UG.xlsx"

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
    preserve_layout_alignment_across_pages=True,
    system_prompt_append="Recognize vehicle IDs. Split date and time into two different columns. Remove comma separators from cell values. Convert mileage columns to numeric datatype.",
    user_prompt="You are provided with a long table that spans multiple pages. Combine all rows to form a dataset. Also align all columns in the table.",
    show_progress=False,
    # invalidate_cache=False,
    result_type="markdown",
)

print(f"Parsing text...")

async def main():

  import pandas as pd
  from bs4 import BeautifulSoup

  md_json_objs = parser.get_json_result(files)
  md_json_list = md_json_objs[0]["pages"]
  # for i, page in enumerate(md_json_list):
  #     print(f"Page {i}:", page.get("md", "No 'md' key"))

  # save all tables
  all_rows = []
  header = None

  print("🔍 Extracting tables...")

  for i, page in enumerate(md_json_list):
    md_content = page.get("md", "")
    if not md_content.strip() or md_content.strip() == "---":
      continue  # Skip empty or separator-only pages

    # Convert markdown to HTML
    html = markdown.markdown(md_content)
    soup = BeautifulSoup(html, "html.parser")
    table = soup.find("table")

    if not table:
      continue  # No table in this markdown content

    # Extract headers
    if header is None:
      header = [th.get_text(strip=True) for th in table.find_all("th")]

    # Extract rows
    for tr in table.find_all("tr")[1:]:  # skip header row
      row = [td.get_text(strip=True) for td in tr.find_all(["td", "th"])]
      if row:
        all_rows.append(row)

  # Create DataFrame and write to Excel
  df = pd.DataFrame(all_rows, columns=header)
  df.to_excel(output_xlsx, index=False)

# Run the async function
asyncio.run(main())

EOF

echo "${GREEN} ✔ ${NC}Saved workbook"
