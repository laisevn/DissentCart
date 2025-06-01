#!/bin/bash
set -e

rm -f /app/tmp/pids/server.pid

until pg_isready -h db -p 5432 -U postgres; do
  echo "Aguardando PostgreSQL..."
  sleep 2
done

if ! rails db:version 2>/dev/null; then
  rails db:create
  rails db:migrate
else
  rails db:migrate
fi

exec "$@"
