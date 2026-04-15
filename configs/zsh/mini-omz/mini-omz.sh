# Stripped down Oh-My-ZSH
# Refer to the original project for more:
# https://github.com/ohmyzsh/ohmyzsh


# Autoload colors -- required by colored man pages
autoload -U colors && colors

# Compfix
autoload -U compaudit compinit zrecompile

source "$HOME/.config/zsh/mini-omz/lib/compfix.zsh"
# Load only from secure directories
compinit -i -d "$ZSH_COMPDUMP"
# If completion insecurities exist, warn the user
handle_completion_insecurities &|



# Load config files
for config_file ($HOME/.config/zsh/mini-omz/lib/*.zsh); do
  source "$config_file"
done
