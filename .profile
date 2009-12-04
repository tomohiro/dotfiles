export OS=`uname`

# Path settings
if [ $OS = Darwin ]; then
    # MacPorts Installer addition on 2009-08-29_at_18:02:48: adding an appropriate PATH variable for use with MacPorts.
    PATH=$HOME/bin:/opt/local/bin:/opt/local/sbin:$PATH
    # Finished adapting your PATH environment variable for use with MacPorts.
else
    PATH=$HOME/bin:/usr/sbin:/sbin:$PATH
fi

# keychain setting
KEYCHAIN=`which keychain`
if [ $? = 0 ]; then
    HOST=`hostname`
    IDENTITY=~/.ssh/id_rsa
    SSH_AGENT=~/.keychain/$HOST-sh
    $KEYCHAIN $IDENTITY
    . $SSH_AGENT
fi

# network setting
if [ -f ~/.network ]; then
    . ~/.network
fi

# Language Setting
case $TERM in
    linux) LANG=C ;;
    *) LANG=ja_JP.UTF-8 ;;
esac

# replace bash to zsh
ZSH=`which zsh`
if [ $? = 0 ]; then
    case $TERM in
        xterm) exec $ZSH ;;
    esac
fi
