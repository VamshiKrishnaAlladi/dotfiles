export NVM_DIR="/Users/vka/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

export BASH_SILENCE_DEPRECATION_WARNING=1

test -f ~/.profile && . ~/.profile
test -f ~/.bashrc && . ~/.bashrc
