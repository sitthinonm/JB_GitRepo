#!/usr/bin/env bash
set -euo pipefail

if curl -sf -o /dev/null --max-time 2 http://127.0.0.1:8080/index.html; then
  echo "dashboard already serving on :8080"
  exit 0
fi

exec python3 -m http.server 8080 --bind 0.0.0.0 --directory dashboard
