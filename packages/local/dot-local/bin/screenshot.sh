#!/bin/sh
# Simple Wayland screenshot helper used by dwl key bindings.
# Supports full screenshots and region selection via a mode picker menu.
set -eu
exec </dev/null

usage() {
  cat <<-EOF
	Usage: ${0##*/} [-s]
	Take a screenshot using grim.
	  -s, --select   select a region via slurp instead of grabbing the full output
	  -h, --help     show this help and exit
	The screenshot directory defaults to \$HOME/Pictures/Screenshots and can be
	overridden with SCREENSHOT_DIR. The selection delay can be configured with
	SCREENSHOT_SELECT_DELAY (default: 0.25s).
	The menu tool can be set with SCREENSHOT_MENU (default: walker, fallback wmenu).
	EOF
}

select_area=0

while [ $# -gt 0 ]; do
  case "$1" in
  -s | --select) select_area=1 ;;
  -h | --help)
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

# --- menu helper -----------------------------------------------------------
run_menu() {
  prompt="$1"
  if [ -n "${SCREENSHOT_MENU:-}" ]; then
    launcher="$SCREENSHOT_MENU"
  elif command -v walker >/dev/null 2>&1; then
    launcher="walker"
  elif command -v wmenu >/dev/null 2>&1; then
    launcher="wmenu"
  else
    printf 'No menu tool found (walker/wmenu). Set SCREENSHOT_MENU.\n' >&2
    exit 1
  fi

  case "$launcher" in
  walker) walker --dmenu -p "$prompt" ;;
  wmenu) wmenu -p "$prompt" ;;
  *) "$launcher" ;;
  esac
}

# --- mode picker -----------------------------------------------------------
choice="$(printf 'Fullscreen\nRegion' | run_menu 'Screenshot')" || exit 1
case "$choice" in
Fullscreen) select_area=0 ;;
Region) select_area=1 ;;
*) exit 1 ;;
esac

# --- setup -----------------------------------------------------------------
shot_dir="${SCREENSHOT_DIR:-"$HOME/Pictures/Screenshots"}"
mkdir -p "$shot_dir"
timestamp="$(date '+%Y%m%d-%H%M%S')"
outfile="$shot_dir/screenshot-$timestamp.png"

maybe_notify() {
  if command -v notify-send >/dev/null 2>&1; then
    notify-send -a screenshot "$1" "$2" >/dev/null 2>&1 || true
  fi
}

# --- clipboard check -------------------------------------------------------
command -v wl-copy >/dev/null 2>&1 || {
  printf 'wl-copy is required (install wl-clipboard)\n' >&2
  exit 1
}

# --- region selection ------------------------------------------------------
geometry=""
if [ "$select_area" -eq 1 ]; then
  sleep "${SCREENSHOT_SELECT_DELAY:-0.25}"
  geometry="$(slurp </dev/null)" || exit 1
  [ -n "$geometry" ] || exit 1
fi

# --- capture ---------------------------------------------------------------
if [ -n "$geometry" ]; then
  grim -g "$geometry" - | tee "$outfile" | wl-copy --type image/png
else
  grim - | tee "$outfile" | wl-copy --type image/png
fi

# --- symlink & notify ------------------------------------------------------
[ -f "$outfile" ] && ln -sf "$outfile" "$shot_dir/last.png"
maybe_notify "Screenshot saved & copied" "$outfile"
