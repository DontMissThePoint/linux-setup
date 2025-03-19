#!/bin/sh

# Table extraction
llama-parse parse ~/ownCloud/Documents/netis-fleet/OPEX/Bureau_Mauritius/Live_Netis_Fuel_UG.pdf \
  -o ~/ownCloud/Documents/netis-fleet/OPEX/Bureau_Mauritius/Live_Netis_Fuel_UG.json \
  -f json
  -pi "Split date and time into two different columns. Remove comma separators from cell values. Convert mileage columns to numeric datatype. Also align all columns in the sheets."
