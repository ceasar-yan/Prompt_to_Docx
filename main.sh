#!/bin/bash

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color (Reset)

# Start Isolation
tput smcup && clear; 

# echo -e "${BLUE}$(figlet -f slant 'Prompt to Docx')${NC}"; # Slant duh
echo -e "${BLUE}$(figlet 'Prompt to Docx')${NC}"; # Plain but cool

while true; do
  sleep 1;
done

# End Isolation
bash; tput rmcup;
