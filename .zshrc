GIT_PS1_SHOWDIRTYSTATE=1

source ~/.cache/wal/colors.sh
source ~/.config/zsh/git-prompt.sh

PS1="[%F{$color4}%n%f@%F{$color2}%m%f %F{$color5}%~%f] %(!.#.$) "

#git branch in rps1
setopt PROMPT_SUBST
RPS1='%F{$color3}$(__git_ps1 " (%s)")%F'

#History confs.
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

#autocomplete with tabs
autoload -U compinit && compinit
zstyle ':completion:*' menu select

#key bindings
bindkey -e
bindkey ";5C" forward-word
bindkey ";5D" backward-word
bindkey "~" delete-char

#status bar
function precmd () {
    print -Pn -- '\e]2;%n@%m %~\a'
}

#aliases
[ -f "$HOME/.config/zsh/aliasrc" ] && source "$HOME/.config/zsh/aliasrc"

#to make del key work on st terminal
function zle-line-init () { echoti smkx }
function zle-line-finish () { echoti rmkx }
zle -N zle-line-init
zle -N zle-line-finish

#syntax hightlighting 
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#to color a wrong command, red
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=160'

