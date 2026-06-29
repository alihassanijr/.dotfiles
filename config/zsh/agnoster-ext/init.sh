# Loader + routing config for the agnoster extensions. zshrc sources only this.

### Segment routing ##########################################################
# The one place to choose where each segment shows. Values:
#   prompt   = inline prompt only
#   tmux     = pane title; falls back inline when there's no tmux
#   tmuxonly = pane title only; hidden entirely when there's no tmux
#   both     = everywhere
# (Routing is a no-op unless OMZ_TMUX_TITLE=1 and inside tmux; see zshrc.)
: ${OMZ_DEST_STATUS:=prompt}
: ${OMZ_DEST_VIRTUALENV:=prompt}
: ${OMZ_DEST_AWS:=prompt}
: ${OMZ_DEST_USER:=tmux}        # username
: ${OMZ_DEST_HOST:=tmux}        # hostname
: ${OMZ_DEST_NVGPU:=tmux}       # nvidia gpu name
: ${OMZ_DEST_NPROC:=tmuxonly}   # cpu count -- title only, never inline
: ${OMZ_DEST_ARCH:=tmuxonly}    # cpu arch  -- title only, never inline
: ${OMZ_DEST_DIR:=prompt}       # changes constantly -> stay inline
: ${OMZ_DEST_GIT:=prompt}       # changes constantly -> stay inline
: ${OMZ_DEST_VCS:=prompt}       # bzr / hg
: ${OMZ_DEST_CMD:=tmuxonly}     # last command run -- title only

### Load order ###############################################################
# Stock theme first, then each extension (tmux.sh last, as it overrides
# prompt_segment / prompt_end / build_prompt).
source ~/.config/zsh/mini-omz/themes/agnoster.zsh-theme

source ~/.config/zsh/agnoster-ext/truncate.sh   # shared helpers
source ~/.config/zsh/agnoster-ext/dir.sh        # working directory
source ~/.config/zsh/agnoster-ext/git.sh        # git branch / status
source ~/.config/zsh/agnoster-ext/sysinfo.sh    # user, host, gpu, cpu count, arch
source ~/.config/zsh/agnoster-ext/tmux.sh       # routing, caching, title
