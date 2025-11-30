#!/bin/bash
set -e

# === Arguments ===
APP_NAME="$1"             # e.g. "myapp"
APP_DIR="/home/lgibbs/github/$APP_NAME"
SCREEN_NAME="$APP_NAME"
NODE_CMD=${2:-node index.js test} # optional override of start command
BRANCH="${3:-main}"              # default branch

# === Safety checks ===
if [ -z "$APP_NAME" ]; then
  echo "Usage: $0 <app_name> [node_command] [branch]"
  exit 1
fi

if [ ! -d "$APP_DIR" ]; then
  echo "? Directory $APP_DIR not found, creating directory."
  mkdir -p "$APP_DIR"
fi

echo "?? Deploying '$APP_NAME' from branch '$BRANCH'..."
cd "$APP_DIR"

# === Stop old process ===
if screen -list | grep -q "$SCREEN_NAME"; then
  echo "Killing existing screen: $SCREEN_NAME"
  screen -S "$SCREEN_NAME" -X quit || true
fi

# === Update code ===
echo "Pulling latest code..."
git -C "$APP_DIR" fetch origin "$BRANCH" || git clone "https://github.com/exponentialcherub/$APP_NAME.git" "$APP_DIR"
git reset --hard "origin/$BRANCH"

# === Restart service ===
echo "Starting new screen: $SCREEN_NAME"
echo "Running command $NODE_CMD"
screen -dmS "$SCREEN_NAME" bash -c "$NODE_CMD"

echo "? '$APP_NAME' deployed successfully."
