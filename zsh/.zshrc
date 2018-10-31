# Path to your oh-my-zsh installation.
export ZSH=/Users/jose.armesto/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="fiunchinho"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
plugins=(git extract zsh-autosuggestions zsh-syntax-highlighting alias-tips)

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

######################
# User configuration #
######################
export GOPATH="$HOME/dev"
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH="/usr/local/opt/python/libexec/bin:$PATH"
export PATH="/usr/local/opt/php71/bin:$PATH"
export PATH="$GOPATH/bin:$PATH"
export ZSH_PLUGINS_ALIAS_TIPS_REVEAL=1

source $ZSH/oh-my-zsh.sh
source "${HOME}/.iterm2_shell_integration.zsh"

# AutoJump
. /usr/local/etc/profile.d/autojump.sh

# https://stackoverflow.com/questions/11670935/comments-in-command-line-zsh
setopt interactivecomments

# https://unix.stackexchange.com/questions/114074/tab-completion-of-in-zsh
zstyle ':completion:*' special-dirs true

# formatting and messages
# http://www.masterzen.fr/2009/04/19/in-love-with-zsh-part-one/
zstyle ':completion:*' verbose yes
zstyle ':completion:*' group-name ''

# https://github.com/jonmosco/kube-ps1
KUBE_PS1_PREFIX=''
KUBE_PS1_SUFFIX=''
KUBE_PS1_SYMBOL_ENABLE=false
KUBE_PS1_CTX_COLOR='blue'
KUBE_PS1_NS_COLOR='yellow'
source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
MY_KUBE_PS1="%{$fg_bold[blue]%}[%{$reset_color%}"'$(kube_ps1)'"%{$fg_bold[blue]%}]%{$reset_color%} "
PROMPT=$PROMPT$MY_KUBE_PS1

# Required for jenv (managing different java versions)
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init - --no-rehash)"
(jenv rehash &) 2> /dev/null

# Make Kubernetes use sublime text to edit resources
export KUBE_EDITOR="vim"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias idea="open -a IntelliJ\ IDEA $1"

dexec() { docker exec -it $1 /bin/sh }

ddebug() {
    docker run -t --pid=container:$1 \
      --net=container:$1 \
      --cap-add sys_admin \
      --cap-add sys_ptrace \
      alpine sh
}

gclone() {
    repo=${1#(git@|https://)}
    repo=${repo%".git"}
    repo="${repo/://}"
    take "${GOPATH}/src/$repo"
    git clone $1 ${PWD} || git pull
    idea .
    [[ -f "build.gradle" ]] && ./gradlew assemble
    [[ -f "composer.json" ]] && composer install
    [[ -f "package.json" ]] && npm install
}

export HISTFILE=~/.zsh_history  # ensure history file visibility
export HH_CONFIG=hicolor        # get more colors
bindkey -s "\C-r" "\eqhh\n"     # bind hh to Ctrl-r (for Vi mode check doc)
prompt_dir () {
    prompt_segment blue black '~'
}
