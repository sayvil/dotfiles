# lowercase
alias lower='for f in *; do mv "$f" "$(echo "$f" | tr "[:upper:]" "[:lower:]")"; done'

# Always enable colored `grep` output
export GREP_OPTIONS="--color=auto"

# create .nvmrc
# alias cnvm=node -v > .nvmrc
# alias mnvm=node -v > .nvmrc

# Bash Layout
export PS1="[\\u@\\h:\\w]\n$"

# MAMP SQL
export PATH=${PATH}:/usr/local/mysql/bin

alias wplogin="docker-compose run --rm cli wp login install --activate --yes && docker-compose run --rm cli wp login as skennon@hlkagency.com"
# shortcuts
alias editb="code ~/.bash_profile"
alias editbash="code ~/.bash_profile"
alias edith="sudo nano /private/etc/hosts"
alias editz="code ~/.zshrc"
alias fixz="source ~/.zshrc"

# npm
alias npmib="npm i && npm run build"
alias npms="npm start"
alias npmd="npm run dev"
alias npmb="npm run build"

# Too lazy to type docker-compose all the time
alias dkc="docker-compose"
alias dkcup="docker-compose up -d"
alias dkcd="docker-compose down"
alias dkcb="docker-compose -f docker-compose.yml up -d --build"
alias dkcrm="docker rm $(docker ps -a -q)"
alias dkcsrm="docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)"

# added by NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Nano
export VISUAL=nano
export EDITOR="$VISUAL"

[[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh" # load avn
export PATH="/usr/local/opt/php@7.4/bin:$PATH"
export PATH="/usr/local/opt/php@7.4/sbin:$PATH"
export DYLD_LIBRARY_PATH=$(brew --prefix icu4c@74)/lib:$DYLD_LIBRARY_PATH
