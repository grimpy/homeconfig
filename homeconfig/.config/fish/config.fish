alias wd=to
function pjson
    python -m json.tool $argv | pygmentize -l json
end
function cdr
  cd (__bobthefish_git_project_dir )
end
function findbookmark
    set -l bkmrk (ls -1 ~/.tofish | fzf)
    cd ~/.tofish/$bkmrk
end
function fish_user_key_bindings
  bind \e\e 'thefuck-command-line'  # Bind EscEsc to thefuck
  bind \cF '__fzf_find_file'
  bind \cR '__fzf_reverse_isearch'
  bind \cO '__fzf_cd'
  bind \cJ 'findbookmark; fish_prompt'
  bind \cN 'roficlip'
end
function gitpp -w git
    git push -u; and git pull-request $argv
end
function git -w git
    set -l GPG_TTY (tty)
    hub $argv
end

set -U GOPATH ~/code/gopath/
set -U fish_user_paths ~/mygit/scripts/bin ~/bin $GOPATH/bin ~/.local/bin
set -g theme_display_git yes
set -g theme_display_k8s_context no
set -g theme_display_user no
set -g theme_display_hostname no
set -g theme_nerd_fonts no
set -g theme_color_scheme solarized
set -g theme_prompt_pwd_dir_length -1
