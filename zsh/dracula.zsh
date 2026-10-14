# Shell visuals + quality-of-life, Dracula themed.
# Sourced at the END of ~/.zshrc (install.sh adds the line) so it runs after
# compinit and after any personal aliases it overrides.

BREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"

##------------------------------------------------------------------------------
## History
##------------------------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt EXTENDED_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS \
  HIST_VERIFY SHARE_HISTORY INC_APPEND_HISTORY
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS INTERACTIVE_COMMENTS

# Up/down search history by the prefix already typed
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

##------------------------------------------------------------------------------
## Colors (Dracula)
##------------------------------------------------------------------------------
# LS_COLORS drives eza, completion menus and fd
command -v vivid >/dev/null && export LS_COLORS="$(vivid generate dracula)"
export BAT_THEME="Dracula"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

##------------------------------------------------------------------------------
## Completion
##------------------------------------------------------------------------------
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{#bd93f9}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{#ff5555}-- no matches --%f'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zcompcache"

##------------------------------------------------------------------------------
## fzf — Ctrl-R history, Ctrl-T files, Alt-C cd
##------------------------------------------------------------------------------
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border=rounded \
--color=fg:#f8f8f2,bg:-1,hl:#bd93f9 \
--color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 \
--color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 \
--color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4,border:#6272a4"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:300 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always --icons {}'"
command -v fzf >/dev/null && source <(fzf --zsh)

##------------------------------------------------------------------------------
## Modern replacements
##------------------------------------------------------------------------------
if command -v eza >/dev/null; then
  alias ls='eza --group-directories-first --icons'
  alias ll='eza -l -g --git --icons --group-directories-first'
  alias la='eza -la -g --git --icons --group-directories-first'
  alias lt='eza --tree --level=2 --icons'
fi

# `z foo` jumps to the best match, `zi` picks interactively with fzf
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

##------------------------------------------------------------------------------
## Git helpers (fzf-powered)
##------------------------------------------------------------------------------
alias lg='lazygit'

# Fuzzy-pick a branch (local + remote) and check it out
function fco() {
  local branch
  branch=$(git branch --all --sort=-committerdate --format='%(refname:short)' |
    grep -v HEAD |
    fzf --preview 'git log --oneline --graph --color=always -20 {}') || return
  git checkout "${branch#origin/}"
}

# Browse the log; Enter shows the commit in delta
function flog() {
  git log --oneline --color=always --decorate "$@" |
    fzf --ansi --no-sort --preview 'git show --color=always {1} | delta' \
      --bind 'enter:execute(git show {1} | delta --paging=always)'
}

##------------------------------------------------------------------------------
## Prompt + plugins (syntax-highlighting must be last)
##------------------------------------------------------------------------------
command -v starship >/dev/null && eval "$(starship init zsh)"

if [ -f "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6272a4'
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
fi

if [ -f "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  # Dracula colors (from dracula/zsh-syntax-highlighting)
  typeset -gA ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor)
  ZSH_HIGHLIGHT_STYLES[comment]='fg=#6272a4'
  ZSH_HIGHLIGHT_STYLES[alias]='fg=#50fa7b'
  ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#50fa7b'
  ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#50fa7b'
  ZSH_HIGHLIGHT_STYLES[function]='fg=#50fa7b'
  ZSH_HIGHLIGHT_STYLES[command]='fg=#50fa7b'
  ZSH_HIGHLIGHT_STYLES[precommand]='fg=#50fa7b,italic'
  ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#ffb86c,italic'
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#ffb86c'
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#ffb86c'
  ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#bd93f9'
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=#8be9fd'
  ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#8be9fd'
  ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#8be9fd'
  ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#ff79c6'
  ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#f8f8f2'
  ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#f8f8f2'
  ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#ff79c6'
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#f1fa8c'
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#f1fa8c'
  ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#f1fa8c'
  ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#f1fa8c'
  ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#f8f8f2'
  ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#f8f8f2'
  ZSH_HIGHLIGHT_STYLES[assign]='fg=#f8f8f2'
  ZSH_HIGHLIGHT_STYLES[redirection]='fg=#f8f8f2'
  ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#f8f8f2'
  ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#f8f8f2'
  ZSH_HIGHLIGHT_STYLES[path]='fg=#f8f8f2'
  ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#ff79c6'
  ZSH_HIGHLIGHT_STYLES[globbing]='fg=#f8f8f2'
  ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#bd93f9'
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#ff5555'
  ZSH_HIGHLIGHT_STYLES[bracket-error]='fg=#ff5555'
  ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=#ffb86c'
  ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=#bd93f9'
  ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=#ff79c6'
  ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]='standout'
  source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
