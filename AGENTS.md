<!-- AI-generated. Verify against the code before trusting any claim here. -->
# AGENTS.md

Map and rules for anyone (human or agent) editing this repo. `CLAUDE.md` is a symlink to this file.
The repo must live at `~/.dotfiles`; every symlink the installer creates points back into it.

## Layout

| Path | What it is | Where it lands |
|------|------------|----------------|
| `install.sh` | Entry point. Run via `make` / `make install`. | |
| `installer/` | Installer library, sourced by `install.sh`. | |
| `rcfiles/<program>/X` | Single rc files. | `~/.X` |
| `config/<program>/` | Config directories. | `~/.config/<program>`; vim `~/.vim`, vifm `~/.vifm` |
| `scripts/` | Standalone executables (`vif`, `4w`, `sagent`). | copied to `$LOCALDIR/bin` |
| `agentfiles/<agent>/` | Coding agent configs; linked only if that agent is installed. | `~/.<agent>` |
| `resources/` | Fonts, screenshots, macOS notes, `zprofile.mac`. | |
| `Makefile` | `install` (default), `check` (syntax-check all `*.sh`), `test-claude-hooks`. | |

### Programs

Built or fetched into `$PROGRAMS_PATH`, default `~/.programs/<distro>_<arch>`. Nothing needs sudo.

- `.local/` (`$LOCALDIR`): binaries, libs, man pages. Everything built from source installs here.
- `.ncurses/` (`$NCDIR`): ncursesw, kept separate; tmux and vim build against it.
- `.brew/`: homebrew, only for the few brew-only tools (wget, zathura).
- `.uv-python/`, `.python-base/`: uv-managed pythons and the base venv commonrc activates.
- `.fzf/`: fzf.

`rcfiles/common/commonrc` computes the same path as `LOCAL_HOME_PATH` and puts these on `PATH`,
`LD_LIBRARY_PATH`, `MANPATH`. Before building, `install.sh` strips brew from `PATH`: brew's
pkg-config conflicts with ours.

### Installer

- `prolog.sh`: globals. `THISDIR`, `HOMEDIR`, `PROGRAMS_PATH`, `LOCALDIR`, `NCDIR`, `BREWDIR`,
  `PYTHON_BASE_VENV_DIR`, `NUM_WORKERS`, `BUILD_ONLY`, `IS_PERSONAL` (default 1 on mac, else 0).
- `utils.sh`: helpers. `check_and_install_dependency NAME PATH INSTALL_FN` skips when `PATH` exists,
  else prompts and calls `INSTALL_FN`. `configure_dependency` is skipped under `BUILD_ONLY`;
  `preconfigure_dependency` is not. `fetch_package` (mirrors, wget then curl), `build_tmpdir`,
  symlink helpers `link_file` / `link_directory` / `link_to_home`, and `link_bin` (copy, not link).
- `deps.sh`: one `ensure_<program>` per program; sources `dependencies/<program>.sh`.
- `dependencies/<program>.sh`: pinned version, `install_<program>` (build from source into
  `$LOCALDIR`, or fetch a prebuilt binary per OS/arch), optional `configure_<program>` that links
  that program's rcfiles/config.
- `configs.sh`: `link_*` for things not tied to one program: commonrc, bashrc, inputrc, colors,
  gitconfig, agentfiles, custom scripts.
- `check.sh`: `make check`. Runs `<shell> -n` on every `*.sh`, shell picked from the shebang.
- `colors.sh`, `logo.sh`, `permissions.sh`: output helpers, banner, `fix_permissions`.

Order in `install.sh` matters: git, brew, uv first; then build tools; ncurses; utilities; then
everything else. Config linking runs last and only when `BUILD_ONLY != 1`.

### rcfiles

- `common/commonrc` → `~/.commonrc`. Shared by bash and zsh: paths, venv, aliases, functions.
- `bash/bashrc` → `~/.bashrc2`. The installer appends one source line to `~/.bashrc`; it never
  overwrites it.
- `zsh/zshrc` → `~/.zshrc`. Sources `config/zsh/` (mini-omz, agnoster-ext, highlight colors).
- `tmux/tmux.conf` (remote) or `tmux/tmux.personal.conf` (`IS_PERSONAL`) → `~/.tmux.conf`.
- `vim/vimrc` → `~/.vimrc`. `git/`, `input/`, `colors/` (base16, vivid-generated lscolors), `vifm/`.

Machine-local overrides, gitignored, linked only if present: `common/commonrc-pre`, `-mid`,
`-post` (sourced at top, after PATH setup, at end), `git/gitconfig-local`, `vim/vimrc-local`.

### config

`config/vim/pack-large/` is gitignored. Large vim plugins (vim-polyglot, vimtex) are downloaded by
`configure_vim` with a pinned sha256; everything else under `config/vim/pack` is tracked.

## Adding a program

1. `installer/dependencies/<name>.sh`: pin the version, write `install_<name>`, and
   `configure_<name>` if it has config to link.
2. `installer/deps.sh`: `source` it and add `ensure_<name>`.
3. `install.sh`: call `ensure_<name>` after its dependencies.
4. Its rc files go in `rcfiles/<name>/`, config dirs in `config/<name>/`.

## Rules

### Conditional sourcing: explicit `if` only

```sh
# WRONG: status 1 when the file is absent. As the last line of an rc file, `source ~/.commonrc`
# itself returns 1, and `source ~/.commonrc && cmd` (what _ssh_commonrc runs) never runs cmd.
[ -f $HOME/.commonrc-post ] && source $HOME/.commonrc-post

# RIGHT
if [[ -f $HOME/.commonrc-post ]]; then
  source $HOME/.commonrc-post
fi
```

Applies to every shell rc file under `rcfiles/` and every optional hook, existing or new.
