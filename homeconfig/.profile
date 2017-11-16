export I3SOCK=/run/user/1000/i3/ctrl.socket
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export GOPATH=$HOME/code/gopath
export PATH=$HOME/mygit/scripts/bin:$HOME/bin:$GOPATH/bin:$PATH
eval $(keychain -q --eval --agents ssh id_rsa --noask --systemd)
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export QT_GRAPHICSSYSTEM=native
export QT_QPA_PLATFORMTHEME=gtk2
export _JAVA_AWT_WM_NONREPARENTING=1
export LANG="en_US.utf8"
export LC_TIME="en_GB.utf8"
export EDITOR=nvim
unset LC_ALL
