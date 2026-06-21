# Ali's .dotfiles

Programs I need, locked to exact versions I need, cross-platform, runnable on (almost) anything.

Configs for said programs, rc files, and other helpers.

Rest of readme is AI-generated, pinch of coarse kosher salt needed.

## PREREQUISITES

Obviously `git`, basic c/c++ compiler, `tar`, `curl`, `zip`/`unzip`.

## RUN

Read Makefile and just run `install.sh`. You don't need `make` to build.

```
make
make WORKERS=8 install
```

## KNOBS

- `WORKERS=N` — build parallelism. Default 1.
- `BUILD_ONLY=1` — build programs only, no linking config/rc files. Brew-only tools skipped.
- `PROGRAMS_PATH=dir` — where tools go. Default `~/.programs/<distro-or-os>_<arch>`.
- `IS_PERSONAL=1`: run on personal devices that need the personal tmux config, terminal emulator config, pdf viewer, latex. Default 1 on mac devices.

## PROGRAMS

- Built from source: make, m4, autoconf, automake, pkg-config, ncurses, gettext, coreutils, gnu-awk, gnu-grep, gnu-sed, watch, cmake, parallel, clang-format, tmux, vim, vifm, bash, zsh, htop, cmatrix.
- Grabbed prebuilt (binary/dist): uv, fzf, bat, lsd, rg, tre, git-lfs, diff-so-fancy, claude, codex.
- Brew only (skip in BUILD_ONLY): wget, zathura.

## NOTICE
Use at your own risk. I develop this specifically for myself.
