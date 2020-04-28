# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

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
plugins=(git autojump extract zsh-autosuggestions fzf)

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

######################
# User configuration #
######################
export GOPATH="$HOME/dev"
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH="/usr/local/opt/python/libexec/bin:$PATH"
export PATH="/usr/local/opt/php71/bin:$PATH"
export PATH=$PATH:/usr/local/go/bin
export PATH="$GOPATH/bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export ZSH_PLUGINS_ALIAS_TIPS_REVEAL=1

source $ZSH/oh-my-zsh.sh
#source "${HOME}/.iterm2_shell_integration.zsh"

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

helmswitch () {
	HELM_FILES="/opt/helm"
	HELM_BIN="/usr/local/bin/helm"
	echo "Choose one of the following installed helm version:"
	select HELM_VERSION in $(curl -Ss -H "Accept: application/vnd.github.cloak-preview" "https://api.github.com/repos/helm/helm/releases" | jq -r 'sort_by(.tag_name) | .[] | select( .prerelease == false).tag_name')
	do
	if [[ ! -f "${HELM_FILES}/${HELM_VERSION}" ]]
		then
			curl "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" --output "/tmp/helm-${HELM_VERSION}-linux-amd64.tar.gz"
			tar -xzvf "/tmp/helm-${HELM_VERSION}-linux-amd64.tar.gz" -C /tmp/
			sudo mv /tmp/linux-amd64/helm "${HELM_FILES}/${HELM_VERSION}"
			rm -r /tmp/linux-amd64
		fi
		echo "Helm Version ${HELM_VERSION} will be set in ${HELM_BIN}"
		sudo ln -fs "${HELM_FILES}/${HELM_VERSION}" "${HELM_BIN}"
		break
	done
}

alias k="kubectl"
alias ccat="/usr/bin/cat"
alias kns="k ns"
alias kctx="k ctx"

# kubens and kubectx completions don't work without this
autoload -U compinit && compinit

export HISTFILE=~/.zsh_history  # ensure history file visibility
export HH_CONFIG=hicolor        # get more colors

#source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# https://github.com/zsh-users/zsh-syntax-highlighting/issues/171#issuecomment-140335051
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[cursor]=underline
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
source ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="${HOME}/.sdkman"
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
