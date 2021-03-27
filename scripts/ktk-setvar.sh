#!/bin/bash

set -o errexit
set -o pipefail

function valid_ip()
{
  local  ip=$1
  local  stat=1

  if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
     OIFS=$IFS
     IFS='.'
     ip=($ip)
     IFS=$OIFS
     [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
        && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
     stat=$?
  fi
  return $stat
}

# Get target IP
read -p "Target IP [${RHOST:-127.0.0.1}]: " RHOST
RHOST=${RHOST:-127.0.0.1}

until valid_ip $RHOST
do
  unset RHOST
  read -p "Target IP [${RHOST:-127.0.0.1}]: " RHOST
  RHOST=${RHOST:-127.0.0.1}
done

# Get source IP
read -p "Attacker IP [${LHOST:-127.0.0.1}]: " LHOST
LHOST=${LHOST:-127.0.0.1}

until valid_ip $LHOST
do
  unset LHOST
  read -p "Attacker IP [${LHOST:-127.0.0.1}]: " LHOST
  LHOST=${LHOST:-127.0.0.1}
done

echo "export RHOST=$RHOST" > /tmp/ktk-vars.txt
echo "export LHOST=$LHOST" >> /tmp/ktk-vars.txt

source /tmp/ktk-vars.txt
