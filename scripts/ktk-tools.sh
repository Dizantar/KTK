#!/bin/bash

set -o errexit
set -o pipefail

if [[ "$1" == "" ]]
then
  hostname -I && python3 -m http.server --directory /opt/ktk/tools 8888
else
  hostname -I && python3 -m http.server --directory /opt/ktk/tools $1
fi
