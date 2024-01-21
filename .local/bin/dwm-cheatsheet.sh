#!/bin/bash

# Adjust accordingly
CONFIG_H_PATH="$HOME/.local/src/dwm/config.h"

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Regular expression for extracting constants
constants_regex="#define\s+(\w+)\s+(.*)"

# Regular expression for extracting keybindings
keys_regex="\{\s*([^,]+),\s*([^,]+),\s*([^,]+),\s*(\{.*\})\s*\}"

# Constants Overview
get_constants () {
printf "%b" "${YELLOW}Constants:${NC}\n"
printf "${GREEN}%-20s ${BLUE}%s${NC}\n" "Name" "Value"
printf '%*s\n' "$(tput cols)" '' | tr ' ' '-'

while read -r line; do
    if [[ $line =~ $constants_regex ]]; then
        constant_name="${BASH_REMATCH[1]}"
        constant_value="${BASH_REMATCH[2]}"
        printf "${GREEN}%-20s ${BLUE}%s${NC}\n" "$constant_name" "$constant_value"
    fi
done < "$CONFIG_H_PATH"
}

# Keybindings Overview
get_keybindings () {
printf "%b\n" "${YELLOW}Keybindings:${NC}"
printf "${RED}%-30s %-25s ${GREEN}%-20s ${BLUE}%s${NC}\n" "Modifier" "Key" "Function" "Argument"
printf '%*s\n' "$(tput cols)" '' | tr ' ' '-'
while read -r line; do
    if [[ $line =~ $keys_regex ]]; then
        modifier="${BASH_REMATCH[1]}"
        key="${BASH_REMATCH[2]}"
        function="${BASH_REMATCH[3]}"
        argument="${BASH_REMATCH[4]}"

        printf "${RED}%-30s %-25s ${GREEN}%-20s ${BLUE}%s${NC}\n" "$modifier" "$key" "$function" "$argument"
    fi
done < "$CONFIG_H_PATH"
}

get_constants "$" && get_keybindings "$" | less
