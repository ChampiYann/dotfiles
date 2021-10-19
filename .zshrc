# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Configure list colors
export LS_COLORS='rs=0:no=00:mi=00:mh=00:ln=01;36:or=01;31:di=01;34:ow=04;01;34:st=34:tw=04;34:pi=01;33:so=01;33:do=01;33:bd=01;33:cd=01;33:su=01;35:sg=01;35:ca=01;35:ex=01;32:'

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd nomatch notify 
setopt globdots # Add dot files to completion
setopt INC_APPEND_HISTORY # Write to history as soon as the command is entered
unsetopt beep extendedglob
bindkey -e
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle :compinstall filename '/home/yannr/.zshrc'
# End of lines added by compinstall

# zstyle ':completion:*' file-list all # Show a complete list as completion, cannot show colors from list-colors :(
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} # Add colors to completion list
zstyle ':completion:*' group-name '' # Group completion
zstyle ':completion:*' menu select # Enable navigatable menu in completion, double tab to enter
# Completion descriptions
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f' 


### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

# Load powerlevel10k
zinit ice depth=1
zinit light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Load node
zinit light lukechilds/zsh-nvm

# Load history enquirer, needs installation and nvm to be loaded
if [[ $(command -v fcenquire) ]]; then
  zinit ice atclone'export HISTFILE' \  # Somehow I need to force the export of the histfile
    pick'scripts/zsh-history-enquirer.plugin.zsh'
  zinit light zthxxx/zsh-history-enquirer
else
  echo ""
  echo "History enquirer logic not installed."
  echo "Make sure nvm/nodejs is installed and run \"npm i -g zsh-history-enquirer\""
  echo "Skipping plugin installation."
fi

## Python
# Python 3.8
# If there is no version of python3 available, install python 3.8
zinit ice if'[[ ! $(command -v python3) ]]' lucid as'program' make'install' pick'$ZPFX/python3.8/bin/*' \
  atclone'tar --strip-components=1 -zxf v3.8.12.tar.gz; ./configure --prefix=$ZPFX/python3.8 --enable-optimizations'
zinit snippet https://github.com/python/cpython/archive/refs/tags/v3.8.12.tar.gz

# Python 3.9
zinit ice if'[[ ! $(command -v python3.9) ]]' wait'[[ -n ${ZLAST_COMMANDS[(r)p3.9]} ]]' lucid as'program' make'install' \
  pick'$ZPFX/python3.9/bin/*3.9' atclone'tar --strip-components=1 -zxf v3.9.7.tar.gz; ./configure --prefix=$ZPFX/python3.9 --enable-optimizations'
zinit snippet https://github.com/python/cpython/archive/refs/tags/v3.9.7.tar.gz

# Python 3.10
zinit ice if'[[ ! $(command -v python3.10) ]]' wait'[[ -n ${ZLAST_COMMANDS[(r)p3.10]} ]]' lucid as'program' make'install' \
  pick'$ZPFX/python3.10/bin/*3.10' atclone'tar --strip-components=1 -zxf v3.10.0.tar.gz; ./configure --prefix=$ZPFX/python3.10 --enable-optimizations'
zinit snippet https://github.com/python/cpython/archive/refs/tags/v3.10.0.tar.gz

# Install pip
zinit ice if'[[ ! $(command -v pip) && $(command -v python3) ]]' as'program' pick'$ZPFX/pip/bin/pip3' \
  atclone'python3 get-pip.py --prefix=$ZPFX/pip' atload'export PYTHONUSERBASE=$ZPFX/pip'  # You need this otherwise python doesn't know where to find it's packages
zinit snippet https://bootstrap.pypa.io/get-pip.py

## Azure CLI
zinit ice if'[[ ! $(command -v az) && $(command -v pip) && $(command -v python3) ]]' \
  id-as'az_completion' wait'[[ -n ${ZLAST_COMMANDS[(r)azure*]} ]]' \
  as'program' atload'source az_completion' pick'$ZPFX/azure-cli/az' \ # This is weird but it works...
  atclone'pip3 install virtualenv; python3 -m virtualenv $ZPFX/azure-cli; source $ZPFX/azure-cli/bin/activate; pip3 install azure-cli --upgrade; deactivate; echo "#!/usr/bin/env bash" >> $ZPFX/azure-cli/az; echo "$ZPFX/azure-cli/bin/python -m azure.cli \"\$@\"" >>  $ZPFX/azure-cli/az'
zinit snippet https://github.com/Azure/azure-cli/blob/dev/az.completion

## Kubernetes
# kubectl installation
zinit ice as'program' pick'kubectl' if'[[ ! $(command -v kubectl) ]]'
zinit snippet https://dl.k8s.io/release/v1.22.2/bin/linux/amd64/kubectl
# kubectl completion as aliases
zinit ice if'[[ $(command -v kubectl) ]]'
zinit snippet OMZP::kubectl

## Go
zinit ice as'program' pick'go/bin/go' if'[[ ! $(command -v go) ]]' extract
zinit snippet https://golang.org/dl/go1.17.2.linux-amd64.tar.gz

# Load fzf
if [[ $(command -v go) ]]; then # Needs go to succeed
  zinit pack"binary" for fzf
  source /home/yannr/.zinit/completions/_fzf_completion # source the completion file, because I don't know why...
else
  echo ""
  echo "Install go to use fzf."
  echo "Skipping fzf installation."
fi

# Load Oh-my-zsh plugins
zinit snippet OMZP::git
zinit snippet OMZP::colorize
zinit snippet OMZP::pipenv
zinit snippet OMZP::history
zinit snippet OMZP::command-not-found

# Load auto suggestions (based on history)
zinit light zsh-users/zsh-autosuggestions

# Load syntax highlighting
zinit light zdharma/fast-syntax-highlighting

# Load bash completion
autoload -Uz bashcompinit
bashcompinit

# run compinit
autoload -Uz compinit
compinit

# replay compdef for catched completions
zinit cdreplay -q

# Add ls colors
alias ls='ls --color=auto'

# List directory contents
alias lsa='ls -lah'
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'

# Clear alias
alias c='clear'