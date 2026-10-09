#!/usr/bin/env bash
# Installer logo / masthead
# Author: Ali Hassani (@alihassanijr)
# NOTE: this should be sourced from ./dotfiles/, after installer/colors.sh


# Stars and stripes. "ALI'S" (figlet ANSI Regular, 5 rows, solid) over
# "DOTFILES" (figlet ANSI Shadow), solid blocks in OG blue and the box-drawing
# shadow in OG red, on a white panel so the palette reads the same on any
# terminal theme. A canton of star emoji (7 rows alternating 6/5, starting and
# ending with 6, like the flag) sits left of ALI'S, which is centered on it
# with a star-only row above and below; thin blue/white stripes frame the
# panel: upper half blocks on top, lower half blocks at the bottom, so both
# edges end on blue and the stripes mirror each other.
#
# Every row is exactly 61 columns; the panel adds a 3-column margin on each
# side (67 total) and the stripes span all 67. Widths are baked into the
# literals because printf padding counts bytes, not columns. Each star emoji
# is 2 columns wide.
_LOGO_ROWS=(
  " ⭐  ⭐  ⭐  ⭐  ⭐  ⭐                                      "
  "   ⭐  ⭐  ⭐  ⭐  ⭐            █████  ██      ██ ██ ███████"
  " ⭐  ⭐  ⭐  ⭐  ⭐  ⭐         ██   ██ ██      ██    ██     "
  "   ⭐  ⭐  ⭐  ⭐  ⭐           ███████ ██      ██    ███████"
  " ⭐  ⭐  ⭐  ⭐  ⭐  ⭐         ██   ██ ██      ██         ██"
  "   ⭐  ⭐  ⭐  ⭐  ⭐           ██   ██ ███████ ██    ███████"
  " ⭐  ⭐  ⭐  ⭐  ⭐  ⭐                                      "
  "                                                             "
  "██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗"
  "██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝"
  "██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗"
  "██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║"
  "██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║"
  "╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝"
  "                                                             "
  "                                             alihassanijr.com"
)
# 67 half blocks: blue half, white half = two thin stripes per row.
_LOGO_STRIPE_TOP="▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀"
_LOGO_STRIPE_BOTTOM="▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄"
_LOGO_STRIPE_ASCII="==================================================================="

_logo_line() {
  # One panel row: white background, red default foreground, 3-col margins.
  printf '%s%s   %s   %s\n' "$_C_BG_WHITE" "$_C_OG_RED" "$1" "$_C_RESET"
}

_logo_stripe() {
  # Full-width stripe row in blue, no margins.
  printf '%s%s%s%s\n' "$_C_BG_WHITE" "$_C_OG_BLUE" "$1" "$_C_RESET"
}

print_logo() {
  local LC=${LC_ALL:-${LC_CTYPE:-$LANG}}
  case "$LC" in
    *UTF-8*|*utf-8*|*UTF8*|*utf8*) ;;
    *)
      # No UTF-8 locale: block glyphs and emoji would garble. Plain ASCII, same palette.
      _logo_stripe "$_LOGO_STRIPE_ASCII"
      printf '%s%s%-67s%s\n' "$_C_BG_WHITE" "$_C_OG_BLUE" "" "$_C_RESET"
      printf '%s%s%-67s%s\n' "$_C_BG_WHITE" "$_C_OG_BLUE" "   A L I ' S   D O T F I L E S" "$_C_RESET"
      printf '%s%s%-67s%s\n' "$_C_BG_WHITE" "$_C_OG_RED"  "   alihassanijr.com" "$_C_RESET"
      printf '%s%s%-67s%s\n' "$_C_BG_WHITE" "$_C_OG_BLUE" "" "$_C_RESET"
      _logo_stripe "$_LOGO_STRIPE_ASCII"
      return 0
      ;;
  esac

  local ROW
  _logo_stripe "$_LOGO_STRIPE_TOP"
  _logo_stripe "$_LOGO_STRIPE_TOP"
  for ROW in "${_LOGO_ROWS[@]}"; do
    # Blocks in blue, shadow in red (the row's default foreground).
    _logo_line "${ROW//█/${_C_OG_BLUE}█${_C_OG_RED}}"
  done
  _logo_stripe "$_LOGO_STRIPE_BOTTOM"
  _logo_stripe "$_LOGO_STRIPE_BOTTOM"
}

print_done() {
  # "Installation complete." as a thin version of the logo panel: one stripe,
  # one row (bold blue text, a star at each end), one stripe.
  local LC=${LC_ALL:-${LC_CTYPE:-$LANG}}
  case "$LC" in
    *UTF-8*|*utf-8*|*UTF8*|*utf8*)
      _logo_stripe "$_LOGO_STRIPE_TOP"
      # Centered (61 cols is odd vs. a 36-col group, so the right pad is one
      # wider). RESET clears background and foreground, so re-apply both after
      # the bold text; the stars take the foreground color.
      _logo_line "            ⭐ ⭐  ${_C_BOLD}${_C_OG_BLUE}Installation complete.${_C_RESET}${_C_BG_WHITE}${_C_OG_RED}  ⭐ ⭐             "
      _logo_line "                Enjoy LIBERTY & CIVILIZATION!                "
      _logo_stripe "$_LOGO_STRIPE_BOTTOM"
      ;;
    *)
      _logo_stripe "$_LOGO_STRIPE_ASCII"
      printf '%s%s%s%-67s%s\n' "$_C_BG_WHITE" "$_C_BOLD" "$_C_OG_BLUE" "   Installation complete." "$_C_RESET"
      printf '%s%s%-67s%s\n' "$_C_BG_WHITE" "$_C_OG_RED" "   Enjoy LIBERTY & CIVILIZATION!" "$_C_RESET"
      _logo_stripe "$_LOGO_STRIPE_ASCII"
      ;;
  esac
}

_info_row() {
  # Two-column row: bold label, plain value. Labels are ASCII, so printf's
  # byte-counted padding is fine here.
  printf '  %s%-12s%s %s\n' "$_C_BOLD" "$1" "$_C_RESET" "$2"
}

print_info() {
  # Settings and paths detected by installer/prolog.sh, as a two-column table.
  local WORKERS=$NUM_WORKERS
  if [[ -n "$MAX_WORKERS" ]]; then
    WORKERS="$NUM_WORKERS (nproc: $MAX_WORKERS)"
  fi
  local PERSONAL="no"
  if [[ $IS_PERSONAL -eq 1 ]]; then
    PERSONAL="yes (pdf viewer, latex, longer ssh-agent TTL, tmux status bar on top, C-x prefix)"
  fi
  local BUILD="no"
  if [[ "$BUILD_ONLY" -eq 1 ]]; then
    BUILD="yes (build and install only; no config linking)"
  fi

  _info_row "OS"          "$_OS_NAME"
  _info_row "Arch"        "$_ARCH"
  _info_row "Distro"      "$DISTRO_NAME"
  _info_row "Workers"     "$WORKERS"
  _info_row "Personal"    "$PERSONAL"
  _info_row "Build only"  "$BUILD"
  echo ""
  _info_row "Dotfiles"    "$THISDIR"
  _info_row "Home"        "$HOMEDIR"
  _info_row "Programs"    "$PROGRAMS_PATH"
  _info_row ".local"      "$LOCALDIR"
  _info_row "ncurses"     "$NCDIR"
  _info_row "brew"        "$BREWDIR"
  _info_row "fzf"         "$FZF_DIR/.fzf"
  _info_row "python venv" "$PYTHON_BASE_VENV_DIR"
  _info_row "uv pythons"  "$UV_PYTHON_INSTALL_DIR"
}
