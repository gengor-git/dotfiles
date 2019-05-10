#
# Former ~/.bashrc, now base for my profile
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\[$(tput sgr0)\]\[\033[38;5;148m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;133m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\]]:\[$(tput sgr0)\]\[\033[38;5;35m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]\n\\$ \[$(tput sgr0)\]'

# some more ls aliases
alias cd..="cd .."
alias ..="cd .."
alias ...="cd ../.."
alias l='ls -CF'
alias ll='ls -AlsF'
alias la='ls -AFC'
alias grepemail='$ grep -E -o "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b" *'

if [ -e ~/.bashrc.aliases ] ; then
   source ~/.bashrc.aliases
fi
# >>> Added by cnchi installer
BROWSER=/usr/bin/firefox
EDITOR=/usr/bin/nvim

