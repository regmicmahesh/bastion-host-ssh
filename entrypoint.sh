#!/bin/sh

google-authenticator  --rate-limit=10 --rate-time=60 --time-based --no-confirm --force --disallow-reuse --window-size=2

/usr/sbin/sshd -D -e
