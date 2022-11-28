# I think MAMP is adding this
#source ~/.profile

# lowercase
alias lower='for f in *; do mv "$f" "$f.tmp"; mv "$f.tmp" "`echo $f | tr "[:upper:]" "[:lower:]"`"; done'

# Always enable colored `grep` output
export GREP_OPTIONS="--color=auto"

# create .nvmrc
alias cnvm=node -v > .nvmrc
alias mnvm=node -v > .nvmrc

# Bash Layout
export PS1="[\\u@\\h:\\w]\n$"

# MAMP SQL
export PATH=${PATH}:/usr/local/mysql/bin

# Typos
alias gut="git"
alias gti="git"
alias got="git"

# shortcuts
alias fixvm="sudo kextunload -b com.intel.kext.intelhaxm"
alias editbash="subl ~/.bash_profile"
alias editz="subl~/.zshrc"
alias fixbash="source ~/.bash_profile"

# Old habits die hard
alias atom="code"
alias subl="code"

# Copy SSH key
alias copysshkey="pbcopy < ~/.ssh/id_rsa.pub"

# Get to MAMP project directory quickly
#alias web="cd /Applications/MAMP/htdocs"

# Get to project directory quickly
alias web="cd ~/Sites/_GIT"

#edit hosts
alias ehosts="sudo nano /private/etc/hosts"

# npm
alias editbash="subl ~/.bash_profile"
alias npmip="npm install && npm prune"
alias npms="npm start"
alias npmd="npm run dev"
alias npmb="npm run build"

# Too lazy to type docker-compose all the time
alias dkc="docker-compose"
alias dkcup="docker-compose up -d"
alias dkcd="docker-compose down"
alias dkcdown="docker-compose down"
alias dkcb="docker-compose -f docker-compose.yml up -d --build"
alias dkcbuild="docker-compose -f docker-compose.yml up -d --build"
alias dkd="docker-compose down"
alias dkcs="docker stop $(docker ps -a -q)"
alias dkcrm="docker rm $(docker ps -a -q)"
alias dkcsrm="docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)"

# Too lazy to type vagrant
alias vg="vagrant"

# Too lazy to type docker
alias dk="docker"

# Homebrew completion?
if [ -f $(brew --prefix)/etc/bash_completion ]; then
. $(brew --prefix)/etc/bash_completion
fi

# Needed for NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Shim for pyenv
#eval "$(pyenv init -)"

# Nano
export VISUAL=nano
export EDITOR="$VISUAL"

# https://laravel.com/docs/5.4/homestead#daily-usage
function homestead() {
  ( cd ~/Homestead && vagrant $* )
}

# Make laravel executable global
# https://stackoverflow.com/a/25373254
export PATH="$PATH:$HOME/.composer/vendor/bin"

# Java Stuff
export JAVA_HOME=$(/usr/libexec/java_home)
export PATH=${JAVA_HOME}/bin:$PATH
export PATH=/Users/mkeehner/NetBeansProjects/apache-maven-3.5.3/bin:$PATH

# Docker WP-CLI
alias dcwp='docker-compose run --rm cli wp'

# Node Version Check
# https://medium.com/@alberto.schiabel/npm-tricks-part-1-get-list-of-globally-installed-packages-39a240347ef0
npm() {
  if [[ $@ == "whichversion" ]]; then
    command find . -name package.json | xargs grep -h node\": | sort | uniq -c
  elif [[ $@ == 'global' ]]; then
    command npm list -g --depth 0
  else
    command npm "$@"
  fi
}

clean() {
  for branch in $(git branch -r --merged master | grep origin | grep -v develop | grep -v master)
  do
    sleep 2
    git push origin --delete "${branch#*/}"
  done
}

# Hide the “default interactive shell is now zsh” warning on macOS.
export BASH_SILENCE_DEPRECATION_WARNING=1;

[[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh" # load avn

export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"
