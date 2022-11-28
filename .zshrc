# shortcuts
alias fixvm="sudo kextunload -b com.intel.kext.intelhaxm"
alias editbash="atom ~/.bash_profile"
alias editb="atom ~/.bash_profile"
alias editzsh="atom ~/.zshrc"
alias editz="atom ~/.zshrc"
alias fixbash="source ~/.bash_profile"
alias sim="open -a Simulator"
alias frun="open -a Sumulator && flutter run"

# create .nvmrc
alias cnvm=node -v > .nvmrc
alias mnvm=node -v > .nvmrc

# Copy SSH key
alias copysshkey="pbcopy < ~/.ssh/id_rsa.pub"

# npm
alias editbash="atom ~/.bash_profile"
alias npmi="npm install"
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
alias dcwp='docker-compose run --rm cli wp'

# added by NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$PATH:$HOME/Sites/_GIT/sonarscanner/bin"
export PATH="$PATH:$HOME/Sites/_WIP/flutter/bin"

# Nano
export VISUAL=nano
export EDITOR="$VISUAL"
[[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh" # load avn
export PATH="/usr/local/opt/php@7.4/bin:$PATH"
export PATH="/usr/local/opt/php@7.4/sbin:$PATH"
