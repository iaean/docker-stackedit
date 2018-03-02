#!/bin/bash
set -e

echo Running: "$@"

if [[ `basename ${1}` == "node" ]]; then # prod
  export SERVE_V4=false
  export NODE_ENV=production
  exec "$@" # </dev/null >/dev/null 2>&1
else # dev
  export SERVE_V4=false
  export NODE_ENV=development
  # npm start
fi

# fallthrough...
exec "$@"
