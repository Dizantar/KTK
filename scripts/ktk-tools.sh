#!/bin/bash

set -o errexit
set -o pipefail

if [[ "$1" == "" ]]
then
  hostname -I && python3 -m http.server --directory /KTK/tools 8888
else
  hostname -I && python3 -m http.server --directory /KTK/tools $1
fi
