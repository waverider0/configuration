if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

##

jd()
{
	local directory
	directory=$(find . -type d | fzf --color hl+:red --query "$*")
	if [[ -n "$directory" ]]; then
		cd "$directory"
	fi
}

fe()
{
	local file
	file=$(find . -type f | fzf --color hl+:red --query "$*")
	if [[ -n "$file" ]]; then
		vi "$file"
	fi
}

ge()
{
	local match
	local file
	local line
	if [[ $# -eq 0 ]]; then
		return 1
	fi
	match=$(
		rg --line-number --color=always --hidden --glob '!{.git,node_modules}/**' "$@" . |
		fzf --ansi --color hl+:red
	)
	if [[ -n "$match" ]] then
		file=${match%%:*}
		line=${match#*:}
		line=${line%%:*}
		vi "+${line}" "$file"
	fi
}

export EDITOR=vim
PS1='\u@\h:\[\e[38;2;0;255;119m\]\w\[\e[0m\]$ '
