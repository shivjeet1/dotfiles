GIT_PS1_SHOWDIRTYSTATE=1

source ~/.cache/wal/colors.sh
source ~/.config/zsh/git-prompt.sh

PS1="[%F{$color4}%n%f@%F{$color2}%m%f %F{$color5}%~%f] %(!.#.$) "

setopt PROMPT_SUBST
RPS1='%F{$color3}$(__git_ps1 " (%s)")%F'

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# OPTIMIZED: Added -C to skip security checks and use cache, saving ~50-100ms
autoload -Uz compinit && compinit -C
zstyle ':completion:*' menu select

bindkey -e
bindkey ";5C" forward-word
bindkey ";5D" backward-word
bindkey "~" delete-char

function precmd () {
    print -Pn -- '\e]2;%n@%m %~\a'
}

[ -f "$HOME/.config/zsh/aliasrc" ] && source "$HOME/.config/zsh/aliasrc"

# OPTIMIZED: Stripped the slow Ruby execution and removed duplicate PATHs. 
export GEM_HOME="$HOME/gems"
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/gems/bin:$PATH"

export ANDROID_HOME=/opt/android-sdk
export ANDROID_SDK_ROOT=/opt/android-sdk
export NDK_HOME=/opt/android-sdk/ndk-bundle
export PATH="$PATH:$ANDROID_HOME/platform-tools"

export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
export PATH="$JAVA_HOME/bin:$PATH"

# OPTIMIZED: Lazy-load NVM. This saves ~200-500ms on startup.
# It stays dormant until you type a node-related command.
export NVM_DIR="$HOME/.nvm"
zsh-nvm-lazy-load() {
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
alias nvm="unalias nvm node npm npx yarn; zsh-nvm-lazy-load; nvm"
alias node="unalias nvm node npm npx yarn; zsh-nvm-lazy-load; node"
alias npm="unalias nvm node npm npx yarn; zsh-nvm-lazy-load; npm"
alias npx="unalias nvm node npm npx yarn; zsh-nvm-lazy-load; npx"
alias yarn="unalias nvm node npm npx yarn; zsh-nvm-lazy-load; yarn"

# Syntax highlighting must stay at the very end
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=160'

clear
xrdb -merge /home/shiv/Xresources

