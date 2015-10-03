# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

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
plugins=(git history-substring-search)

source $ZSH/oh-my-zsh.sh

# User configuration

export PATH=$HOME/bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
export EDITOR='vim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# 未找到命令安装提示
source /etc/zsh_command_not_found

# golang
export GOPATH="$HOME/gopath/"
export PATH=$PATH:$GOPATH/bin

# jdk
export JAVA_HOME="$HOME/androidx/jdk1.8.0_60"
export PATH="$PATH:$HOME/androidx/jdk1.8.0_60/bin"

# Android
export ANDROID_HOME="$HOME/androidx/android-sdk-linux"

# history
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

# autojump
. /usr/share/autojump/autojump.sh
