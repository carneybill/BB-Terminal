#!/usr/bin/env bash
# Hidden launcher invoked by BBterminal.app on the Desktop.
# Lives in the repo so the .app is a thin shortcut.

cd "/Users/bc/BB-Terminal" || {
  echo "BB-Terminal repo not found at /Users/bc/BB-Terminal"
  read -n 1 -s -r -p "Press any key to close..."
  exit 1
}

./start.sh
status=$?

if [ $status -ne 0 ]; then
  echo
  echo "start.sh exited with status $status"
  read -n 1 -s -r -p "Press any key to close..."
fi
