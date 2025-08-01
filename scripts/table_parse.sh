#!/bin/bash

# ----------------------------------------------------
# LLAMA-PARSE: Parse PDF and extract tables to Excel #
# ----------------------------------------------------

DIR="$HOME/ownCloud/Documents/netis-fleet/OPEX/Bureau_Mauritius"
PDF_INPUT="Live_Netis_Fuel_UG.pdf"
XLSX_OUPUT="Live_Netis_Fuel_UG.xlsx"

# CLOUD_SERVICE
/usr/bin/python3 - <<EOF
import os
import asyncio
import pandas as pd
from io import StringIO
from typing import List
from pathlib import Path
from dotenv import load_dotenv

from llama_cloud_services import LlamaParse
from halo import Halo

# Load API Key from .env
dotenv_path = Path("$HOME/.env")
load_dotenv(dotenv_path=dotenv_path)

# Cwd
os.chdir("$DIR")

# Initialize parser
parser = LlamaParse(
    num_workers=4,
    verbose=True,
    language="en",
    parse_mode="parse_page_with_llm",
    system_prompt_append="Recognize vehicle IDs. Split date and time into adjacent columns. Remove comma separators from cell values. Convert mileage columns to numeric datatype.",
    user_prompt="You are provided a document with tables that span multiple pages. Combine all rows to form a dataset. Align the columns.",
    show_progress=False,
    result_type="markdown",
)

def extract_tables_to_excel(json_results: List[dict], xlsx_output: str) -> str:
    from io import StringIO

    with pd.ExcelWriter(xlsx_output, engine="openpyxl") as writer:
        sheet_num = 1
        for result in json_results:
            for page in result.get("pages", []):
                for item in page.get("items", []):
                    if item.get("type") == "table" and item.get("csv"):
                        try:
                            df = pd.read_csv(StringIO(item["csv"]))
                            df.to_excel(writer, sheet_name=f"sheet {sheet_num}", index=False)
                            sheet_num += 1
                        except Exception as e:
                            print(f"Error parsing table: {e}")
    return xlsx_output

async def main():
    spinner = Halo(text="Extracting tables...", spinner="dots", color="cyan")
    spinner.start()

    try:
        json_result = parser.get_json_result("$PDF_INPUT")
        output_file = extract_tables_to_excel(json_result, "$XLSX_OUPUT")
        spinner.succeed("Saving... .")
        spinner.succeed(f"{output_file}")
    except Exception as e:
        spinner.fail(f"Failed: {e}")

# Execute async main
asyncio.run(main())
EOF
