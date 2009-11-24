
# MacPorts Installer addition on 2009-08-29_at_18:02:48: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

# keychain settings
HOST=`hostname`
KEYCHAIN=`which keychain`
IDENTITY=~/.ssh/id_rsa
SSH_AGENT=~/.keychain/$HOST-sh
$KEYCHAIN $IDENTITY
 . $SSH_AGENT

case $TERM in
    linux) LANG=C ;;
    *) LANG=ja_JP.UTF-8 ;;
esac

if [ $TERM == dumb ];then
    echo $TERM
elif [ $TERM != xterm ];then
    exec `which zsh`
fi
