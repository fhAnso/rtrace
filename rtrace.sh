#!/bin/bash
# Author: fhAnso
# Date: 26.06.24
# License: MIT
#
# rtrace.sh will follow the redirections of the given URL
#
# Example:
# 	./rtrace.sh -u http://<target_url>/

[[ $# -eq 0 ]] && {
	printf "No flags set. Try -h or --help.\n" 
	exit 1
}

redirects=0

trace() {
	local count=${2:-1} 
	local status
	local url


	read -r status url < <(
		curl -H "Cache-Control: no-cache" \
			-o /dev/null \
			--silent \
			--head \
			--insecure \
			--write-out "%{http_code}\t%{redirect_url}\n" $1 -I
	)

	printf "[%d] %s\n" $status "$1"
	
	[[ $1 = "$url" ]] || [[ $count -gt 10 ]] && {
		printf "More redirections than allowed.\n"
	} || {
		case $status in
		30*) 
			((redirects++))
			trace "$url" $((count + 1)) 
			;;
		esac
	}
}

banner="Description:
	rtrace.sh is designed to trace HTTP redirects
	of a given URL. It utilizes `curl` CLI to send
	a series of HEAD requests, following redirects until
	reaching the final destination.

Options:
	-h, --help	Display this help message
	-u, --url	Start url"


while [[ $# -gt 0 ]]
do
	case "$1" in
	-h|--help)
		printf "%s\n" "$banner"
		exit 0
		;;
	-u|--url)
		[[ -n "$2" ]] && {
			url="$2"
			shift
		} || {
			printf "Flag -u/--url requires an argument!\n" 
			exit 1
		}
		;;
	*)
		printf "Unknown Flag: %s\n" "$1"
		exit 1
		;;
	esac
	shift
done


printf "Sending HEAD request to: %s\n\n" "$url"

trace "$url"

printf "\nDone, Redirects: %d\n" $redirects
