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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Load history search 
# zinit ice wait lucid
# zinit load zdharma-continuum/history-search-multi-word

## pkgx
zinit ice wait lucid extract from'gh-r' as'program' trigger-load'!pkgx;!env' \
  bpick'*linux+x86-64*' atload'source <(pkgx --shellcode)'
zinit load pkgxdev/pkgx

## Python
# Assuming there will always be a version of python available
# Install pip
zinit ice wait lucid has'python3' as'program' \
  atload'export PYTHONUSERBASE=$ZPFX/local && export PYTHONPATH=$ZPFX/local/lib/$(readlink -n $(which python3))/dist-packages' \
  atclone'python3 get-pip.py --prefix=$ZPFX'
zinit snippet https://bootstrap.pypa.io/get-pip.py
export PATH=$PATH:$ZPFX/local/bin

# Load bash completion
# Azure CLI completion exist only for bash as of now. Please fix it, it's ugly :(
autoload -Uz bashcompinit
bashcompinit

## Kubernetes & helm
alias k=kubectl
zinit lucid as'program' from'gh-r' for \
  trigger-load'!kubectl' atload'source <(kubectl completion zsh)'\
    ChampiYann/kubectl-binaries \
  trigger-load'!helm' atload'source <(helm completion zsh)' pick'*/helm' \
    ChampiYann/helm-binaries

## Load kubectl and helm where starting VScode
code () {
  unset -f code
  eval kubectl > /dev/null
  eval helm > /dev/null
  eval code $@
}

## Openshift client (origin)
zinit ice lucid as'program' from'gh-r' bpick'*client*' pick'openshift*/oc' trigger-load'!oc' \
  atload'source <(oc completion zsh)' atclone'rm openshift*/kubectl'
zinit load openshift/origin

# jq for querying json output
zinit ice lucid as'program' from'gh-r' mv'jq-* -> jq' trigger-load'!jq'
zinit light jqlang/jq

# yq for querying yaml output
zinit ice lucid as'program' from'gh-r' mv'yq* -> yq' trigger-load'!yq'
zinit light mikefarah/yq

# Load fzf
zinit ice wait lucid from'gh-r' as'program' atload'source <(fzf --zsh)'
zinit light junegunn/fzf

# fzf jq integration. Truly amazing! (use it with kubectl and azure)
zinit ice wait lucid
zinit load reegnz/jq-zsh-plugin
# command: alt + j

# Ctrl+W to add 'watch' to the command or to the last command if buffer is empty
zinit ice wait lucid
zinit load enrico9034/zsh-watch-plugin

# pandoc
zinit ice wait lucid as'program' trigger-load'!pandoc' from'gh-r' pick'pandoc-*/bin/pandoc'
zinit light jgm/pandoc

# quarto
zinit ice wait lucid as'program' trigger-load'!quarto' from'gh-r' pick'quarto-*/bin/quarto'
zinit light quarto-dev/quarto-cli

# GPG
#export GPG_TTY=$(tty)
export GPG_TTY=$TTY

# Load Oh-my-zsh plugins
# Load auto suggestions (based on history)
# Load syntax highlighting
zinit wait lucid for \
  OMZ::plugins/git/git.plugin.zsh \
  OMZ::plugins/colorize/colorize.plugin.zsh \
  has'pipenv' \
    OMZ::plugins/pipenv/pipenv.plugin.zsh \
  silent\
    OMZ::plugins/ssh-agent/ssh-agent.plugin.zsh

zinit wait lucid for \
 atinit'ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay' \
    zdharma-continuum/fast-syntax-highlighting \
 blockf \
    zsh-users/zsh-completions \
 atload'!_zsh_autosuggest_start' \
    zsh-users/zsh-autosuggestions
bindkey "^[[1;5C" forward-word # Ctrl+right arrow completes a word

# source local zshrc script
if [[ -f "$HOME/.zshrc_local" ]]; then
  source "$HOME/.zshrc_local"
fi

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
