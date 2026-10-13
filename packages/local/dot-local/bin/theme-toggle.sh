#!/usr/bin/env bash
set -euo pipefail

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

GTK_LIGHT_THEME="Adwaita"
GTK_DARK_THEME="Adwaita-dark"

# Set these to "" if you do not want qt5ct / qt6ct touched.
QT5_LIGHT_THEME="default"
QT5_DARK_THEME="darker"
QT6_LIGHT_THEME="default"
QT6_DARK_THEME="darker"

ENV_FILE="$CONFIG_HOME/theme-mode.env"
MODE_FILE="$CONFIG_HOME/theme-mode"
GTK3_SETTINGS="$CONFIG_HOME/gtk-3.0/settings.ini"
GTK4_SETTINGS="$CONFIG_HOME/gtk-4.0/settings.ini"
QT5CT_CONF="$CONFIG_HOME/qt5ct/qt5ct.conf"
QT6CT_CONF="$CONFIG_HOME/qt6ct/qt6ct.conf"

have() {
  command -v "$1" >/dev/null 2>&1
}

write_gtk_settings() {
  local mode="$1"
  local theme dark_flag

  if [[ "$mode" == "dark" ]]; then
    theme="$GTK_DARK_THEME"
    dark_flag=1
  else
    theme="$GTK_LIGHT_THEME"
    dark_flag=0
  fi

  mkdir -p "$(dirname "$GTK3_SETTINGS")" "$(dirname "$GTK4_SETTINGS")"

  cat >"$GTK3_SETTINGS" <<EOF
[Settings]
gtk-theme-name=$theme
gtk-application-prefer-dark-theme=$dark_flag
EOF

  cat >"$GTK4_SETTINGS" <<EOF
[Settings]
gtk-theme-name=$theme
gtk-application-prefer-dark-theme=$dark_flag
EOF
}

set_gsettings_mode() {
  local mode="$1"

  if ! have gsettings; then
    return 0
  fi

  if [[ "$mode" == "dark" ]]; then
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark || true
    gsettings set org.gnome.desktop.interface gtk-theme "$GTK_DARK_THEME" || true
  else
    gsettings set org.gnome.desktop.interface color-scheme default || true
    gsettings set org.gnome.desktop.interface gtk-theme "$GTK_LIGHT_THEME" || true
  fi
}

set_qtct_theme() {
  local file="$1"
  local theme="$2"

  [[ -z "$theme" ]] && return 0

  mkdir -p "$(dirname "$file")"

  if [[ ! -f "$file" ]]; then
    cat >"$file" <<EOF
[Appearance]
style=$theme
EOF
    return 0
  fi

  if grep -q '^\[Appearance\]' "$file"; then
    if awk '
      BEGIN { in_section=0; found=0 }
      /^\[Appearance\]$/ { in_section=1; print; next }
      /^\[/ {
        if (in_section && !found) {
          print "style='"$theme"'"
          found=1
        }
        in_section=0
        print
        next
      }
      {
        if (in_section && $0 ~ /^style=/) {
          print "style='"$theme"'"
          found=1
        } else {
          print
        }
      }
      END {
        if (in_section && !found) print "style='"$theme"'"
      }
    ' "$file" >"$file.tmp"; then
      mv "$file.tmp" "$file"
    else
      rm -f "$file.tmp"
      return 1
    fi
  else
    {
      cat "$file"
      printf '\n[Appearance]\nstyle=%s\n' "$theme"
    } >"$file.tmp"
    mv "$file.tmp" "$file"
  fi
}

apply_qt_themes() {
  local mode="$1"

  if [[ "$mode" == "dark" ]]; then
    set_qtct_theme "$QT5CT_CONF" "$QT5_DARK_THEME"
    set_qtct_theme "$QT6CT_CONF" "$QT6_DARK_THEME"
  else
    set_qtct_theme "$QT5CT_CONF" "$QT5_LIGHT_THEME"
    set_qtct_theme "$QT6CT_CONF" "$QT6_LIGHT_THEME"
  fi
}

write_env_file() {
  local mode="$1"
  local gtk_theme

  if [[ "$mode" == "dark" ]]; then
    gtk_theme="$GTK_DARK_THEME"
  else
    gtk_theme="$GTK_LIGHT_THEME"
  fi

  mkdir -p "$(dirname "$ENV_FILE")"

  cat >"$ENV_FILE" <<EOF
export THEME_MODE=$mode
export GTK_THEME=$gtk_theme
EOF
}

write_mode_file() {
  local mode="$1"
  mkdir -p "$(dirname "$MODE_FILE")"
  printf '%s\n' "$mode" >"$MODE_FILE"
}

current_mode() {
  if [[ -f "$MODE_FILE" ]]; then
    cat "$MODE_FILE"
    return 0
  fi

  if have gsettings; then
    local val
    val="$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null || true)"
    case "$val" in
    *prefer-dark*)
      echo dark
      return 0
      ;;
    esac
  fi

  echo light
}

reload_optional() {
  if have pkill; then
    pkill -USR2 waybar 2>/dev/null || true
  fi
}

main() {
  local target="${1:-toggle}"
  local mode

  case "$target" in
  dark | light)
    mode="$target"
    ;;
  toggle)
    if [[ "$(current_mode)" == "dark" ]]; then
      mode="light"
    else
      mode="dark"
    fi
    ;;
  *)
    echo "Usage: $0 [toggle|dark|light]" >&2
    exit 1
    ;;
  esac

  set_gsettings_mode "$mode"
  write_gtk_settings "$mode"
  apply_qt_themes "$mode"
  write_env_file "$mode"
  write_mode_file "$mode"
  reload_optional

  printf 'Switched to %s mode\n' "$mode"
}

main "$@"
