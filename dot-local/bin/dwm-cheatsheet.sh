#!/bin/bash

# Adjust accordingly
CONFIG_H_PATH="$HOME/.local/src/wm/config.h"
ST_CONFIG_PATH="$HOME/.local/src/st/config.h"
LF_CONFIG_PATH="$HOME/.config/lf/lfrc"
BM_DIRS_PATH="$HOME/.config/shell/bm-dirs"
BM_FILES_PATH="$HOME/.config/shell/bm-files"

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
    }' "$CONFIG_H_PATH"
}

get_shortcuts () {
    # Print the header
    cowsay -f tux source code at: "$ST_CONFIG_PATH"
    printf "\n%b\n" "${YELLOW}Shortcuts:${NC}"
    printf "${GREEN}%-40s ${BLUE}%-35s ${RED}%-30s ${NC}%-25s ${NC}%s\n" "Modifier" "Key" "Function" "Argument" "Explanation"
    printf '%*s\n' "$(tput cols)" '' | tr ' ' '-'

    # Use awk to extract and print the keybindings
    awk -v red="$RED" -v green="$GREEN" -v blue="$BLUE" -v nc="$NC" '
    /^\s*\{ MODKEY/ || /^\s*\{ ShiftMask/ || /^\s*\{ XK_ANY_MOD/ || /^\s*\{ TERMMOD/ || /^\s*\{ ControlMask/ || /^\s*\{ XK_NO_MOD/ || /^\s*\{ 0,/ {
        # Clean up the line by removing spaces, tabs, and braces
        gsub(/[\{\}]/, "")
        gsub(/[ \t]+/, " ")

        # Split the line into fields based on the comma separator
        n = split($0, fields, ",")


        if (n >= 5) {
            # Replace .v = and .i = with empty strings for clarity
            gsub(/ \/\* /, "", fields[5])
            gsub(/ \*\//, "", fields[5])
        }

        # Fields captured by split:
        # 1 - Mask
        # 2 - Keysym
        # 3 - Function
        # 4 - Argument
        # 5 - Explanation (if it exists, since some lines may not have an explanation)

        # Print the Modifier, Key, and Function
        printf "%s%-40s %s%-35s%s %s%-30s %s%-25s %s \n",
	green, fields[1],
	blue, fields[2],
	red, fields[3],
	nc, (n >=4 ? fields[4] : " "),
	nc, (n >=5 ? fields[5] : " ");

    }' "$ST_CONFIG_PATH"
}

get_lf_bindings () {
    # Print the header
    cowsay -f tux "Source code at: $LF_CONFIG_PATH"
    printf "\n%b\n" "${YELLOW} LF Bindings:${NC}"
    printf "${GREEN}%-40s ${RED}%s\n" "Modifier" "Key"
    printf '%*s\n' "$(tput cols)" '' | tr ' ' '-'

    # Use awk to extract and print the keybindings
    awk -v green="$GREEN" -v red="$RED" -v nc="$NC" '
    /^map/ {
        # Split the line into fields based on whitespace
        printf "%s", green;  # Start with green color for the first part
        printf "%-40s ", $2;  # Print the second field with a fixed width
        printf "%s", red;  # Switch to red color for subsequent fields
        # Print all fields from the third to the last
        for (i = 3; i <= NF; i++) {
            printf "%s ", $i;
        }
        printf "%s\n", nc;  # Reset to no color and print a newline
    }' "$LF_CONFIG_PATH"
}

get_bm_dirs () {
    cowsay -f tux "Source code at: $BM_DIRS_PATH"
    printf "\n%b\n" "${YELLOW} Bookmarked Directories:${NC}"
    printf "${GREEN}%-40s ${RED}%s\n" "Modifier" "Key"
    printf '%*s\n' "$(tput cols)" '' | tr ' ' '-'
    awk -v green="$GREEN" -v red="$RED" -v nc="$NC" '{
     	gsub(/#.*/, "")
	if (NF > 0) {
		printf " %s%-40s %s%-30s \n",
		green, $1,
		red, $2,
		nc;
	}
    }' "$BM_DIRS_PATH"
}

get_bm_files () {
    cowsay -f tux "Source code at: $BM_FILES_PATH"
    printf "\n%b\n" "${YELLOW} Bookmarked Files:${NC}"
    printf "${GREEN}%-40s ${RED}%s\n" "Modifier" "Key"
    printf '%*s\n' "$(tput cols)" '' | tr ' ' '-'
    awk -v green="$GREEN" -v red="$RED" -v nc="$NC" '{
     	gsub(/#.*/, "")
     	gsub(/^\s*$/, "")
	if (NF > 0) {
		printf " %s%-40s %s%-30s \n",
		green, $1,
		red, $2,
		nc;
	}

    }' "$BM_FILES_PATH"
}

print_welcome () {
	figlet -f small -cDtW dwm-cheatsheet
}


case "$1" in
	dwm)
	  (print_welcome && get_constants && get_keybindings) | less ;;
	st)
	  (print_welcome && get_shortcuts) | less ;;
	lf)
	  get_lf_bindings | less ;;
	bm)
	  (print_welcome && get_bm_dirs && get_bm_files) | less ;;
	help)
	  printf "\n%b\n" "${RED}Usage:${NC}"
	  printf "%b\n" "$0"
	  printf "\n%b" "dwm"
	  printf "\n%b" "st"
	  printf "\n%b" "lf"
	  printf "\n%b" "help"
	  printf "\n%b\n" "bm" ;;
	*)
	  (print_welcome && get_constants && get_keybindings && get_shortcuts && get_lf_bindings && get_bm_dirs && get_bm_files) | less ;;
esac
