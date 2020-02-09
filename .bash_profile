if [[ "$OSTYPE" == "darwin"* ]]; then
    test -f ~/mac.sh && . ~/mac.sh
elif [[ "$OSTYPE" == "win32" ]]; then
    test -f ~/windows.sh && . ~/windows.sh
fi

test -f ~/.profile && . ~/.profile
test -f ~/.bashrc && . ~/.bashrc
