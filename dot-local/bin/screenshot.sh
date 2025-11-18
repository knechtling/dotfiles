#!/bin/sh

# Simple Wayland screenshot helper used by dwl key bindings.
# Supports full screenshots, region selection (-s) and clipboard copies (-c).

set -eu
exec </dev/null # dwl closes stdin for spawned commands; keep it valid for slurp

usage() {
	cat <<-EOF
	Usage: ${0##*/} [-s] [-c]

	Take a screenshot using grim.

	  -s, --select   select a region via slurp instead of grabbing the full output
	  -c, --copy     copy the resulting image to the clipboard in addition to saving
	  -h, --help     show this help and exit

	The screenshot directory defaults to \$HOME/Pictures/Screenshots and can be
	overridden with SCREENSHOT_DIR. The selection delay can be configured with
	SCREENSHOT_SELECT_DELAY (default: 0.25s).
	EOF
}

select_area=0
copy_clipboard=0

while [ $# -gt 0 ]; do
	case "$1" in
		-s|--select) select_area=1 ;;
		-c|--copy) copy_clipboard=1 ;;
		-h|--help)
			usage
			exit 0
			;;
		*)
			printf 'Unknown option: %s\n\n' "$1" >&2
			usage >&2
			exit 1
			;;
	esac
	shift
done

shot_dir="${SCREENSHOT_DIR:-"$HOME/Pictures/Screenshots"}"
mkdir -p "$shot_dir"
timestamp="$(date '+%Y%m%d-%H%M%S')"
outfile="$shot_dir/screenshot-$timestamp.png"

maybe_notify() {
	if command -v notify-send >/dev/null 2>&1; then
		notify-send -a screenshot "$1" "$2" >/dev/null 2>&1 || true
	fi
}

geometry=""
if [ "$select_area" -eq 1 ]; then
	sleep "${SCREENSHOT_SELECT_DELAY:-0.25}"
	geometry="$(slurp </dev/null)" || exit 1
	[ -n "$geometry" ] || exit 1
fi

take_full() {
	if [ "$copy_clipboard" -eq 1 ]; then
		command -v wl-copy >/dev/null 2>&1 || {
			printf 'wl-copy is required for clipboard support\n' >&2
			exit 1
		}
	fi

	if [ "$copy_clipboard" -eq 1 ]; then
		if [ -n "$geometry" ]; then
			grim -g "$geometry" - | tee "$outfile" | wl-copy --type image/png >/dev/null 2>&1
		else
			grim - | tee "$outfile" | wl-copy --type image/png >/dev/null 2>&1
		fi
	else
		if [ -n "$geometry" ]; then
			grim -g "$geometry" "$outfile"
		else
			grim "$outfile"
		fi
	fi
}

take_full
[ -f "$outfile" ] && ln -sf "$outfile" "$shot_dir/last.png"

if [ "$copy_clipboard" -eq 1 ]; then
	maybe_notify "Screenshot saved & copied" "$outfile"
else
	maybe_notify "Screenshot saved" "$outfile"
fi
