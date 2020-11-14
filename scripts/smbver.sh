#!/bin/sh
#Author: rewardone
#Modified by Dizantar
#Description:
# Requires root or enough permissions to use tcpdump
# Will listen for the first 8 packets of a null login
# and grab the SMB Version
#Notes:
# Will sometimes not capture or will print multiple
# lines. May need to run a second time for success.
if [ -z $1 ]; then echo "Usage: ./smbver.sh RHOST {RPORT}" && exit; else rhost=$1; fi
if [ ! -z $2 ]; then rport=$2; else rport=139; fi
if [ ! -z $3 ]; then iface=$3; else iface=tun0; fi
tcpdump -s0 -n -i $iface src $rhost and port $rport -A -c 10 2>/dev/null | grep -i "samba\|s.a.m" | tr -d '.' | grep -oP 'UnixSamba.*[0-9a-z]' | tr -d '\n' & echo -n "$rhost: " &
echo "exit" | smbclient -L $rhost 1>/dev/null 2>/dev/null
echo "" && sleep .1
