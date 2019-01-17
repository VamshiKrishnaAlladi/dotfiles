GIT_PROMPT_ONLY_IN_REPO=1

# GIT_PROMPT_FETCH_REMOTE_STATUS=0   # uncomment to avoid fetching remote status

# GIT_PROMPT_SHOW_UPSTREAM=1 # uncomment to show upstream tracking branch
GIT_PROMPT_SHOW_UNTRACKED_FILES=all # can be no, normal or all; determines counting of untracked files

# GIT_PROMPT_START='\n\n ${GIT_PROMPT_START_ROOT}'  # uncomment for custom prompt start sequence

# GIT_PROMPT_THEME=Custom # use custom theme specified in file GIT_PROMPT_THEME_FILE (default ~/.git-prompt-colors.sh)
# GIT_PROMPT_THEME_FILE=~/.git-prompt-colors.sh

GIT_PROMPT_THEME=VKA

# ALIASES

# --- alaises: general ---
alias ..='cd ..'
alias ...='cd .. && cd ..'
alias ....='cd .. && cd .. && cd ..'
alias ll='ls -1a --color'
function pln {
    printf "\n$@\n"
}

# --- aliases: clear screen ---
alias cls='echo -e "\\0033\\0143"'
alias csl=cls
alias cl=cls
alias clear=cls

# --- alaises: edit ---
alias ebp='\
pln "📝  opening ~/.bash_profile file...\n" && \
code ~/.bash_profile'

alias eb='\
pln "📝  opening ~/.bashrc file...\n" && \
code ~/.bashrc'

# --- alaises: node_modules ---
alias nmr='\
pln "📦  💥  - nuking node_modules...\n" && \
rimraf node_modules/ && \
pln "📦  🔄  - installing node_modules afresh...\n"&& \
npm i'

alias nmd='\
pln "📦  🌎 - installing global default node_modules...\n" && \
npm i -g rimraf ts-node ngrok npm-check http-server commitizen cz-conventional-changelog'

# --- aliases: npm ---
alias nlg='npm ls -g --depth 0'
alias nls='npm ls --depth 0'
alias ni='npm i'
alias nr='npm run'
alias no='npm outdated > outdated.txt'

# --- alaises: global node_modules usage ---
alias cz='npx git-cz'
alias ping='npx speed-test -v'
alias nc='npx npm-check -u'

# --- aliases: open explorer ---
alias vka='start /d/GitHub/vka'
alias pf='start /c/progra~1'
alias pf86='start /c/progra~2'


# Loading other files
source ~/.bash-git-prompt/gitprompt.sh
source ~/git-flow-completion.bash
source ~/npm-completion.bash
