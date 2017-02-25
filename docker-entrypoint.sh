#!/bin/bash
set -e

case "$1" in 
	p4d)
		shift
		exec /usr/sbin/p4d -C1 $*
		;;
	checkpoint)
		echo "Performing backup of database files only..."
		exec /usr/sbin/p4d -C1 -z -jc /backup/
		;;

	backup)
		echo "Doing full backup of database files and library files..."
		/usr/sbin/p4d -C1 -z -jc /backup/metadata
		if [ -f /backup/library.tgz ]; then
			mv /backup/library.tgz /backup/library.prev.tgz
		fi
		tar czf /backup/library.tgz /library
		if [ -f $P4ROOT/server.id ]; then
			cp $P4ROOT/server.id /backup
		fi
		exit 0
		;;
	restore)
		shift
		if [ -z $1 ]; then
			echo "Usage: restore <checkpoint filename> [journal file]"
			exit 1
		fi
		/usr/sbin/p4d -C1 -z -jv /backup/$1
		if [ ! -z $2 ]; then
			/usr/sbin/p4d -C1 -jv /backup/$2
		fi
		tar xzf /backup/library.tgz
		if [ -f /backup/server.id ]; then
			cp /backup/server.id $P4ROOT
		fi
		/usr/sbin/p4d -C1 -z -jr /backup/$1
		if [ ! -z $2 ]; then
			/usr/sbin/p4d -C1 -jr /backup/$2
		fi
		exit 0
		;;
	ping)
		exec /bin/ping -c 4 8.8.8.8
		;;
esac

exec "$@"
