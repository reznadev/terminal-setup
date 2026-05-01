# Snapshot file
# Unset all aliases to avoid conflicts with functions
unalias -a 2>/dev/null || true
# Functions
__arguments () {
	# undefined
	builtin autoload -XUz
}
__zoxide_cd () {
	\builtin cd -- "$@"
}
__zoxide_doctor () {
	[[ ${_ZO_DOCTOR:-1} -ne 0 ]] || return 0
	[[ ${chpwd_functions[(Ie)__zoxide_hook]:-} -eq 0 ]] || return 0
	_ZO_DOCTOR=0 
	\builtin printf '%s\n' 'zoxide: detected a possible configuration issue.' 'Please ensure that zoxide is initialized right at the end of your shell configuration file (usually ~/.zshrc).' '' 'If the issue persists, consider filing an issue at:' 'https://github.com/ajeetdsouza/zoxide/issues' '' 'Disable this message by setting _ZO_DOCTOR=0.' '' >&2
}
__zoxide_hook () {
	\command zoxide add -- "$(__zoxide_pwd)"
}
__zoxide_pwd () {
	\builtin pwd -L
}
__zoxide_z () {
	__zoxide_doctor
	if [[ "$#" -eq 0 ]]
	then
		__zoxide_cd ~
	elif [[ "$#" -eq 1 ]] && {
			[[ -d "$1" ]] || [[ "$1" = '-' ]] || [[ "$1" =~ ^[-+][0-9]+$ ]]
		}
	then
		__zoxide_cd "$1"
	elif [[ "$#" -eq 2 ]] && [[ "$1" = "--" ]]
	then
		__zoxide_cd "$2"
	else
		\builtin local result
		result="$(\command zoxide query --exclude "$(__zoxide_pwd)" -- "$@")"  && __zoxide_cd "${result}"
	fi
}
__zoxide_zi () {
	__zoxide_doctor
	\builtin local result
	result="$(\command zoxide query --interactive -- "$@")"  && __zoxide_cd "${result}"
}
add-zle-hook-widget () {
	# undefined
	builtin autoload -XU
}
add-zsh-hook () {
	emulate -L zsh
	local -a hooktypes
	hooktypes=(chpwd precmd preexec periodic zshaddhistory zshexit zsh_directory_name) 
	local usage="Usage: add-zsh-hook hook function\nValid hooks are:\n  $hooktypes" 
	local opt
	local -a autoopts
	integer del list help
	while getopts "dDhLUzk" opt
	do
		case $opt in
			(d) del=1  ;;
			(D) del=2  ;;
			(h) help=1  ;;
			(L) list=1  ;;
			([Uzk]) autoopts+=(-$opt)  ;;
			(*) return 1 ;;
		esac
	done
	shift $(( OPTIND - 1 ))
	if (( list ))
	then
		typeset -mp "(${1:-${(@j:|:)hooktypes}})_functions"
		return $?
	elif (( help || $# != 2 || ${hooktypes[(I)$1]} == 0 ))
	then
		print -u$(( 2 - help )) $usage
		return $(( 1 - help ))
	fi
	local hook="${1}_functions" 
	local fn="$2" 
	if (( del ))
	then
		if (( ${(P)+hook} ))
		then
			if (( del == 2 ))
			then
				set -A $hook ${(P)hook:#${~fn}}
			else
				set -A $hook ${(P)hook:#$fn}
			fi
			if (( ! ${(P)#hook} ))
			then
				unset $hook
			fi
		fi
	else
		if (( ${(P)+hook} ))
		then
			if (( ${${(P)hook}[(I)$fn]} == 0 ))
			then
				typeset -ga $hook
				set -A $hook ${(P)hook} $fn
			fi
		else
			typeset -ga $hook
			set -A $hook $fn
		fi
		autoload $autoopts -- $fn
	fi
}
compaudit () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
compdef () {
	local opt autol type func delete eval new i ret=0 cmd svc 
	local -a match mbegin mend
	emulate -L zsh
	setopt extendedglob
	if (( ! $# ))
	then
		print -u2 "$0: I need arguments"
		return 1
	fi
	while getopts "anpPkKde" opt
	do
		case "$opt" in
			(a) autol=yes  ;;
			(n) new=yes  ;;
			([pPkK]) if [[ -n "$type" ]]
				then
					print -u2 "$0: type already set to $type"
					return 1
				fi
				if [[ "$opt" = p ]]
				then
					type=pattern 
				elif [[ "$opt" = P ]]
				then
					type=postpattern 
				elif [[ "$opt" = K ]]
				then
					type=widgetkey 
				else
					type=key 
				fi ;;
			(d) delete=yes  ;;
			(e) eval=yes  ;;
		esac
	done
	shift OPTIND-1
	if (( ! $# ))
	then
		print -u2 "$0: I need arguments"
		return 1
	fi
	if [[ -z "$delete" ]]
	then
		if [[ -z "$eval" ]] && [[ "$1" = *\=* ]]
		then
			while (( $# ))
			do
				if [[ "$1" = *\=* ]]
				then
					cmd="${1%%\=*}" 
					svc="${1#*\=}" 
					func="$_comps[${_services[(r)$svc]:-$svc}]" 
					[[ -n ${_services[$svc]} ]] && svc=${_services[$svc]} 
					[[ -z "$func" ]] && func="${${_patcomps[(K)$svc][1]}:-${_postpatcomps[(K)$svc][1]}}" 
					if [[ -n "$func" ]]
					then
						_comps[$cmd]="$func" 
						_services[$cmd]="$svc" 
					else
						print -u2 "$0: unknown command or service: $svc"
						ret=1 
					fi
				else
					print -u2 "$0: invalid argument: $1"
					ret=1 
				fi
				shift
			done
			return ret
		fi
		func="$1" 
		[[ -n "$autol" ]] && autoload -rUz "$func"
		shift
		case "$type" in
			(widgetkey) while [[ -n $1 ]]
				do
					if [[ $# -lt 3 ]]
					then
						print -u2 "$0: compdef -K requires <widget> <comp-widget> <key>"
						return 1
					fi
					[[ $1 = _* ]] || 1="_$1" 
					[[ $2 = .* ]] || 2=".$2" 
					[[ $2 = .menu-select ]] && zmodload -i zsh/complist
					zle -C "$1" "$2" "$func"
					if [[ -n $new ]]
					then
						bindkey "$3" | IFS=$' \t' read -A opt
						[[ $opt[-1] = undefined-key ]] && bindkey "$3" "$1"
					else
						bindkey "$3" "$1"
					fi
					shift 3
				done ;;
			(key) if [[ $# -lt 2 ]]
				then
					print -u2 "$0: missing keys"
					return 1
				fi
				if [[ $1 = .* ]]
				then
					[[ $1 = .menu-select ]] && zmodload -i zsh/complist
					zle -C "$func" "$1" "$func"
				else
					[[ $1 = menu-select ]] && zmodload -i zsh/complist
					zle -C "$func" ".$1" "$func"
				fi
				shift
				for i
				do
					if [[ -n $new ]]
					then
						bindkey "$i" | IFS=$' \t' read -A opt
						[[ $opt[-1] = undefined-key ]] || continue
					fi
					bindkey "$i" "$func"
				done ;;
			(*) while (( $# ))
				do
					if [[ "$1" = -N ]]
					then
						type=normal 
					elif [[ "$1" = -p ]]
					then
						type=pattern 
					elif [[ "$1" = -P ]]
					then
						type=postpattern 
					else
						case "$type" in
							(pattern) if [[ $1 = (#b)(*)=(*) ]]
								then
									_patcomps[$match[1]]="=$match[2]=$func" 
								else
									_patcomps[$1]="$func" 
								fi ;;
							(postpattern) if [[ $1 = (#b)(*)=(*) ]]
								then
									_postpatcomps[$match[1]]="=$match[2]=$func" 
								else
									_postpatcomps[$1]="$func" 
								fi ;;
							(*) if [[ "$1" = *\=* ]]
								then
									cmd="${1%%\=*}" 
									svc=yes 
								else
									cmd="$1" 
									svc= 
								fi
								if [[ -z "$new" || -z "${_comps[$1]}" ]]
								then
									_comps[$cmd]="$func" 
									[[ -n "$svc" ]] && _services[$cmd]="${1#*\=}" 
								fi ;;
						esac
					fi
					shift
				done ;;
		esac
	else
		case "$type" in
			(pattern) unset "_patcomps[$^@]" ;;
			(postpattern) unset "_postpatcomps[$^@]" ;;
			(key) print -u2 "$0: cannot restore key bindings"
				return 1 ;;
			(*) unset "_comps[$^@]" ;;
		esac
	fi
}
compdump () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
compinit () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
compinstall () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
getent () {
	if [[ $1 = hosts ]]
	then
		sed 's/#.*//' /etc/$1 | grep -w $2
	elif [[ $2 = <-> ]]
	then
		grep ":$2:[^:]*$" /etc/$1
	else
		grep "^$2:" /etc/$1
	fi
}
is-at-least () {
	emulate -L zsh
	local IFS=".-" min_cnt=0 ver_cnt=0 part min_ver version order 
	min_ver=(${=1}) 
	version=(${=2:-$ZSH_VERSION} 0) 
	while (( $min_cnt <= ${#min_ver} ))
	do
		while [[ "$part" != <-> ]]
		do
			(( ++ver_cnt > ${#version} )) && return 0
			if [[ ${version[ver_cnt]} = *[0-9][^0-9]* ]]
			then
				order=(${version[ver_cnt]} ${min_ver[ver_cnt]}) 
				if [[ ${version[ver_cnt]} = <->* ]]
				then
					[[ $order != ${${(On)order}} ]] && return 1
				else
					[[ $order != ${${(O)order}} ]] && return 1
				fi
				[[ $order[1] != $order[2] ]] && return 0
			fi
			part=${version[ver_cnt]##*[^0-9]} 
		done
		while true
		do
			(( ++min_cnt > ${#min_ver} )) && return 0
			[[ ${min_ver[min_cnt]} = <-> ]] && break
		done
		(( part > min_ver[min_cnt] )) && return 0
		(( part < min_ver[min_cnt] )) && return 1
		part='' 
	done
}
precmd () {
	vcs_info
}
sdot () {
	local file="$1" 
	cd "$DOTFILES" || return
	echo "\033[0;32m++++ Changed to dotfiles repo: $DOTFILES ++++\033[0m"
	if ! git diff --quiet -- "$file" || ! git diff --cached --quiet -- "$file"
	then
		echo "\033[0;33mStashing all changes before pull...\033[0m"
		git stash push -u -m "Auto-stash before sync"
		local stashed=true 
	fi
	git pull --rebase || {
		echo "\033[0;31mPull failed! Resolve conflicts first.\033[0m"
		return 1
	}
	if [[ $stashed == true ]]
	then
		git stash pop || {
			echo "\033[0;31mStash pop failed! Resolve conflicts manually.\033[0m"
			return 1
		}
	fi
	if ! git diff --quiet -- "$file" || ! git diff --cached --quiet -- "$file"
	then
		git add "$file"
		git commit -m "Update $(basename $file)"
		git push
		echo "\033[0;32m++++ Committed and pushed ++++\033[0m"
	else
		echo "\033[0;33mNo changes to $file — nothing to commit.\033[0m"
	fi
	source ~/.zshrc
	echo "\033[0;32m++++ ~/.zshrc sourced ++++\033[0m"
}
vcs_info () {
	# undefined
	builtin autoload -XUz
}
y () {
	local tmp
	tmp=$(mktemp -t "yazi-cwd.XXXXXX") 
	yazi "$@" --cwd-file="$tmp"
	if [[ -s "$tmp" ]]
	then
		cd "$(cat "$tmp")"
	fi
	rm -f -- "$tmp"
}
z () {
	__zoxide_z "$@"
}
zi () {
	__zoxide_zi "$@"
}
# Shell Options
setopt noautomenu
setopt nohashdirs
setopt login
setopt promptsubst
# Aliases
alias -- c=code
alias -- ccli=claude
alias -- ga='git add -A'
alias -- gaa='git add .'
alias -- gb='git branch -vv'
alias -- gc='git commit -m'
alias -- gca='git commit -am'
alias -- gd='git diff'
alias -- gds='git diff --staged'
alias -- gf='git fetch --prune'
alias -- gl='git log --oneline --graph --decorate -3'
alias -- gm='git merge --no-ff'
alias -- gpl='git pull --rebase'
alias -- gps='git push'
alias -- grb='git rebase'
alias -- grep='grep --color'
alias -- gs='git status -sb'
alias -- gst='git stash'
alias -- gstp='git stash pop'
alias -- gsw='git switch'
alias -- ll='eza -1 -g --icons -l -a --no-filesize --no-time -o --git-repos-no-status --no-permissions --colour=always'
alias -- lsp='lsof -PiTCP -sTCP:LISTEN'
alias -- lt='eza -1 --icons -l --no-filesize --no-time -o --git-repos-no-status --no-permissions -T --group-directories-first'
alias -- myip='ifconfig en0 | grep inet | grep -v inet6 | awk '\''{print $2}'\'
alias -- path='echo; tr ":" "\n" <<< "$PATH"; echo;'
alias -- pubip='curl -s http://checkip.dyndns.org/ | sed '\''s/[a-zA-Z<>/ :]//g'\'
alias -- run-help=man
alias -- rz='source ~/.zshrc'
alias -- st='stow --dir=$DOTFILES --target=$HOME'
alias -- stoud='st -D'
alias -- stowp=st
alias -- stowr='st -R'
alias -- sv='sdot vim/.vimrc'
alias -- sz='sdot zsh/.zshrc'
alias -- tf=terraform
alias -- tx=tmux
alias -- v=vim
alias -- vv='vim /Users/rezna/github/terminal-setup/dotfiles/vim/.vimrc'
alias -- vz='vim /Users/rezna/github/terminal-setup/dotfiles/zsh/.zshrc'
alias -- which-command=whence
# Check for rg availability
if ! (unalias rg 2>/dev/null; command -v rg) >/dev/null 2>&1; then
  function rg {
  local _cc_bin="${CLAUDE_CODE_EXECPATH:-}"
  [[ -x $_cc_bin ]] || _cc_bin=/Users/rezna/.local/bin/claude
  if [[ ! -x $_cc_bin ]]; then command rg "$@"; return; fi
  if [[ -n $ZSH_VERSION ]]; then
    ARGV0=rg "$_cc_bin" "$@"
  elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "win32" ]]; then
    ARGV0=rg "$_cc_bin" "$@"
  elif [[ $BASHPID != $$ ]]; then
    exec -a rg "$_cc_bin" "$@"
  else
    (exec -a rg "$_cc_bin" "$@")
  fi
}
fi
# Shadow find/grep with embedded bfs/ugrep
unalias find 2>/dev/null || true
unalias grep 2>/dev/null || true
function find {
  local _cc_bin="${CLAUDE_CODE_EXECPATH:-}"
  [[ -x $_cc_bin ]] || _cc_bin=/Users/rezna/.local/bin/claude
  if [[ ! -x $_cc_bin ]]; then command find "$@"; return; fi
  if [[ -n $ZSH_VERSION ]]; then
    ARGV0=bfs "$_cc_bin" -S dfs -regextype findutils-default "$@"
  elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "win32" ]]; then
    ARGV0=bfs "$_cc_bin" -S dfs -regextype findutils-default "$@"
  elif [[ $BASHPID != $$ ]]; then
    exec -a bfs "$_cc_bin" -S dfs -regextype findutils-default "$@"
  else
    (exec -a bfs "$_cc_bin" -S dfs -regextype findutils-default "$@")
  fi
}
function grep {
  local _cc_bin="${CLAUDE_CODE_EXECPATH:-}"
  [[ -x $_cc_bin ]] || _cc_bin=/Users/rezna/.local/bin/claude
  if [[ ! -x $_cc_bin ]]; then command grep "$@"; return; fi
  if [[ -n $ZSH_VERSION ]]; then
    ARGV0=ugrep "$_cc_bin" -G --ignore-files --hidden -I --exclude-dir=.git --exclude-dir=.svn --exclude-dir=.hg --exclude-dir=.bzr --exclude-dir=.jj --exclude-dir=.sl "$@"
  elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "win32" ]]; then
    ARGV0=ugrep "$_cc_bin" -G --ignore-files --hidden -I --exclude-dir=.git --exclude-dir=.svn --exclude-dir=.hg --exclude-dir=.bzr --exclude-dir=.jj --exclude-dir=.sl "$@"
  elif [[ $BASHPID != $$ ]]; then
    exec -a ugrep "$_cc_bin" -G --ignore-files --hidden -I --exclude-dir=.git --exclude-dir=.svn --exclude-dir=.hg --exclude-dir=.bzr --exclude-dir=.jj --exclude-dir=.sl "$@"
  else
    (exec -a ugrep "$_cc_bin" -G --ignore-files --hidden -I --exclude-dir=.git --exclude-dir=.svn --exclude-dir=.hg --exclude-dir=.bzr --exclude-dir=.jj --exclude-dir=.sl "$@")
  fi
}
export PATH=/Users/rezna/.local/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/opt/pkg/env/active/bin:/opt/pmk/env/global/bin:/opt/homebrew/bin:/Applications/kitty.app/Contents/MacOS
