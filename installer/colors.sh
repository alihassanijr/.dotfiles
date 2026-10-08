#!/usr/bin/env bash
# Installer script colors
# Author: Ali Hassani (@alihassanijr)
# NOTE: this should be sourced from ./dotfiles/


# Colors are enabled only when stdout is a tty, TERM is sane, and NO_COLOR is
# unset; otherwise every variable below is empty and the helpers print plain
# text. Raw ANSI escapes via printf: no tput/terminfo dependency, no `echo -e`.
# Works on bash 3.2 (macOS).
_C_RESET="" _C_BOLD="" _C_DIM="" _C_RED="" _C_GREEN="" _C_ORANGE="" _C_CYAN=""
_C_BG_WHITE="" _C_OG_BLUE="" _C_OG_RED=""
if [[ -t 1 && -n "$TERM" && "$TERM" != "dumb" && -z "$NO_COLOR" ]]; then
  # Color depth: 24-bit when the terminal advertises it, else 256, else 8.
  _C_DEPTH=8
  case "$TERM" in *256color*) _C_DEPTH=256 ;; esac
  case "$TERM$COLORTERM" in *truecolor*|*24bit*|*direct*) _C_DEPTH=24 ;; esac

  _C_RESET=$(printf '\033[0m')
  _C_BOLD=$(printf '\033[1m')
  _C_DIM=$(printf '\033[2m')       # grey-ish on any theme; skipped / no-op messages
  _C_RED=$(printf '\033[31m')
  _C_GREEN=$(printf '\033[32m')
  _C_CYAN=$(printf '\033[36m')     # prompts
  _C_ORANGE=$(printf '\033[33m')   # yellow/amber: closest thing on 8-color terminals
  if [[ $_C_DEPTH -ge 256 ]]; then
    _C_ORANGE=$(printf '\033[38;5;208m')   # real orange
  fi

  # Old Glory palette for the logo: blue #0A3161 and red #B31942 on white.
  # 256-color uses the cube (not 0-15), so base16 themes can't remap it.
  if [[ $_C_DEPTH -eq 24 ]]; then
    _C_BG_WHITE=$(printf '\033[48;2;255;255;255m')
    _C_OG_BLUE=$(printf '\033[38;2;10;49;97m')
    _C_OG_RED=$(printf '\033[38;2;179;25;66m')
  elif [[ $_C_DEPTH -eq 256 ]]; then
    _C_BG_WHITE=$(printf '\033[48;5;231m')
    _C_OG_BLUE=$(printf '\033[38;5;17m')
    _C_OG_RED=$(printf '\033[38;5;161m')
  else
    _C_BG_WHITE=$(printf '\033[47m')
    _C_OG_BLUE=$(printf '\033[34m')
    _C_OG_RED=$(printf '\033[31m')
  fi
fi

ok()   { printf '%s%s%s\n' "$_C_GREEN"  "$*" "$_C_RESET"; }
warn() { printf '%s%s%s\n' "$_C_ORANGE" "$*" "$_C_RESET"; }
err()  { printf '%s%s%s\n' "$_C_RED"    "$*" "$_C_RESET"; }
note() { printf '%s%s%s\n' "$_C_CYAN"   "$*" "$_C_RESET"; }
dim()  { printf '%s%s%s\n' "$_C_DIM"    "$*" "$_C_RESET"; }
