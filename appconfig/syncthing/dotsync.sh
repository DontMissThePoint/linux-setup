#!/bin/sh

RED='\033[0;32m'
NC='\033[0m' # No Color

# login
echo -e "${RED}Sync to megacloud..${NC}"
echo -n "Email: "
read account
stty -echo
read -p "Password: " password
echo
stty echo

# Sync
mega-login "${account}" "${password}" || echo "Logged in"

# folders
mega-sync ~/Documents/Scorecard 05.Scorecard || echo "scorecard sync. OK"
mega-sync ~/Pictures/Android\ Camera 04.Photos+Video/Android\ Camera || echo "camera sync. OK"
mega-sync ~/Journal 02.Journal || echo "journal sync. OK"

# done
mega-sync-issues
mega-logout --keep-session
