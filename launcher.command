#!/usr/bin/env bash
# Launcher invoked by BBterminal.app on the Desktop.
# Self-bootstraps setup, starts servers, opens dashboard in a dedicated
# Chrome app window, and shuts the servers down when that window closes.

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

# Tell start.sh not to open the browser — the launcher owns that lifecycle.
export BBTERMINAL_NO_OPEN=1
./start.sh
status=$?

if [ $status -ne 0 ]; then
  echo
  echo "start.sh exited with status $status"
  read -n 1 -s -r -p "Press any key to close..."
  exit $status
fi

URL="http://localhost:5173/"
USER_DATA_DIR="$HOME/.bbterminal-chrome"
mkdir -p "$USER_DATA_DIR"

if [ -d "/Applications/Google Chrome.app" ]; then
  echo
  echo "▸ Opening BBterminal in dedicated browser window."
  echo "  Close the window to shut down the local servers."
  echo
  # -n: new instance, -W: wait for it to quit, --args: pass to Chrome.
  # The dedicated --user-data-dir gives us our own Chrome process so closing
  # the window terminates only this instance, not the user's main Chrome.
  open -n -W -a "Google Chrome" --args \
    --app="$URL" \
    --user-data-dir="$USER_DATA_DIR"
  echo
  echo "▸ Browser window closed — stopping local servers..."
  ./stop.sh || true
else
  open "$URL"
  echo
  echo "Chrome not found. Dashboard opened in your default browser."
  echo "Closing the browser will NOT auto-stop the servers — run ./stop.sh"
  echo "from $(pwd) when you're done."
  read -n 1 -s -r -p "Press any key to close this window..."
fi
