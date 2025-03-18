#!/bin/sh

# Table extraction
llama-parse parse ~/ownCloud/Documents/netis-fleet/OPEX/Bureau_Mauritius/Live_Netis_Fuel_UG.pdf \
  -o ~/ownCloud/Documents/netis-fleet/OPEX/Bureau_Mauritius/Live_Netis_Fuel_UG.md \
  -f markdown \
  -pi "$(< $GIT_PATH/linux-setup/miscellaneous/llamaParse/prompts.md)"
