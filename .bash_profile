# python poetry

PATH="/Users/chevalmuscle/.local/bin:$PATH"

# lang

LANG="en_US.UTF-8"

# go binaries

export PATH="$PATH:$(go env GOPATH)/bin"

# zsh warning

export BASH_SILENCE_DEPRECATION_WARNING=1

# git autocomplete

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# aliases

## jwt

alias decodejwt="jq -R 'split(\".\") | .[1] | @base64d | fromjson'"

## neovim

alias vim='nvim'

## python

alias pv='pytest -v'
alias pvc='pytest --cov tests/'
alias ss='source venv/bin/activate'

## homebrew

alias bup="brew update --verbose && brew outdated"
alias bug="brew upgrade"

# ccat
alias cat='ccat'

## npm
alias ns='npm run start'
alias nd='npm run start:dev'
alias nr='npm run'

## Replaces generic rm with trash
alias rm='trash'

## general aliases
alias ls='eza --grid'
alias ll='eza -l -h --git'
alias lst='eza --tree'

## git aliases
alias gst='git status'
alias gl='git pull'
alias gp='git push'
alias gc='git commit -m'
alias gca='git commit -v -a'
alias gb='git branch'
alias gba='git branch -a'
alias gco='git checkout'
alias gcob='git checkout -b'
alias glog='git log'
alias glogp='git log --pretty=format:"%h %s" --graph'
alias gs='git stash -u'
alias gsp='git stash pop'
alias ga='git add .'
alias grl='git reset --soft HEAD~'
alias gd='git diff'
alias gds='git diff --staged'
alias gbb="git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"

# autocomplete makefile
complete -W "\`grep -oE '^[a-zA-Z0-9_.-]+:([^=]|$)' ?akefile | sed 's/[^a-zA-Z0-9_.-]*$//'\`" make

# git branch
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

TIMESTAMP=`date "+%H:%M:%S"`

# prompt color
export PS1="\[\033[33m\][\D{%H:%M:%S}]\[\033[m\] \[\033[32m\]\w\[\033[m\]\[\033[36m\]\$(parse_git_branch)\[\033[m\] $ "

# ls colors
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# vscode
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# homebrew
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export PATH="/usr/local/opt/python@3.10/bin:$PATH"

# celery
export PATH="$PATH:/usr/local/sbin"

# direnv
eval "$(direnv hook bash)"

source ~/.personal_bash_profile
