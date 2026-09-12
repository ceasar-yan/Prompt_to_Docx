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
  local content="$1"
  local fileName="$2"

  mkdir -p docxFiles/
  
  echo -e "\n${BLUE}'${fileName}.docx' ${GREEN}was created successfully${NC}"
}

sendPrompt() {
  local getPrompt="$1"
  local fileName="$2"
  local response
  local reply
  local payload

  if [[ -z "$GEMINI_API_KEY" ]]; then
    echo "Error: GEMINI_API_KEY environment variable is not set." >&2
    return 1
  fi

  # Safely format getPrompt into valid JSON (handles quotes, newlines, and special characters)
  payload=$(jq -n --arg prompt "$getPrompt" '{
    contents: [{
      parts: [{text: $prompt}]
    }]
  }')

  response=$(curl -s \
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent" \
    -H "Content-Type: application/json" \
    -H "x-goog-api-key: $GEMINI_API_KEY" \
    -d "$payload")

  reply=$(echo "$response" | jq -r '.candidates[0].content.parts[0].text // empty')

  if [[ -z "$reply" ]]; then
    echo "Error: Failed to retrieve a valid response. API response was:" >&2
    echo "$response" >&2
    return 1
  fi

  echo "$reply"
}

# Start Isolation
tput smcup
clear

while true; do
  # echo -e "${BLUE}$(figlet -f slant 'Prompt to Docx')${NC}"; # Slant duh
  echo -e "${BLUE}$(figlet 'Prompt to Docx')${NC}" # Plain but cool
  echo -e "${RED}enter 'exit' to quit the script${NC}"

  while true; do
    # Redeclaring Colors for read command
    GREEN=$'\e[0;32m'
    BLUE=$'\e[0;34m'
    NC=$'\e[0m'

    read -rep "${BLUE}Enter Prompt: ${NC}" prompt;
    if [[ "${prompt}" == "exit" ]]; then break; fi

    sendPrompt "${prompt}"

    # read -e -p "${GREEN}Enter File Name: ${NC}" fileName;
    # if [[ "${fileName}" == "exit" ]]; then break; fi
  done
  if [[ "${prompt}" == "exit" ]]; then break; fi

  toDoc "$prompt" "$fileName"

  echo -e "Press ENTER to reload..."
  cursorH; read -s; cursorR

  clear

done

# End Isolation
tput rmcup
