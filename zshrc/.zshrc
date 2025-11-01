# zsh config

## autocompletion
autoload -Uz compinit
compinit

## Colors
use_color=true

eval "$(oh-my-posh init zsh --config ~/.poshtheme.omp.json)"
export PATH="$PATH:/usr/local/bin"

# BEGIN SNIPPET: Magento Cloud CLI configuration
HOME=${HOME:-'/home/romain'}
export PATH="$HOME/"'.magento-cloud/bin':"$PATH"
if [ -f "$HOME/"'.magento-cloud/shell-config.rc' ]; then . "$HOME/"'.magento-cloud/shell-config.rc'; fi # END SNIPPET


# Created by `pipx` on 2025-10-22 19:24:58
export PATH="$PATH:/home/romain/.local/bin"
export PATH="$HOME/bin:$PATH"
TERM=xterm-256color
