#!/usr/bin/env zsh

# -- basic environments ----------------------------------------------------

## editor
export EDITOR=nvim
export GIT_EDITOR="$EDITOR"
export VISUAL="$EDITOR"

## pager
export PAGER=bat

## locale
export LANG=en_US.UTF-8

## colors
export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30"
export ZLS_COLORS="$LS_COLORS"

## separation
export WORDCHARS="*?_-.[]~&;!#$%^(){}<>"

## path
path=(
  "$XDG_BIN_HOME"(N-/)
  $path
)

## ssh-egent
if [[ -L "${HOME}/.ssh/ssh_auth_sock" ]]; then
  export SSH_AUTH_SOCK="/host$(readlink ${HOME}/.ssh/ssh_auth_sock)"
fi

# -- basic options ---------------------------------------------------------

## enable vi-mode
bindkey -v

## completion
ZSH_COMPLETION_DIR="${XDG_CACHE_HOME}/zsh/completion"
setopt AUTO_LIST
setopt AUTO_MENU
setopt AUTO_PARAM_SLASH
setopt COMPLETE_IN_WORD
setopt PATH_DIRS
setopt NO_MENU_COMPLETE
setopt NO_FLOW_CONTROL
zstyle ':completion:*' use-cache yes
zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME}/zsh/zcompcache"
zstyle ':zim:completion' dumpfile "${XDG_CACHE_HOME}/zsh/zcompdump"

## correct
setopt CORRECT
SPROMPT="correct %F{ret}%R%f to %F{green}%r%f ? [nyae] => "

## history
HISTFILE="${XDG_DATA_HOME}/zsh/history"
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt EXTENDED_HISTORY

## chpwd
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 500
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-file "${XDG_DATA_HOME}/zsh/chpwd-recent-dirs"
zstyle ':chpwd:*' recent-dirs-pushd true

# -- configure 'Zim' -------------------------------------------------------

export ZIM_HOME="${XDG_DATA_HOME}/zsh/zim"
if [[ ! "${ZIM_HOME}/init.zsh" -nt "${ZDOTDIR:-${HOME}}/.zimrc" ]]; then
  source "${ZIM_HOME}/zimfw.zsh" init -q
fi
source "${ZIM_HOME}/init.zsh"

# -- configure tools & plugins ---------------------------------------------

## auto suggestion
ZSH_AUTOSUGGEST_MANUAL_REBLEND=1
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666"

# -- load 'widgets' --------------------------------------------------------

source "${ZDOTDIR}/widgets/history.zsh"
source "${ZDOTDIR}/widgets/rsync.zsh"

# -- basic key bindings ----------------------------------------------------

bindkey          '^R' widget::history
bindkey -M viins 'jk' vi-cmd-mode
bindkey -M viins '^E' vi-add-eol
bindkey -M viins '^F' vi-forward-word

# -- aliases ---------------------------------------------------------------

alias ls='eza --icons --git'
alias la=l
alias l='ll -a'
alias cat=bat
alias e="$EDITOR"

# -- post processing -------------------------------------------------------

## remove duplicate value
typeset -gU path fpath manpath
