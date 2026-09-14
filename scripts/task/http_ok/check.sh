#!/bin/sh
[ -s /root/index.html ] || exit 1
grep -qi nginx /root/index.html
