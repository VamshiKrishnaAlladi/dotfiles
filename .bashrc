# COLORS
reset=`tput sgr0`

black=`tput setaf 0`
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
magenta=`tput setaf 5`
cyan=`tput setaf 6`
white=`tput setaf 7`

boldblack=`tput setaf 0;tput bold`
boldred=`tput setaf 1;tput bold`
boldgreen=`tput setaf 2;tput bold`
boldyellow=`tput setaf 3;tput bold`
boldblue=`tput setaf 4;tput bold`
boldmagenta=`tput setaf 5;tput bold`
boldcyan=`tput setaf 6;tput bold`
boldwhite=`tput setaf 7;tput bold`

dimblack=`tput setaf 0;tput dim`
dimred=`tput setaf 1;tput dim`
dimgreen=`tput setaf 2;tput dim`
dimyellow=`tput setaf 3;tput dim`
dimblue=`tput setaf 4;tput dim`
dimmagenta=`tput setaf 5;tput dim`
dimcyan=`tput setaf 6;tput dim`
dimwhite=`tput setaf 7;tput dim`

bold=`tput bold`    # Select bold mode
dim=`tput dim`     # Select dim (half-bright) mode
smul=`tput smul`    # Enable underline mode
rmul=`tput rmul`    # Disable underline mode
rev=`tput rev`     # Turn on reverse video mode
smso=`tput smso`    # Enter standout (bold) mode
rmso=`tput rmso`    # Exit standout mode

# CUSTOM FUNCTIONS

function pln {
    printf "\n$@\n"
}

function mkcd {
    pln "${green}✚ […]${reset}  -  ${boldgreen}creating a new directory ${boldmagenta}'$1'${boldgreen}...${reset}\n";
    mkdir $1;
    pln "${green}➜ […]${reset}  -  ${boldgreen}opening the directory created...${reset}\n";
    cd $1;
}

function openFile {
    pln "${green}➜ […]${reset}  -  ${boldgreen}opening ${boldmagenta}'$1'${boldgreen} file...${reset}\n";
    code $1;
}

# --- node_modules: quick actions ---

function nmd {
    pln "${yellow}[ηϻ] ${boldblue}🌐${reset}  -  ${boldgreen}installing default node_modules globally...${reset}\n";
    npm i -g rimraf ts-node ngrok npm-check npmrc http-server commitizen cz-conventional-changelog
}

function nmr {
    pln "${yellow}[ηϻ] ${red}✘${reset}  -  ${boldgreen}deleting node_modules...${reset}\n";
    rimraf "node_modules/";
    pln "${yellow}[ηϻ] ${green}♻${reset}  -  ${boldgreen}installing node_modules afresh...${reset}\n";
    npm i;
}

# ALIASES

# --- aliases: general ---
alias ..='cd ..'
alias ...='cd .. && cd ..'
alias ....='cd .. && cd .. && cd ..'
alias ll='ls -1a --color'
alias q='exit'
alias reload='source ~/.bashrc'

# --- aliases: clear screen ---
alias cls='echo -e "\\0033\\0143"'
alias csl=cls
alias cl=cls
alias clear=cls

# --- aliases: edit ---
alias ebp='openFile ~/.bash_profile'
alias eb='openFile ~/.bashrc'

# --- aliases: npm ---
alias nlg='npm ls -g --depth 0'
alias nls='npm ls --depth 0'
alias ni='npm i'
alias nr='npm run'
alias no='npm outdated > outdated.txt'
alias npw='npm pack && tar -xvzf *.tgz && rm -rf package *.tgz'

# --- aliases: global node_modules usage ---
alias acz='git add -A && npx git-cz'
alias cz='npx git-cz'
alias ping='npx speed-test -v'
alias nc='npx npm-check -u'

# Loading other files
source ~/git-completion.bash
source ~/npm-completion.bash

# Set git status enriched prompt
setPrompt () {
    PS1="$(~/git-prompt.js "$?")"
}

PROMPT_COMMAND=setPrompt

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
