export I3SOCK=/run/user/1000/i3/ctrl.socket
export GTK_IM_MODULE="xim"
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export GOPATH=$HOME/code/gopath
export PATH=$HOME/mygit/scripts/bin:$HOME/bin:$GOPATH/bin:$PATH:$HOME/.local/bin
eval $(SHELL=/bin/bash keychain -q --eval --agents ssh id_rsa --noask --systemd)
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export QT_GRAPHICSSYSTEM=native
export QT_QPA_PLATFORMTHEME=gtk2
export _JAVA_AWT_WM_NONREPARENTING=1
export EDITOR=kak
unset LC_ALL
export XKB_DEFAULT_OPTIONS=grp:shifts_toggle,caps:super,grp_led:caps
export XKB_DEFAULT_LAYOUT=us,ar
export XKB_DEFAULT_VARIANT=altgr-intl
