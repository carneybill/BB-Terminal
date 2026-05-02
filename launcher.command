#!/usr/bin/env bash
# Launcher invoked by BBterminal.app on the Desktop.
# Self-bootstraps: runs setup.sh on first launch, then start.sh every time.

cd "/Users/bc/BB-Terminal" || {
  echo "BB-Terminal repo not found at /Users/bc/BB-Terminal"
  read -n 1 -s -r -p "Press any key to close..."
  exit 1
}

# First-time setup if OpenBB venv or UI deps are missing
if [ ! -x .venv/bin/openbb-api ] || [ ! -d app/node_modules ]; then
  echo "▸ First-time setup detected — running ./setup.sh (takes ~3 min)..."
  echo
  if ! ./setup.sh; then
    echo
    echo "setup.sh failed. See output above."
    read -n 1 -s -r -p "Press any key to close..."
    exit 1
  fi
  echo
fi

./start.sh
status=$?

if [ $status -ne 0 ]; then
  echo
  echo "start.sh exited with status $status"
  read -n 1 -s -r -p "Press any key to close..."
fi
