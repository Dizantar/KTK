#!/bin/bash

set -o errexit
set -o pipefail

if [[ "$1" == "" ]]
then
  hostname -I && python3 -m http.server 8889
else
  hostname -I && python3 -m http.server $1
fi
