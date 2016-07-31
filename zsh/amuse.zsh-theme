# vim:ft=zsh ts=2 sw=2 sts=2
function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

PROMPT='%{%F{157}%B%}%n:%{$fg_bold[blue]%}%~%{$reset_color%}%  » '

#ZSH_THEME_GIT_PROMPT_PREFIX=" %{$terminfo[bold]%F{217}%}"
ZSH_THEME_GIT_PROMPT_PREFIX="%{%F{217}%B%}<"
ZSH_THEME_GIT_PROMPT_SUFFIX=">%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_UNTRACKED=""
ZSH_THEME_GIT_PROMPT_CLEAN=""
#ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!"
#ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
#ZSH_THEME_GIT_PROMPT_CLEAN=""
GIT_PROMPT_MERGING="%{$fg_bold[magenta]%}⚡︎%{$reset_color%}"

RPROMPT='$(git_prompt_info) ⌚ %{$fg_bold[yellow]%}%*%{$reset_color%}'
#RPROMPT=''
