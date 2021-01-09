#PS1='\[\e[32m\u\] \[\e[36m\w\] \[\e[33m\]\[\e[1m\]$ \[\e[0m\]'
grep='grep --color=always '
GREP_OPTIONS='--color=auto'
GREP_COLOR='0;31'

alias add-alias='vim ~/.bash_profile && source ~/.bash_profile'
alias edit-vimrc='vim ~/.vimrc'
alias python='python3 '
alias ruby-i='irb'
alias pip='python3 -m pip '
alias g='open -e'
alias weather='get_weather'
#rasberrypi
alias ssh-pi='ssh pi@192.168.1.11'
# stuff for Empirasign
alias deskprod-eetest='./manage.py test -v2 --parallel=3 deskprod.eetests.test_client; beep'
alias deskprod-test='./manage.py test -v2 --parallel=3 deskprod/tests; beep'
alias devserver='python manage.py runserver 0.0.0.0:8000'
alias init-venv='python3 -m venv venv3 && source venv3/bin/activate'
alias pylib='cd ~/weshare/wseidule/pylib-dev/pylib'
alias paas='cd ~/weshare/wseidule/paas'
alias ssh-snooki='ssh weshare@135.84.162.74'
alias ssh-keith='pbcopy < ~/creds/keith-pass.txt && ssh ammurphy@10.102.3.237'
alias sshfs-weshare='sshfs weshare@135.84.162.74:/media/hd2/weshare ~/weshare -o allow_other,defer_permissions,noapplexattr,noappledouble'
alias remount-weshare='umount -f weshare@135.84.162.74:/media/hd2/weshare && sshfs-weshare'
alias conn-weshare='sshfs-weshare || remount-weshare'

#random
alias send_imessage='send_imessage'

export PATH="/usr/local/opt/mysql-client/bin:$PATH"
export CLICOLOR=1
set belloff=all

function update_vimrc() { 
    cp ~/.vimrc ~/vimrcs/vim_config/vimrc
    cd ~/vimrcs/vim_config
    git add vimrc
    git commit -m "$1"
    git push
}

function get_weather(){
  curl wttr.in/$1
}

function send_imessage(){
	local VAR1="$1"
	local VAR2="$2"
	osascript -e 'tell application "Messages" to send "'$(printf $VAR2)'" to buddy "'$(printf $VAR1)'"'
}

function kill-port(){
  kill $(lsof -t -i:$1)
}

#######################################################
# command prompt
#######################################################
source /Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh
function be_get_branch {
	local dir="$PWD"
  	local nick
	local vcs
	for vcs in git hg; do
		if [[ -d "$dir/.$vcs" ]] && hash "$vcs" &>/dev/null; then
		case "$vcs" in
			git) __git_ps1 "|${1:-%s}"; return;;
			hg) nick=$(hg branch 2>/dev/null);;
		esac
		[[ -n "$nick" ]] && printf "|${1:-%s}""$nick"
		return 0
		fi
	done
	dir="$(dirname "$dir")"
}


function __setprompt
{
	local LAST_COMMAND=$? # Must come first!

	# Define colors
	local LIGHTGRAY="\033[0;37m"
	local WHITE="\033[1;37m"
	local BLACK="\033[0;30m"
	local DARKGRAY="\033[1;30m"
	local RED="\033[01;31m"
	local LIGHTRED="\033[1;31m"
	local GREEN="\033[01;32m"
	local LIGHTGREEN="\033[1;32m"
	local BROWN="\033[0;33m"
	local YELLOW="\033[1;33m"
	local BLUE="\033[01;34m"
	local LIGHTBLUE="\033[01;34m"
	local MAGENTA="\033[0;35m"
	local LIGHTMAGENTA="\033[1;35m"
	local CYAN="\033[0;36m"
	local LIGHTCYAN="\033[1;36m"
	local NOCOLOR="\033[0m"

	# Show error exit code if there is one
	if [[ $LAST_COMMAND != 0 ]]; then
		# PS1="\[${RED}\](\[${LIGHTRED}\]ERROR\[${RED}\])-(\[${LIGHTRED}\]Exit Code \[${WHITE}\]${LAST_COMMAND}\[${RED}\])-(\[${LIGHTRED}\]"
		PS1="\[${CYAN}\](\[${LIGHTRED}\]ERROR\[${CYAN}\])-(\[${RED}\]Exit Code \[${LIGHTRED}\]${LAST_COMMAND}\[${CYAN}\])-(\[${RED}\]"
		if [[ $LAST_COMMAND == 1 ]]; then
			PS1+="General error"
		elif [ $LAST_COMMAND == 2 ]; then
			PS1+="Missing keyword, command, or permission problem"
		elif [ $LAST_COMMAND == 126 ]; then
			PS1+="Permission problem or command is not an executable"
		elif [ $LAST_COMMAND == 127 ]; then
			PS1+="Command not found"
		elif [ $LAST_COMMAND == 128 ]; then
			PS1+="Invalid argument to exit"
		elif [ $LAST_COMMAND == 129 ]; then
			PS1+="Fatal error signal 1"
		elif [ $LAST_COMMAND == 130 ]; then
			PS1+="Script terminated by Control-C"
		elif [ $LAST_COMMAND == 131 ]; then
			PS1+="Fatal error signal 3"
		elif [ $LAST_COMMAND == 132 ]; then
			PS1+="Fatal error signal 4"
		elif [ $LAST_COMMAND == 133 ]; then
			PS1+="Fatal error signal 5"
		elif [ $LAST_COMMAND == 134 ]; then
			PS1+="Fatal error signal 6"
		elif [ $LAST_COMMAND == 135 ]; then
			PS1+="Fatal error signal 7"
		elif [ $LAST_COMMAND == 136 ]; then
			PS1+="Fatal error signal 8"
		elif [ $LAST_COMMAND == 137 ]; then
			PS1+="Fatal error signal 9"
		elif [ $LAST_COMMAND -gt 255 ]; then
			PS1+="Exit status out of range"
		else
			PS1+="Unknown error code"
		fi
		PS1+="\[${CYAN}\])\[${NOCOLOR}\]\n"
	else
		PS1=""
	fi

	# Date
	#PS1+="\[${YELLOW}\]\[${CYAN}\]\$(date | head -c 10)" # Date
	PS1+="${CYAN}$(date +'%-I':%M:%S%P)\[${YELLOW}\] -" # Time

	# User and server
	# PS1+="(\[${RED}\]\u"
	PS1+=" \[${RED}\]\u"

	# Current directory with git or hg branch
	local branch="\$(be_get_branch "$2")"
	PS1+="\[${YELLOW}\]:\[${BLUE}\]\w\[${YELLOW}\]${branch} -"

	# Number of files
	PS1+=" \[${GREEN}\]files:\$(/bin/ls -A -1 | /usr/bin/wc -l | tail -c 4)\[${YELLOW}\]"

	# Skip to the next line
	PS1+="\n"

	if [[ $EUID -ne 0 ]]; then
		PS1+="\[${GREEN}\]$>\[${NOCOLOR}\] " # Normal user
	else
		PS1+="\[${RED}\]$>\[${NOCOLOR}\] " # Root user
	fi

	# PS2 is used to continue a command using the \ character
	PS2="\[${YELLOW}\]>\[${NOCOLOR}\] "

	# PS3 is used to enter a number choice in a script
	PS3='Please enter a number from above list: '

	# PS4 is used for tracing a script in debug mode
	PS4='\[${DARKGRAY}\]+\[${NOCOLOR}\] '
}
PROMPT_COMMAND='__setprompt'
