# CREDITS
# =======
# Some of this file is mine <slarti@gentoo.org /
# tom@edgeoftheinterweb.org.uk>, some is take from spider's
# <spider@gentoo.org> zshrc, and some from guckes's <?> zshrc. Some bash
# functions are nicked from ciaranm's <ciaranm@gentoo.org> bashrc. Some
# stuff is totally random. It is definately NOT Pwnz3r's
# <http://pstudios.ath.cx/linux-tips/zsh.php?tips=1>. It pisses me off
# quite a bit when people take things as-is or open and don't give
# credit. Even if the work in question is not liscensed as such, it just
# comes down to manners.

# NEWS
# ====
# * 20050113 : re-indented the whole thing with crazy vim magic
# * 20050113 : moved me-specific variables and code to the top of the file

# README
# ======
# * Remember to change the stuff specific to me! It's all at the top of
#   this file.
# * You can obviously only get the most out of this file if you take the
#   time to read through the comments. Of course, you can still see
#   zsh's superiority by simply plugging this file in and using it.

# LOCAL
# =====
# Man pages look a lot better in vim - change the path if you use a
# different version of vim!.

fpath=(~/.zsh/functions $fpath)
autoload -U zkbd
# Follow GNU LS_COLORS for completion menus
zmodload -i zsh/complist
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:*:kill:*' list-colors '=%*=01;31'

# Load the completion system
autoload -U compinit; compinit

# Very powerful version of mv implemented in zsh. The main feature I
# know of it that seperates it from the standard mv is that it saves you
# time by being able to use patterns for both source and dest. So:
#
# slarti@pohl % zmv *foo *bar
#
# On a series of files like onefoo, twofoo, threefoo, fivefoo would be
# renamed to onebar twobar threebar fourbar.
#
# Although that's nifty enough, I suspect there are other features I
# don't know about yet...
#
# Read $fpath/zmv for some more basic examples of usage.
autoload -U zmv

# Command line calculator written in zsh, with a complete history
# mechanism and other shell features.
autoload -U zcalc

# Like xargs, but instead of reading lines of arguments from standard input,
# it takes them from the command line. This is possible/useful because,
# especially with recursive glob operators, zsh often can construct a command
# line for a shell function that is longer than can be accepted by an external
# command. This is what's often referred to as the "shitty Linux exec limit" ;)
# The limitation is on the number of characters or arguments.
#
# slarti@pohl % echo {1..30000}
# zsh: argument list too long: /bin/echo
# zsh: exit 127   /bin/echo {1..30000}
autoload -U zargs

# Yes, we are as bloated as emacs
autoload -U tetris
zle -N tetris
bindkey "^Xt" tetris

# zed is a tiny command-line editor in pure ZSH; no other shell could do
# this.  zed itself is simple as anything, but it's killer feature for
# me is that it can edit functions on the go with zed -f <funcname> (or
# fned <funcname>. This is useful for me when I'm using and defining
# functions interactively, for example, when I'm working through the
# Portage tree in CVS. It allows me to edit a function on the fly,
# without having to call the last definition back up from the history
# and re-edit that in ZLE. It also indents the function, even if it was
# defined on all one line in the line editor, making it easy as anything
# to edit.
#
# ^X^W to save, ^C to abort.
autoload -U zed

# Incremental completion of a word. After starting this, a list of
# completion choices can be shown after every character you type, which
# can deleted with ^H or delete. Return will accept the current
# completion. Hit tab for normal completion, ^G to get back where you
# came from and ^D to list matches.
autoload -U incremental-complete-word
zle -N incremental-complete-word
bindkey "^Xi" incremental-complete-word

# This function allows you type a file pattern, and see the results of
# the expansion at each step.  When you hit return, they will be
# inserted into the command line.
autoload -U insert-files
zle -N insert-files
bindkey "^Xf" insert-files

# This set of functions implements a sort of magic history searching.
# After predict-on, typing characters causes the editor to look backward
# in the history for the first line beginning with what you have typed so
# far.  After predict-off, editing returns to normal for the line found.
# In fact, you often don't even need to use predict-off, because if the
# line doesn't match something in the history, adding a key performs
# standard completion - though editing in the middle is liable to delete
# the rest of the line.
autoload -U predict-on
zle -N predict-on
zle -N predict-off
bindkey "^X^Z" predict-on
bindkey "^Z" predict-off

# run-help is a help finder, bound in ZLE to M-h.  It doesn't need to be
# autoloaded to work - the non-autoloaded version just looks up a man
# page for the command under the cursor, then when that process is
# finished it pulls your old command line back up from the buffer stack.
# However, with the autoloaded function and:
#
# mkdir ~/zsh-help; cd ~/zsh-help MANPAGER="less" man zshbuiltins |
# colcrt \ | perl /usr/share/zsh/4.2.1/Util/helpfiles
#
# It'll work for zsh builtins too. By the way, I've assumed some things
# in that command. ~/zsh-help can be wherever you like, MANPAGER needs
# to be any standard pager (less, pg, more, just not the MANPAGER I have
# defined in this file), colcrt can be col -bx, and the path to
# helpfiles may be different for you (Util may not even be installed
# with your distribution; fair enough, make install doesn't install it.
# Dig up a source tarball and everything's in there).

# Define our helpdir unalias run-help
HELPDIR=~/zsh-help
# We need to get rid of the old run-help (NOTE: if you source ~/.zshrc
# this will through up a warning about the alias not existing for
# unaliasing. The solution is to form an if construct, with the
# condition that run-help is aliased. I do not know how to do this.
unalias run-help
# Load the new one
autoload -U run-help

# Colours
autoload -U colors; colors

# For those who want the default Gentoo prompt back:
#autoload -U promptinit
#promptinit; prompt gentoo

# Prompt - Fairly similar to the default Gentoo prompt, but a little bit more
# compact, whilst being just as helpful. Makes full use of RPROMPT.

PROMPT="%{[01;32m%}%n@%m %{[01;36m%}%#%{[00m%} "
RPROMPT="%{[01;33m%}%~%{[00;49m%}"

# Exports
export HOSTTYPE="$(uname -m)"
export COLORTERM=yes
export LINKS_XTERM=screen

# SCREENDIR will mess screen up
unset SCREENDIR

# Colours
# --
# I haven't actually used these yet, apart from for reference. You can use
# these when prompting. Capitalised stuff is bold.
export red=$'%{[0;31m%}'
export RED=$'%{[1;31m%}'
export green=$'%{[0;32m%}'
export GREEN=$'%{[1;32m%}'
export blue=$'%{[0;34m%}'
export BLUE=$'%{[1;34m%}'
export purple=$'%{[0;35m%}'
export PURPLE=$'%{[1;35m}'
export cyan=$'%{[0;36m%}'
export CYAN=$'%{[1;36m}'
export WHITE=$'%{[1;37m}'
export white=$'%{[0;37m}'
export NC=$'%{[0m%}'

# Make sure no cores can be dumped
limit coredumpsize 0

# Completion options -- I should convert these to the new, more
# versatile compsys.
compctl -b bindkey
compctl -v export
compctl -o setopt
compctl -v unset
compctl -o unsetopt
compctl -v vared
compctl -c which
compctl -c sudo

# _gnu_generic is a completion widget that parses the --help output of
# commands for options. df and feh work fine with it, however options
# are not described.
compdef _gnu_generic feh df

compdef _pkglist ecd
compdef _useflaglist explainuseflag
compdef _category list_cat

compdef _nothing etc-update dispatch-conf fixpackages

vik(){
   sed -i $1d ~/.ssh/known_hosts
}

ssh2(){
    cat ~/.ssh/id_rsa.pub | ssh $1 'umask 077; test -d .ssh || mkdir .ssh; cat > /tmp/mykey && grep "`cat /tmp/mykey`" ~/.ssh/authorized_keys &> /dev/null || cat /tmp/mykey >> ~/.ssh/authorized_keys' || exit 1
    ssh $1
}

xbox(){
    lftp -u xbox,xbox 1.1.3/F/
}

# History things
HISTFILE=$HOME/.zshist
SAVEHIST=10000
HISTSIZE=16000
TMPPREFIX=$HOME/tmp
HIST_SAVE_NO_DUPS=True

# Key bindings.. looking healthier now.

# You can use:
# % autoload -U zkbd
# % zkbd
# to discover your keys.

# Google for emacs keybindings. Even if you don't use emacs, most programs
# with some kind of line editor will use them... emacs keybindings are
# essential knowledge ;) Although I'm a hardcore vim user, I don't
# really like vi-style keybindings for command line editing. Also,
# many/most text-only programs use emacsish keybindings for line
# editing.
bindkey -e

# Up, down left, right.
# echotc is part of the zsh/termcap module. It outputs the termcap value
# corresponding to the capability it was given as an argument. man zshmodules.
zmodload -i zsh/termcap
bindkey "$(echotc kl)" backward-char
bindkey "$(echotc kr)" forward-char

bindkey '\e[3~' delete-char # Delete

if [[ "$TERM" == "rxvt" ]]; then
    bindkey '\e[7~' beginning-of-line # Home
    bindkey '\e[8~' end-of-line # End
elif [[ "$TERM" == "linux" ]]; then
    bindkey '\e[1~' beginning-of-line #Home
    bindkey '\e[4~' end-of-line #End
else # At least xterm; probably other terms too
    bindkey '\eOH' beginning-of-line # Home
    bindkey '\eOF' end-of-line # End
fi

#bindkey '\e[A' history-search-backward # PageUp
bindkey '\e[A'  history-beginning-search-backward # PageUp
bindkey '\e[B' history-beginning-search-forward #down-history # PageDown

# Aliases
alias ls="ls --color=always"

# This function sets the window tile to user@host:/workingdir before each
# prompt. If you're using screen, it sets the window title (works
# wonderfully for hardstatus lines :)
precmd () {
    # From plasmaroo.. not quite working the way I want though.
    #[ $? -eq 0 ] && export RPS1='' && export RPS1='' || export RPS1="$(print \
    #'%{\e[1;33m%}'$?'%{\e[0m%}')"
    [[ -t 1 ]] || return
    case $TERM in
	*xterm*|*rxvt*|(dt|k|E|a)term) print -Pn "]2;%n@%m:%~\a"
	;;
	screen*) print -Pn "\"%n@%m:%~\134"
	# Screen's being annoying with unicode or I'm being dumb.
	alias centericq="TERM=rxvt centericq"
	;;
    esac
}

# This sets the window title to the last run command.
[[ -t 1 ]] || return
case $TERM in
  *xterm*|*rxvt*|(dt|k|E|a)term)
    preexec () {
      print -Pn "]2;$1\a"
    }
  ;;
  screen*)
    preexec () {
      print -Pn "\"$1\134"
    }
  ;;
esac


# Pretty menu!
zstyle ':completion:*' menu select=1

# Completion options
zstyle ':completion:*' completer _complete _prefix
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:predict:*' completer _complete

# Completion caching
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST

# Expand partial paths
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'

# Include non-hidden directories in globbed file completions
# for certain commands
zstyle ':completion::complete:*' '\\'

# Use menuselection for pid completion
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

#  tag-order 'globbed-files directories' all-files
zstyle ':completion::complete:*:tar:directories' file-patterns '*~.*(-/)'

# Don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

# Separate matches into groups
zstyle ':completion:*:matches' group 'yes'

# With commands like rm, it's annoying if you keep getting offered the same
# file multiple times. This fixes it. Also good for cp, et cetera..
zstyle ':completion:*:rm:*' ignore-line yes
zstyle ':completion:*:cp:*' ignore-line yes

# Describe each match group.
zstyle ':completion:*:descriptions' format "%B---- %d%b"

# Messages/warnings format
zstyle ':completion:*:messages' format '%B%U---- %d%u%b'
zstyle ':completion:*:warnings' format '%B%U---- no match for: %d%u%b'

# Describe options in full
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'

# Simulate spider's old abbrev-expand 3.0.5 patch
zstyle ':completion:*:history-words' stop verbose
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false

export PATH=$PATH:$HOME/mygit/scripts/bin
export EDITOR=/usr/bin/vim

# Options
setopt				\
     NO_all_export		\
        always_last_prompt	\
        always_to_end		\
        append_history		\
        auto_cd			\
        auto_list		\
        auto_menu		\
        auto_name_dirs		\
        auto_param_keys		\
        auto_param_slash	\
        auto_pushd		\
        auto_remove_slash	\
     NO_auto_resume		\
        bad_pattern		\
        bang_hist		\
     NO_beep			\
        brace_ccl		\
        correct_all		\
     NO_bsd_echo		\
        cdable_vars		\
     NO_chase_links		\
        clobber			\
        complete_aliases	\
        complete_in_word	\
        correct			\
     NO_correct_all		\
        csh_junkie_history	\
     NO_csh_junkie_loops	\
     NO_csh_junkie_quotes	\
     NO_csh_null_glob		\
        equals			\
        extended_glob		\
        extended_history	\
        function_argzero	\
        glob			\
     NO_glob_assign		\
        glob_complete		\
     NO_glob_dots		\
     NO_glob_subst		\
     NO_hash_cmds		\
     NO_hash_dirs		\
        hash_list_all		\
        hist_allow_clobber	\
        hist_beep		\
        hist_ignore_dups	\
        hist_ignore_space	\
     NO_hist_no_store		\
        hist_verify		\
     NO_hup			\
     NO_ignore_braces		\
     NO_ignore_eof		\
        interactive_comments	\
        inc_append_history	\
     NO_list_ambiguous		\
     NO_list_beep		\
        list_types		\
        long_list_jobs		\
        magic_equal_subst	\
     NO_mail_warning		\
     NO_mark_dirs		\
        menu_complete		\
        multios			\
        nomatch			\
        notify			\
     NO_null_glob		\
        numeric_glob_sort	\
     NO_overstrike		\
        path_dirs		\
        posix_builtins		\
     NO_print_exit_value 	\
     NO_prompt_cr		\
        prompt_subst		\
        pushd_ignore_dups	\
     NO_pushd_minus		\
        pushd_silent		\
        pushd_to_home		\
        rc_expand_param		\
     NO_rc_quotes		\
     NO_rm_star_silent		\
     NO_sh_file_expansion	\
        sh_option_letters	\
        short_loops		\
        sh_word_split		\
     NO_single_line_zle		\
     NO_sun_keyboard_hack	\
     NO_verbose			\
	zle
#autoload -U  ~/.zsh/functions/*(:t)
# Last but not least...
