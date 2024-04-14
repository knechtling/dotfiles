#!/bin/bash

# Adjust accordingly
CONFIG_H_PATH="$HOME/.local/src/dwm/config.h"
ST_CONFIG_PATH="$HOME/.local/src/st/config.h"

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
	cowsay -f tux source code at: "$CONFIG_H_PATH"
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
    # Print the header
    printf "\n%b\n" "${YELLOW}Keybindings:${NC}"
    printf "${GREEN}%-30s ${BLUE}%-25s ${RED}%-20s ${NC}%s \n" "Modifier" "Key" "Function" "Argument"
    printf '%*s\n' "$(tput cols)" '' | tr ' ' '-'

    # Use awk to extract and print the keybindings
    awk -v red="$RED" -v green="$GREEN" -v blue="$BLUE" -v nc="$NC" '
    /^\{ MODKEY/ || /^\{ ShiftMask/ || /^\{ MODKEY|ShiftMask/ || /^\{ 0,/ {
        # Clean up the line by removing spaces, tabs, and braces
        gsub(/[\{\}]/, "")
        gsub(/[ \t]+/, " ")

        # Split the line into fields based on the comma separator
        n = split($0, fields, ",")

        # Fields captured by split:
        # 1 - Modifier
        # 2 - Key
        # 3 - Function
        # 4 - Argument (if it exists, since some lines may not have an argument)

        # Print the Modifier, Key, and Function
        printf "%s%-30s%s %-25s%s %-20s%s ", green , fields[1], blue, fields[2], red, fields[3], nc

        # Print the Argument if it exists
        if (n >= 4) {
            # Replace .v = and .i = with empty strings for clarity
            gsub(/\.v = /, "", fields[4])
            gsub(/\.i = /, "", fields[4])
            print fields[4]
        } else {
            print " "
        }
    }' "$CONFIG_H_PATH" | less -R
}

get_shortcuts () {
    # Print the header
    cowsay -f tux source code at: "$ST_CONFIG_PATH"
    printf "\n%b\n" "${YELLOW}Shortcuts:${NC}"
    printf "${GREEN}%-30s ${BLUE}%-25s ${RED}%-20s ${NC}%s \n" "Modifier" "Key" "Function" "Argument"
    printf '%*s\n' "$(tput cols)" '' | tr ' ' '-'

    # Use awk to extract and print the keybindings
    awk -v red="$RED" -v green="$GREEN" -v blue="$BLUE" -v nc="$NC" '
    /^\s*\{ MODKEY/ || /^\s*\{ ShiftMask/ || /^\s*\{ XK_ANY_MOD/ || /^\s*\{ TERMMOD/ || /^\s*\{ ControlMask/ || /^\s*\{ 0,/ {
        # Clean up the line by removing spaces, tabs, and braces
        gsub(/[\{\}]/, "")
        gsub(/[ \t]+/, " ")

        # Split the line into fields based on the comma separator
        n = split($0, fields, ",")

        # Fields captured by split:
        # 1 - Mask
        # 2 - Keysym
        # 3 - Function
        # 4 - Argument (if it exists, since some lines may not have an argument)

        # Print the Modifier, Key, and Function
        printf "%s%-30s%s %-25s%s %-20s%s ", green , fields[1], blue, fields[2], red, fields[3], nc

        # Print the Argument if it exists
        if (n >= 4) {
            # Replace .v = and .i = with empty strings for clarity
            gsub(/\.v = /, "", fields[4])
            gsub(/\.i = /, "", fields[4])
            print fields[4]
        } else {
            print " "
        }
    }' "$ST_CONFIG_PATH" | less -R
}

print_welcome () {
	figlet -f small -cDtW dwm-cheatsheet
}

( print_welcome && get_constants && get_keybindings && get_shortcuts ) | less
