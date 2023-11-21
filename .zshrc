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

# Load standard keybindings (home, end, etc.)
#autoload zkbd ; zkbd

# Keybindings
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
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
    zdharma-continuum/zinit-annex-rust \
    zdharma-continuum/z-a-as-monitor \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-bin-gem-node

# Load powerlevel10k
zinit ice depth=1 atload'source ~/.p10k.zsh' nocd
zinit light romkatv/powerlevel10k

# zinit ice wait'!' lucid atload'source ~/.p10k.zsh; _p9k_precmd' nocd
# zinit light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Load history search 
zinit ice wait"1" lucid
zinit load zdharma-continuum/history-search-multi-word

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
zinit ice if'[[ ! $(command -v pip3) && $(command -v python3) ]]' as'program' wait lucid \
  atclone'python3 get-pip.py'  # You need this otherwise python doesn't know where to find it's packages
zinit snippet https://bootstrap.pypa.io/get-pip.py

# Load bash completion
# Azure CLI completion exist only for bash as of now. Please fix it, it's ugly :(
autoload -Uz bashcompinit
bashcompinit

## Azure CLI
# This basically a copy of the azure-cli install script in a completion snippet...
zinit ice if'[[ ! $(command -v az) && $(command -v pip3) && $(command -v python3) ]]' \
  id-as'az_completion' wait'[[ -n ${ZLAST_COMMANDS[(r)az*]} ]]' \
  as'program' atload'source az_completion' pick'$ZPFX/azure-cli/az' \
  atclone'pip3 install virtualenv; python3 -m virtualenv $ZPFX/azure-cli; source $ZPFX/azure-cli/bin/activate; pip3 install azure-cli --upgrade; deactivate; echo "#!/usr/bin/env bash" >> $ZPFX/azure-cli/az; echo "$ZPFX/azure-cli/bin/python -m azure.cli \"\$@\"" >>  $ZPFX/azure-cli/az'
zinit snippet https://github.com/Azure/azure-cli/blob/dev/az.completion

## Kubernetes
zinit ice trigger-load"!k;!kubectl" as"program" from"gh-r" trigger-load"!k;!kubectl" atload'source <(kubectl completion zsh)'
zinit load ChampiYann/kubectl-binaries
alias k=kubectl

## Helm
zinit ice as"program" from"gh-r" trigger-load"!helm" pick"*/helm" atload"source <(helm completion zsh)"
zinit load ChampiYann/helm-binaries

## Openshift client (origin)
zinit ice as'program' from'gh-r' bpick'*client*' pick'openshift*/oc' trigger-load'!oc' atload'source <(oc completion zsh)' atclone'rm openshift*/kubectl'
zinit load openshift/origin

## Go
zinit ice as'program' pick'go/bin/go' if'[[ ! $(command -v go) ]]' id-as'go' extract
zinit snippet https://golang.org/dl/go1.17.7.linux-amd64.tar.gz

# jq for querying json output
zinit ice as"program" from"gh-r" mv"jq-* -> jq"
zinit light jqlang/jq

# Load fzf
if [[ $(command -v go) ]]; then # Needs go to succeed
  # zinit pack"binary" for fzf
  # source $HOME/.zinit/completions/_fzf_completion # source the completion file, because I don't know why...
  # zinit pack"bgn+keys" for fzf
  zinit ice from"gh-r" as"program" id-as"fzf-bin"
  zinit light junegunn/fzf

  zinit ice wait lucid multisrc'shell/{key-bindings,completion}.zsh'
  zinit light junegunn/fzf
else
  echo ""
  echo "Install go to use fzf."
  echo "Skipping fzf installation."
fi

# fzf jq integration. Truly amazing! (use it with kubectl and azure)
zinit ice wait lucid
zinit load reegnz/jq-zsh-plugin
# command: alt + j

# Ctrl+W to add 'watch' to the command or to the last command if buffer is empty
zinit ice wait lucid
zinit load enrico9034/zsh-watch-plugin

# java 11
# zinit ice as"program" if'[[ ! $(command -v java) ]]' from"gh-r" bpick"*jdk_x64_linux_hotspot*" \
#   pick'jdk-11*/bin/jav' extract id-as'jdk-11' atload'export JAVA_HOME=$(which java | cut -f -7 -d /)' \
#   trigger-load'!java'
# zinit load adoptium/temurin11-binaries
zinit ice as"program" if'[[ ! $(command -v java) ]]' from"gh-r" atload'export JAVA_HOME=$(which java | cut -f -7 -d /)' \
  trigger-load'!java' bpick"*jdk_x64_linux_hotspot*" pick'jdk-11*/bin/*'
zinit load adoptium/temurin11-binaries

# Maven
zinit ice as'program' pick'apache-maven-*/bin/mvn' if'[[ ! $(command -v mvn) ]]' extract trigger-load'!mvn'
# zinit snippet https://dlcdn.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
# zinit snippet https://dlcdn.apache.org/maven/maven-3/3.8.5/binaries/apache-maven-3.8.5-bin.tar.gz
zinit snippet https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz

# GPG
#export GPG_TTY=$(tty)
export GPG_TTY=$TTY

# Load Oh-my-zsh plugins
# Load auto suggestions (based on history)
# Load syntax highlighting
zinit wait lucid for \
  OMZ::plugins/git/git.plugin.zsh \
  OMZ::plugins/colorize/colorize.plugin.zsh \
  OMZ::plugins/pipenv/pipenv.plugin.zsh \
  OMZ::plugins/history/history.plugin.zsh \
  OMZ::plugins/command-not-found/command-not-found.plugin.zsh \
  OMZ::plugins/ssh-agent/ssh-agent.plugin.zsh
bindkey "^[[1;5C" forward-word # Ctrl+right arrow completes a word

zinit wait lucid for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
 blockf \
    zsh-users/zsh-completions \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions
bindkey "^[[1;5C" forward-word # Ctrl+right arrow completes a word

# source podman completion
source <(podman completion zsh)

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

# Set git config
alias gpers='git config user.email \"yann.rosema@hotmail.com\"; git config user.name \"Yann\ Rosema\"'
alias gcgk='git config user.email \"yann.rosema@cegeka.com\"; git config user.name \"Yann\ Rosema\"'

# Git alias for the config/dotfile repo
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
