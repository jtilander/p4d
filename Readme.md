# Minimal perforce server image

This is a minimal perforce server that primarily intended for
trying out new versions of perforce in a test environment.

As such, there is no support for fancy features like federation,
git-fusion etc. Just the server itself.

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
make kill
```
