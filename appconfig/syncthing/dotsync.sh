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
mega-login "$account" "$password" || echo -e "${RED}Logged in${NC}"

# folders
echo "Syncing..."
mega-sync ~/Documents/Dashboard 06.Dashboard || echo "[ ${GREEN}✔${NC} ] Dashboard"
mega-sync ~/Documents/Scorecard 05.Scorecard || echo "[ ${GREEN}✔${NC} ] Scorecard"
mega-sync ~/Pictures/Android\ Camera 04.Photos+Video/Android\ Camera || echo -e "[ ${GREEN}✔${NC} ] Camera"
mega-sync ~/Journal 02.Journal || echo "[ ${GREEN}✔${NC} ] Journal"

# done
mega-sync-issues
mega-logout --keep-session
