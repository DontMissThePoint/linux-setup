#!/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# login
echo -e "${GREEN}Sync to megacloud..${NC}"
echo -n "Email: "
read account
stty -echo
read -p "Password: " password
echo
stty echo

# Sync
mega-login "${account}" "${password}" || echo -e "${RED}Logged in${NC}"

# folders
mega-sync ~/Documents/Scorecard 05.Scorecard || echo -e "[ ${GREEN}OK${NC} ] sync scorecard"
mega-sync ~/Pictures/Android\ Camera 04.Photos+Video/Android\ Camera || echo -e "[ ${GREEN}OK${NC} ] sync camera"
mega-sync ~/Journal 02.Journal || echo -e "[ ${GREEN}OK${NC} ] sync journal"

# done
mega-sync-issues
mega-logout --keep-session
echo "Done."
