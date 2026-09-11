#!/bin/bash

# Colors
GREEN=$'\e[0;32m'
BLUE='\e[34m'
RED='\e[31m'
NC='\033[0m' # No Color (Reset)

cursorH() { # H = Hide
  tput civis
}
cursorR() { # R = Reveal
  tput cnorm
}

toDoc() { # convert gemini's respond to docx  file
  local content=$1
  local fileName=$2

  echo -e "\n${BLUE}'${fileName}.docx' ${GREEN}was created successfully${NC}"
}


# Start Isolation
tput smcup
clear

while true; do
  # echo -e "${BLUE}$(figlet -f slant 'Prompt to Docx')${NC}"; # Slant duh
  echo -e "${BLUE}$(figlet 'Prompt to Docx')${NC}" # Plain but cool
  echo -e "${RED}enter 'exit' to quit the script${NC}\n"

  # Redeclaring Colors for read command
  GREEN=$'\e[0;32m'
  # BLUE=$'\e[0;34m'
  NC=$'\e[0m'

  read -e -p "${GREEN}Enter Prompt: ${NC}" prompt;
  if [[ "${prompt}" == "exit" ]]; then
    break
  fi
  read -e -p "${GREEN}Enter File Name: ${NC}" fileName;
  if [[ "${fileName}" == "exit" ]]; then
    break
  fi

  toDoc "$prompt" "$fileName"

  echo -e "Press ENTER to reload..."
  cursorH; read -s; cursorR

  clear

done

# End Isolation
tput rmcup
