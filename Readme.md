# Minimal perforce server image

This is a minimal perforce server that primarily intended for
trying out new versions of perforce in a test environment.

As such, there is no support for fancy features like federation,
git-fusion etc. Just the server itself.

# I just want to run a perforce server!

Issue this and you will have a freshly initialized perforce server:

```
DATAVOLUMES=/mnt/perforce docker run -v $DATAVOLUMES/metadata:/metadata -v $DATAVOLUMES/library:/library -v $DATAVOLUMES/journals:/journals -v $DATAVOLUMES/backup:/backup -p 1666:1666 jtilander/p4d 

```

This will persist all the content under /mnt/perforce for you.


# Backup & Restore

## Backup

Backup a currently running instance by issuing

```
DATAVOLUMES=/mnt/perforce make backup

```

## Restore

Inspect what checkpoints you have in /mnt/perforce/backup and copy one of them into checkpoint.gz. This and library.tgz are used to restore a server from scratch.

```
DATAVOLUMES=/mnt/perforce make backup
```

# Usage

Make the image by

```
make image
```

Bring up a test environment with:

```
make up
```

Clean out everything by
```
make nuke
```
