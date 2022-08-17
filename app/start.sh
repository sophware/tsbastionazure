#!/bin/sh

/usr/bin/ssh-keygen -A
mkdir -p /var/run/sshd
/usr/sbin/sshd
eval $(printenv | sed -n "s/^\([^=]\+\)=\(.*\)$/export \1=\2/p" | sed 's/"/\\\"/g' | sed '/=/s//="/' | sed 's/$/"/' >> /etc/profile)
/app/tailscaled --tun=userspace-networking --socks5-server=localhost:1055 &
#/app/tailscale up --authkey=${TAILSCALE_AUTHKEY} --hostname=azureapp ${UP_FLAGS}
#echo Tailscale started
tail -f /dev/null