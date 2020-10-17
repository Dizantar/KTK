#!/bin/bash

set -o errexit
set -o pipefail

# Purge existing nmap result
if [[ "$*" == *--purge* ]]
then
  rm -f nmap*.txt
fi

# Stage 1 scan (quick TCP port scan)
nmap -T4 -Pn -p- $1 -oN nmap.stage1.txt
if [[ -f nmap.stage1.txt ]]
then
  mousepad nmap.stage1.txt &
else
  exit 0
fi

# Stage 2 scan (open port with script and detection)
OPENPORTS=$(grep open < nmap.stage1.txt | cut -f 1 -d "/" | sort --unique)
PORTLIST=""
while read line; do
  PORTLIST="$PORTLIST$line,"
done <<< "$OPENPORTS"
echo "Stage 2 ports: $PORTLIST"
nmap -Pn -p $PORTLIST -A -T4 --script=default $1 -oN nmap.stage2.txt
if [[ -f nmap.stage2.txt ]]
then
  mousepad nmap.stage2.txt &
fi

# Stage 3 scan (TOP 1000 UDP port scan)
touch nmap.stage3.txt 
sudo nmap -Pn -sU -T4 --top-ports 1000 -T4 $1 -oN nmap.stage3.txt
if [[ -f nmap.stage3.txt ]]
then
  mousepad nmap.stage3.txt &
else
  exit 0
fi

# Stage 4 scan (UDP with script and detection)
touch nmap.stage4.txt
OPENPORTS=$(grep open < nmap.stage3.txt | grep /udp | cut -f 1 -d "/" | sort --unique)
PORTLIST=""
while read line; do
  PORTLIST="$PORTLIST$line,"
done <<< "$OPENPORTS"
echo "Stage 4 ports: $PORTLIST"
sudo nmap -Pn -sU -p $PORTLIST -A -T4 --script=default $1 -oN nmap.stage4.txt
if [[ -f nmap.stage4.txt ]]
then
  mousepad nmap.stage4.txt &
fi

