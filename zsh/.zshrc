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
plugins=(git brew sublime extract autojump zsh-autosuggestions you-should-use kubectl)

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

######################
# User configuration #
######################

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

source $ZSH/oh-my-zsh.sh

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias vim="stt"
alias ll="ls -lah"
docker-rmi() {
    docker ps -a | grep $1 | awk '{print $1}' | xargs docker rm
    docker rmi $1
}
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
    git clone $1 .
    [[ -f "build.gradle" ]] && ./gradlew build
    [[ -f "composer.json" ]] && composer install
}

# https://stackoverflow.com/questions/11670935/comments-in-command-line-zsh
setopt interactivecomments

# https://unix.stackexchange.com/questions/114074/tab-completion-of-in-zsh
zstyle ':completion:*' special-dirs true

# formatting and messages
# http://www.masterzen.fr/2009/04/19/in-love-with-zsh-part-one/
zstyle ':completion:*' verbose yes
zstyle ':completion:*' group-name ''

export GOPATH="$HOME/dev/go"
export PATH="/usr/local/opt/php71/bin:$PATH"
export PATH="$GOPATH/bin:$PATH"

#_schip_kubeconfigs=($(find ~/.kube -name kubeconfig -type f) ~/.kube/config)
#KUBECONFIG="$(IFS=':'; echo "${_schip_kubeconfigs[*]}")"
#export KUBECONFIG

[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
if [[ $ZSH_EVAL_CONTEXT == 'file' ]] || [[ $ZSH_EVAL_CONTEXT == 'filecode' ]]; then
    source "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH="/usr/local/opt/python/libexec/bin:$PATH"

# https://github.com/jonmosco/kube-ps1
KUBE_PS1_SUFFIX=') '
source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
PROMPT='$(kube_ps1)'$PROMPT
