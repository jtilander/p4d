#!/bin/bash
set -e

case "$1" in 
	p4d)
		shift
		exec /usr/sbin/p4d -C1 $*
		;;
	checkpoint)
		exec /usr/sbin/p4d -C1 -z -jc
		;;
	restore)
		shift
		if [ -z $1 ]; then
			echo "Usage: restore <checkpoint filename>"
			exit 1
		fi
		exec /usr/sbin/p4d -C1 -z -jr $*
		;;
	ping)
		exec /bin/ping -c 4 8.8.8.8
		;;
esac

exec "$@"
