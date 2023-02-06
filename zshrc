export NVM_LAZY_LOAD=true

# for z.lua
export _ZL_CMD=j
export _ZL_ECHO=1

# load zgen
source "${HOME}/.zgen/zgen.zsh"

# if the init scipt doesn't exist
if ! zgen saved; then
    echo "Creating a zgen save"

    zgen oh-my-zsh

    # plugins
    # plugins=(git git-flow history-substring-search golang docker node npm cargo rust rebar)
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/git-flow
    # zgen oh-my-zsh plugins/history-substring-search
    zgen oh-my-zsh plugins/golang
    zgen oh-my-zsh plugins/docker
    zgen load lukechilds/zsh-nvm
    zgen oh-my-zsh plugins/node
    zgen oh-my-zsh plugins/npm
    zgen oh-my-zsh plugins/sudo
    # zgen oh-my-zsh plugins/command-not-found

    # zgen load zsh-users/zsh-syntax-highlighting

    # bulk load
    zgen loadall <<EOPLUGINS
        zsh-users/zsh-history-substring-search
EOPLUGINS
    # ^ can't indent this EOPLUGINS

    # completions
    zgen load zsh-users/zsh-completions src

    # theme
    # zgen oh-my-zsh themes/arrow
    zgen oh-my-zsh themes/robbyrussell

    zgen load skywind3000/z.lua z.lua.plugin.zsh

    # save all to init script
    zgen save
fi

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias em="emacs -nw"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to disable command auto-correction.
# DISABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# plugins=(git history-substring-search golang docker z nvm node npm cargo rust safe-paste)
## plugins=(git git-flow history-substring-search golang docker node npm cargo rust rebar)
##
## source $ZSH/oh-my-zsh.sh

# User configuration

export PATH=$HOME/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

export EDITOR='nvim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# 未找到命令安装提示
source /etc/zsh_command_not_found

# golang
export GOPATH="$HOME/gopath"
export PATH=$PATH:$GOPATH/bin
# export GO15VENDOREXPERIMENT=1
export GO111MODULE=auto

# jdk
export JAVA_HOME="$HOME/androidx/jdk1.8.0_60"
export PATH="$PATH:$HOME/androidx/jdk1.8.0_60/bin"

# Android
export ANDROID_HOME="$HOME/androidx/android-sdk-linux"

# history
HISTSIZE=100000
SAVEHIST=100000
# tip: zsh 终端输入 setopt 可列出所有 enable 变量,
# unsetopt 列出所有 unenable 变量
setopt histignoredups

# Don’t push multiple copies of the same directory onto the
# directory stack.
# setopt PUSHD_IGNORE_DUPS

# If a new command line being added to the history list
# duplicates an older one, the older command is removed
# from the list (even if it is not the previous event).
setopt HIST_IGNORE_ALL_DUPS

# Remove superfluous blanks from each command line
# being added to the history list.
setopt HIST_REDUCE_BLANKS

setopt HIST_IGNORE_SPACE

# setopt HIST_NO_STORE

# Whenever the user enters a line with history expansion,
# don’t execute the line directly; instead, perform history
# expansion and reload the line into the editing buffer.
# setopt HIST_VERIFY

# Save each command’s beginning timestamp (in seconds since the epoch)
# and the duration (in seconds) to the history file.
# setopt EXTENDED_HISTORY

# When writing out the history file, older commands that duplicate
# newer ones are omitted.
setopt HIST_SAVE_NO_DUPS

# If the internal history needs to be trimmed to add the current
# command line, setting this option will cause the oldest history
# event that has a duplicate to be lost before losing a unique event
# from the list. You should be sure to set the value of HISTSIZE to
# a larger number than SAVEHIST in order to give you some room for
# the duplicated events, otherwise this option will behave just like
# HIST_IGNORE_ALL_DUPS once the history fills up with unique events.
setopt HIST_EXPIRE_DUPS_FIRST

# When searching for history entries in the line editor, do not
# display duplicates of a line previously found, even if the
# duplicates are not contiguous.
# setopt HIST_FIND_NO_DUPS

# # rbenv {{
# export PATH="$HOME/.rbenv/bin:$PATH"
# eval "$(rbenv init -)"
#
# export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
# # }}

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

#alias for cnpm
alias cnpm="npm --registry=https://registry.npm.taobao.org \
  --cache=$HOME/.npm/.cache/cnpm \
  --disturl=https://npm.taobao.org/dist \
  --userconfig=$HOME/.cnpmrc"

export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
export LD_LIBRARY_PATH=$(rustc --print sysroot)/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/home/gle/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib:$LD_LIBRARY_PATH

fpath+=~/.zfunc

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.skim/bin/sk ] && export PATH="$PATH:$HOME/.skim/bin"

alias ssh="zssh"
alias ag="rg"

[ -f /usr/local/tinygo/bin/tinygo ] && export PATH=$PATH:/usr/local/tinygo/bin
export PATH=$HOME/.local/bin:$PATH

compdef _precommand graftcp mgraftcp proxychains

# function graftcp {
#    command graftcp zsh -i -c "$*" # command to prevent recursion,  -i to force bash to read .bashrc
# }

unalias gops 2>/dev/null || true

DEBEMAIL="dustgle@gmail.com"
DEBFULLNAME="Mingang He"
export DEBEMAIL DEBFULLNAME

# autoload -U compinit && compinit -u

alias vi="nvim"

[ -s "$ZGEN_DIR/priv.zsh" ] && source "$ZGEN_DIR/priv.zsh"
