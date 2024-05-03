#!/bin/sh

set -e
if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

if [ "$1" = 'server' ]; then
  # Run database migrations only if needed
  bundle
  bundle exec rails db:prepare
  bundle exec rails db:seed
  # Start the Rails server
  bundle exec rails server -b 0.0.0.0 -p 3000
fi
