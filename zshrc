export NVM_LAZY_LOAD=true

# z.lua
export _ZL_CMD=j
export _ZL_ECHO=1

# zgen
if [[ -r "${HOME}/.zgen/zgen.zsh" ]]; then
  source "${HOME}/.zgen/zgen.zsh"
fi

if (( $+functions[zgen] )) && ! zgen saved; then
  echo "Creating a zgen save"

  zgen oh-my-zsh
  zgen oh-my-zsh plugins/git
  zgen oh-my-zsh plugins/git-flow
  zgen oh-my-zsh plugins/golang
  zgen oh-my-zsh plugins/docker
  zgen load lukechilds/zsh-nvm
  zgen oh-my-zsh plugins/node
  zgen oh-my-zsh plugins/npm
  zgen oh-my-zsh plugins/sudo

  zgen load zsh-users/zsh-history-substring-search
  zgen load zsh-users/zsh-completions src
  zgen load skywind3000/z.lua z.lua.plugin.zsh
  zgen load Aloxaf/fzf-tab fzf-tab.plugin.zsh
  zgen load zdharma-continuum/fast-syntax-highlighting

  zgen save
fi

(( $+functions[git_prompt_info] )) || git_prompt_info() { :; }
(( $+functions[git_prompt_status] )) || git_prompt_status() { :; }

# prompt
git_ahead_behind() {
  local ahead behind ahead_behind=""
  if read ahead behind < <(git rev-list --left-right --count HEAD...@{u} 2>/dev/null); then
    if (( ahead > 0 || behind > 0 )); then
      local sym
      if (( ahead > 0 && behind > 0 )); then
        sym="↕${ahead}↓${behind}"
      elif (( ahead > 0 )); then
        sym="↑${ahead}"
      else
        sym="↓${behind}"
      fi

      ahead_behind="%{$fg[yellow]%}${sym}%{$reset_color%}"
    fi
  fi
  echo "$ahead_behind"
}

prompt_tail_truncate() {
  local text="$1"
  local max="$2"
  local tail_len

  (( max < 1 )) && max=1

  if (( ${#text} > max )); then
    tail_len=$(( max - 3 ))
    (( tail_len < 1 )) && tail_len=1
    text="...${text[-$tail_len,-1]}"
  fi

  print -nr -- "${text//\%/%%}"
}

prompt_rendered_width() {
  setopt local_options extended_glob
  local rendered="${(%):-$1}"

  # Expand prompt escapes, then drop ANSI color codes to measure visible width only.
  rendered="${rendered//$'\e'\[[0-9;]##[[:alpha:]]/}"
  print -nr -- ${#rendered}
}

prompt_git_summary() {
  local width=${COLUMNS:-80}
  local path_text="$1"
  local time_text="$2"
  local branch branch_max branch_room git_status="" ahead="" static_width

  (( width < 40 )) && return 0

  branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null) || return 0

  if (( width >= 48 )); then
    git_status="$(git_prompt_status)"
  fi

  if (( width >= 72 )); then
    ahead="$(git_ahead_behind)"
  fi

  branch_max=$(( width < 52 ? 10 : width < 72 ? 16 : 24 ))
  static_width=$(( $(prompt_rendered_width "${time_text}${git_status}${ahead}") + 3 + ${#path_text} ))
  branch_room=$(( width - static_width ))
  (( branch_room > branch_max )) && branch_max=$branch_room
  branch="$(prompt_tail_truncate "$branch" "$branch_max")"

  print -nr -- "%{$fg_bold[blue]%}(%{$fg[red]%}${branch}%{$fg[blue]%})%{$reset_color%}${git_status}${ahead}%{$reset_color%} "
}

prompt_time_compact() {
  local width=${COLUMNS:-80}

  (( width < 70 )) && return 0

  print -nr -- "%{$fg[yellow]%} ${(%):-%*} %{$reset_color%}"
}

prompt_path_compact() {
  local width=${COLUMNS:-80}
  local path_text="$1"
  local prefix_text="$2"
  local max=$(( width - $(prompt_rendered_width "$prefix_text") ))

  print -nr -- "%{$fg_bold[cyan]%}$(prompt_tail_truncate "$path_text" "$max")%{$reset_color%}"
}

prompt_info_line() {
  local cwd_text="${PWD/#$HOME/~}"
  local time_text git_text prefix_text

  time_text="$(prompt_time_compact)"
  git_text="$(prompt_git_summary "$cwd_text" "$time_text")"
  prefix_text="${time_text}${git_text}"

  print -nr -- "${prefix_text}$(prompt_path_compact "$cwd_text" "$prefix_text")"
}

PROMPT='$(prompt_info_line)
%(?:%{$fg_bold[green]%}%1{➜%}%{$reset_color%} :%{$fg_bold[red]%}%1{➜%}%{$reset_color%} )'
RPROMPT=''

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%})"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}) %{$fg[green]%}%1{✔%}"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}A"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}M"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}D"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%}R"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}U"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[magenta]%}?"

zstyle ':fzf-tab:*' fzf-bindings 'space:accept'
zstyle ':fzf-tab:*(cat|ls)*' accept-line enter
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:complete:(cd|go):*' disabled-on any

alias em="emacs -nw"
alias vi="nvim"
alias ssh="zssh"
alias ag="rg"

export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export EDITOR="nvim"

# command not found handler
if [[ -r /etc/zsh_command_not_found ]]; then
  source /etc/zsh_command_not_found
fi

# golang
export GOPATH="$HOME/gopath"
export PATH="$PATH:$GOPATH/bin"

# jdk / android
if [[ -d "$HOME/androidx/jdk1.8.0_60" ]]; then
  export JAVA_HOME="$HOME/androidx/jdk1.8.0_60"
  export PATH="$PATH:$JAVA_HOME/bin"
fi
export ANDROID_HOME="$HOME/androidx/android-sdk-linux"

# history
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST

# rust
if command -v rustc >/dev/null 2>&1; then
  sysroot="$(rustc --print sysroot 2>/dev/null || true)"
  if [[ -n "$sysroot" ]]; then
    export RUST_SRC_PATH="$sysroot/lib/rustlib/src/rust/src"
    export LD_LIBRARY_PATH="$sysroot/lib${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"
  fi
fi

toolchain_lib="$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib"
if [[ -d "$toolchain_lib" ]]; then
  export LD_LIBRARY_PATH="$toolchain_lib${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"
fi

fpath+=("$HOME/.zfunc")

if (( $+commands[fzf] )); then
  source <(fzf --zsh)
  export FZF_DEFAULT_OPTS="--bind='tab:down,shift-tab:up' --cycle"
fi

[[ -f "$HOME/.skim/bin/sk" ]] && export PATH="$PATH:$HOME/.skim/bin"
(( $+commands[atuin] )) && eval "$(atuin init zsh --disable-up-arrow)"

[[ -f /usr/local/tinygo/bin/tinygo ]] && export PATH="$PATH:/usr/local/tinygo/bin"

if (( $+functions[compdef] )); then
  compdef _precommand graftcp mgraftcp proxychains
fi

unalias gops 2>/dev/null || true
unalias gg 2>/dev/null || true

DEBEMAIL="dustgle@gmail.com"
DEBFULLNAME="Mingang He"
export DEBEMAIL DEBFULLNAME

zgen_private_file="${ZGEN_DIR:-$HOME/.zgen}/priv.zsh"
[[ -s "$zgen_private_file" ]] && source "$zgen_private_file"

bindkey '^N' delete-word

if [[ -s "$HOME/.atuin/bin/env" ]]; then
  . "$HOME/.atuin/bin/env"
fi

[[ -f "$HOME/.ghcup/env" ]] && . "$HOME/.ghcup/env"

# bun
export BUN_INSTALL="${BUN_INSTALL:-$HOME/.bun}"
if [[ -s "$BUN_INSTALL/_bun" ]]; then
  source "$BUN_INSTALL/_bun"
fi
[[ -d "$BUN_INSTALL/bin" ]] && export PATH="$BUN_INSTALL/bin:$PATH"

# normalize PATH and switch to nvm default
export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  path=(${path:#$HOME/.nvm/versions/node/*/bin})
  path=(${path:#$HOME/.nvm/versions/node/*/bin/})

  . "$NVM_DIR/nvm.sh" --no-use
  nvm use --silent default >/dev/null 2>&1
fi

# keep PATH unique while preserving first-hit order
typeset -U path PATH
