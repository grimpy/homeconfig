alias wd=to
if which hub > /dev/null; 
    alias git=hub
end
function pjson
    python -m json.tool $argv | pygmentize -l json
end
function cdr
  cd (__bobthefish_git_project_dir )
end
function sshr
    ssh -O exit $argv
    ssh $argv
end
function sshm
    ssh -o ControlPath=none $argv
end
function dssh
    set name $argv[1]
    set dip (docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $name)
    ssh -A -o UserknownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$dip $arv[2..-1]
end
function fish_user_key_bindings
  bind \e\e 'thefuck-command-line'  # Bind EscEsc to thefuck
end

set -g theme_display_git yes
set -g theme_display_k8s_context no
set -g theme_display_user no
set -g theme_display_hostname no
set -g theme_nerd_fonts no
set -g theme_color_scheme solarized
set -g fish_prompt_pwd_dir_length -1
