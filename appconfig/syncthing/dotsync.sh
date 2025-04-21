#!/bin/sh

RED='\033[0;31m'
NC='\033[0m' # No Color

# login
echo "${RED}Sync to megacloud...${NC}"
echo -n "Email: "; read account
stty -echo
read -p "Password: " password; echo
stty echo

# Sync
mega-login "${account}" "${password}"

# folders
mega-sync ~/Documents/Scorecard 05.Scorecard
mega-sync ~/Pictures/Android\ Camera 04.Photos+Video/Android\ Camera
mega-sync ~/Journal 02.Journal

# done
mega-sync-issues
mega-logout --keep-session
