# Path to your oh-my-zsh installation.
export ZSH=/Users/jose.armesto/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="fiunchinho"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git extract zsh-autosuggestions fzf)

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

######################
# User configuration #
######################
export GOROOT="/usr/local/opt/go/libexec"
export GOPATH="$HOME/dev"
#export GO111MODULE=on
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH="/usr/local/opt/python/libexec/bin:$PATH"
export PATH="/usr/local/opt/php71/bin:$PATH"
#export PATH="/usr/local/go/bin:$PATH"
export PATH="$GOPATH/bin:$PATH"
export ZSH_PLUGINS_ALIAS_TIPS_REVEAL=1
# https://stackoverflow.com/a/42473912/563072
#export GPG_TTY=$(tty)

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

# FZF
# Uncomment the following line to disable fuzzy completion
# export DISABLE_FZF_AUTO_COMPLETION="true"
# Uncomment the following line to disable key bindings (CTRL-T, CTRL-R, ALT-C)
# export DISABLE_FZF_KEY_BINDINGS="true"

# Make Kubernetes use sublime text to edit resources
export KUBE_EDITOR="vim"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#alias idea="open -a IntelliJ\ IDEA $1"
alias idea="open -a '/Users/jose.armesto/Library/Application Support/JetBrains/Toolbox/apps/IDEA-U/ch-0/183.4588.61/IntelliJ IDEA.app' $1"

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

gpfork() {
    git push fiunchinho $(current_branch)
}

helmswitch() {
    HELM_VERSION=${1}
    COMMIT=`curl -Ss -H "Accept: application/vnd.github.cloak-preview" "https://api.github.com/search/commits?q=repo:homebrew/homebrew-core+kubernetes-helm+${HELM_VERSION}" | jq -r '.items[].sha' | head -n 1`

    URL="https://raw.githubusercontent.com/Homebrew/homebrew-core/${COMMIT}/Formula/kubernetes-helm.rb"

    brew unlink kubernetes-helm
    brew install "${URL}"
    brew switch kubernetes-helm ${HELM_VERSION}
    brew link --overwrite kubernetes-helm
    helm version -c
}

alias k="kubectl"
alias cat="bat"
alias kns="kubens"
alias kctx="kubectx"

export HISTFILE=~/.zsh_history  # ensure history file visibility
export HH_CONFIG=hicolor        # get more colors

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/jose.armesto/.sdkman"
[[ -s "/Users/jose.armesto/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/jose.armesto/.sdkman/bin/sdkman-init.sh"
