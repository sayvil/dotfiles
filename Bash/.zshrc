# ----------------------------
# General Aliases
# ----------------------------
# Convert filenames to lowercase
alias lower='for f in *; do mv "$f" "$(echo "$f" | tr "[:upper:]" "[:lower:]")"; done'

# Edit and reload .zshrc
alias editz="code ~/.zshrc"
alias fixz="source ~/.zshrc"
alias editzm="code ~/.zshrc.mar-pacsys-wordpress"
alias fixzm="source ~/.zshrc.mar-pacsys-wordpress"

# ----------------------------
# WordPress Aliases and Functions
# ----------------------------
# Navigate to a WordPress theme directory
function theme() {
  cd "web/wp-content/themes/${1:-.}";
}

# WordPress core multisite install
alias wpcorem="docker compose run --rm cli wp core multisite-install --url=brand-sites.marriott.local --title=Marriott --admin_user=skennon@hlkagency.com --admin_email=skennon@hlkagency.com"

# WordPress login
function wplogin() {
  local email=${1:-skennon@hlkagency.com}
  docker compose run --rm cli wp login install --activate --yes && docker compose run --rm cli wp login as "$email"
}

# Predefined WordPress logins
alias wploginr="wplogin rgillespie@hlkagency.com"
alias wplogind="wplogin digital@hlkagency.com"
alias wploginb="wplogin bsherron@hlkagency.com"

alias wpcreateuser="docker compose run --rm cli wp user create skennon@hlkagency.com skennon@hlkagency.com --role=administrator"
alias wpflush="docker compose run --rm cli wp cache flush"
alias delnm="rm -rf node_modules"
# Define a variable for the dotfiles folder
export MYGIT_DIR="/Users/skennon/Documents/_mine/dotfiles"

# Use the variable in the alias
alias mopo="$MYGIT_DIR/scripts/mopo.sh"
alias mopojs="$MYGIT_DIR/scripts/mopo-remote.sh"
alias updatepo="cd $MYGIT_DIR/scripts"
alias editpo="code $MYGIT_DIR/scripts/update-po-files.js"
alias goscripts="cd $MYGIT_DIR/scripts"
alias changelog="python $MYGIT_DIR/scripts/update_changelog.py"

alias lintit="npx stylelint '**/*.scss' --config '$MYGIT_DIR/global-stylelint-config/.stylelintrc.json'"
alias lintfix="npx stylelint '**/*.scss' --config '$MYGIT_DIR/global-stylelint-config/.stylelintrc.json' --fix"
alias lintthis="npx stylelint '*.scss' --config '$MYGIT_DIR/global-stylelint-config/.stylelintrc.json' --config-basedir '$MYGIT_DIR/dotfiles/global-stylelint-config' --fix"

# ----------------------------
# Docker Aliases
# ----------------------------
alias localhttp="docker compose run --rm cli wp search-replace 'https://localhost' 'http://localhost'"
# alias dockerfix="docker update --restart=no $(docker ps -q)"
alias dockerstart="sudo launchctl start com.docker.docker"
alias dockerbash="docker compose run --rm cli bash"
alias dkc="docker compose"
alias dkcup="docker compose up -d"
alias dkcd="docker compose down"
alias dklocal="git branch | grep -v "\*" | xargs -n 1 git branch -d"
alias dkcb="docker compose -f docker compose.yml up -d --build"
alias dkstop="read -p 'Are you sure you want to stop all containers? (y/n) ' confirm && [[ \$confirm == 'y' ]] && docker ps -q | grep . && docker stop \$(docker ps -q) || echo 'No running containers to stop'"
alias gitclean='git checkout develop && git branch -D $(git branch --merged develop | grep -v "\*" | grep -v "develop")'


# alias dkstop="docker ps -q | grep . && docker stop $(docker ps -q) || echo 'No running containers to stop'"


# ----------------------------
# npm Aliases
# ----------------------------
alias npmi="npm ci"
alias npmip3="npm install --python=python3.10"
alias npmib="npm i && npm run build"
alias npms="npm start"
alias npmd="npm run dev"
alias npmb="npm run build"
function npmsd() {
	npm install --save-dev "$@"
}

# ----------------------------
# VS Code Aliases
# ----------------------------
alias gotop='cd "$(git rev-parse --show-toplevel)"'

# Load project-specific commands
if [ -f ".vs_code/.local_commands" ]; then
	source ".vs_code/.local_commands"
fi

# ----------------------------
# Git Aliases
# ----------------------------
alias gitdev="git checkout develop && git pull"
alias gitmain="git checkout main && git pull"

# ----------------------------
# Marriott-Specific
# ----------------------------

alias buildpac="cd pacsys-components && npm run build"
alias startpac="cd pacsys-components && npm run start"

# ----------------------------
# Music Metadata Fixes
# ----------------------------
alias fixmeta='for file in *.m4a; do ffmpeg -i "$file" -metadata purchase_date= -metadata user_name= -metadata owner= -metadata account_id= -c copy "${file%.m4a}-1.m4a"; done'

alias fixdiscm='for file in *.mp3; do ffmpeg -i "$file" \
  -metadata grouping="Disc $(ffprobe -v error -show_entries format_tags=disc -of default=noprint_wrappers=1:nokey=1 "$file") - $(ffprobe -v error -show_entries format_tags=grouping -of default=noprint_wrappers=1:nokey=1 "$file")" \
  -metadata purchase_date= \
  -metadata user_name= \
  -metadata owner= \
  -metadata account_id= \
  -c copy "${file%.mp3}-1.mp3"; done'

alias fixdisc4='for file in *.m4a; do ffmpeg -i "$file" \
  -metadata grouping="Disc $(ffprobe -v error -show_entries format_tags=disc -of default=noprint_wrappers=1:nokey=1 "$file") - $(ffprobe -v error -show_entries format_tags=grouping -of default=noprint_wrappers=1:nokey=1 "$file")" \
  -metadata purchase_date= \
  -metadata user_name= \
  -metadata owner= \
  -metadata account_id= \
  -c copy "${file%.m4a}-1.m4a"; done'

# ----------------------------
# Homebrew Configuration
# ----------------------------
export PATH="/opt/homebrew/bin:$PATH"

# ----------------------------
# Python Configuration
# ----------------------------
alias python="python3"
alias pip="python3 -m pip"

# ----------------------------
# Default Editor
# ----------------------------
export VISUAL="code --wait"
export EDITOR="$VISUAL"

# ----------------------------
# Node.js (NVM)
# ----------------------------
alias setnvm="node -v > .nvmrc && node -v > .node_version"

# Load nvm if it exists
if [ -s "$NVM_DIR/nvm.sh" ]; then
  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  # Auto-use .nvmrc
  if [ -f ".nvmrc" ]; then
    nvm use
  elif [ -f ".node-version" ]; then
    nvm use
  fi
fi

# ----------------------------
# PHP Configuration
# ----------------------------
alias usephp8-2='brew unlink php@7.4 && brew link php@8.2'
alias usephp8='brew unlink php@7.4 && brew link php@8.0'
alias usephp7='brew unlink php@8.0 && brew link php@7.4'

# ----------------------------
# Update PATH
# ----------------------------
export DYLD_LIBRARY_PATH="$(brew --prefix icu4c@74)/lib:$DYLD_LIBRARY_PATH"
export PATH="/usr/local/opt/icu4c@76/bin:/usr/local/opt/icu4c@76/sbin:$PATH"
export PATH="$PATH:/Users/skennon/.local/bin"
export PATH="$PATH:$HOME/.rvm/bin:$HOME/Sites/_GIT/sonarscanner/bin"
export PATH="$HOME/.composer/vendor/bin:$PATH"


# ----------------------------
# Load Project-Specific Aliases
# ----------------------------
if [[ "$PWD" == *"mar-pacsys-wordpress"* ]]; then
    source ~/.zshrc.mar-pacsys-wordpress
fi

# ----------------------------
# Load Project-Specific Aliases for mon-monbranding-cdn
# ----------------------------
if [[ "$PWD" == *"mon-monbranding-cdn"* ]]; then
    alias runlog="python scripts/update_changelog.py"
    alias runall="python scripts/run_all.py"
    alias mkhtml="python scripts/create-html.py"
    alias mkboth="python scripts/convert_from_md.py both"
    alias mkjson="python scripts/convert_from_md.py json"
    alias mkcsv="python scripts/convert_from_md.py csv"
fi
# Load nvm bash_completion if it exists
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Set up PHP environment using phpenv if it exists
export PHPENV_ROOT="/Users/skennon/.phpenv"
if [ -d "${PHPENV_ROOT}" ]; then
	# Add phpenv to PATH
	export PATH="${PHPENV_ROOT}/bin:${PATH}"
	# Initialize phpenv
	eval "$(phpenv init -)"
fi
