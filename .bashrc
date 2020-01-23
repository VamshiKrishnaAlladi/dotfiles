GIT_PROMPT_ONLY_IN_REPO=1
GIT_PROMPT_SHOW_UNTRACKED_FILES=all # can be no, normal or all; determines counting of untracked files
GIT_PROMPT_THEME=VKA

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

# ALIASES

# --- alaises: general ---
alias ..='cd ..'
alias ...='cd .. && cd ..'
alias ....='cd .. && cd .. && cd ..'
alias ll='ls -1a --color'
alias q='exit'
alias reload='source ~/.bashrc'

function pln {
    printf "\n$@\n"
}

function mkcd {
    pln "${green}✚ […]${reset}  -  ${boldgreen}creating a new directory ${boldmagenta}\"$1\"${boldgreen}...${reset}\n";
    mkdir $1;
    pln "${green}➜ […]${reset}  -  ${boldgreen}opening the directory created...${reset}\n";
    cd $1;
}

# --- aliases: clear screen ---
alias cls='echo -e "\\0033\\0143"'
alias csl=cls
alias cl=cls
alias clear=cls

# --- alaises: edit ---
alias ebp='\
pln "${green}➜ […]${reset}  -  ${boldgreen}opening ${boldmagenta}\"~/.bash_profile\"${boldgreen} file...${reset}\n" && \
code ~/.bash_profile'

alias eb='\
pln "${green}➜ […]${reset}  -  ${boldgreen}opening ${boldmagenta}\"~/.bashrc\"${boldgreen} file...${reset}\n" && \
code ~/.bashrc'

# --- alaises: node_modules ---
alias nmr='\
pln "${yellow}[ηϻ] ${red}✘${reset}  -  ${boldgreen}deleting node_modules...${reset}\n" && \
rimraf node_modules/ && \
pln "${yellow}[ηϻ] ${green}♻${reset}  -  ${boldgreen}installing node_modules afresh...${reset}\n" && \
npm i'

alias nmd='\
pln "${yellow}[ηϻ] ${boldblue}☁${reset}  -  ${boldgreen}installing default node_modules globally...${reset}\n" && \
npm i -g rimraf ts-node ngrok npm-check npmrc http-server commitizen cz-conventional-changelog'

# --- aliases: npm ---
alias nlg='npm ls -g --depth 0'
alias nls='npm ls --depth 0'
alias ni='npm i'
alias nr='npm run'
alias no='npm outdated > outdated.txt'
alias npw='npm pack && tar -xvzf *.tgz && rm -rf package *.tgz'

# --- alaises: global node_modules usage ---
alias acz='git add -A && npx git-cz'
alias cz='npx git-cz'
alias ping='npx speed-test -v'
alias nc='npx npm-check -u'

# --- aliases: open explorer ---
alias vka='start /d/GitHub/vka'
alias pf='start /c/progra~1'
alias pf86='start /c/progra~2'


# Loading other files
source ~/npm-completion.bash

src="${BASH_SOURCE[0]}"

# resolve $src until the file is no longer a symlink
while [ -h "$src" ]; do
    dir="$( cd -P "$( dirname "$src" )" >/dev/null 2>&1 && pwd )"
    src="$(readlink "$src")"
    [[ $src != /* ]] && src="$dir/$src"
    # if $src was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done

dotfiles_dir="$( cd -P "$( dirname "$src" )" >/dev/null 2>&1 && pwd )"

setPrompt () {
    PS1="$($dotfiles_dir/git-prompt.js "$?")"
}

PROMPT_COMMAND=setPrompt
