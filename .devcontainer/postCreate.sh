#!/usr/bin/env bash
set -euo pipefail

BUILD_LOG=/tmp/devcontainer-build.log
exec >> "$BUILD_LOG" 2>&1

echo "postCreate: running as $(id -un)" | tee -a "$BUILD_LOG"

# Install SDKMAN for the vscode user if not present
if [ "$(id -un)" = "vscode" ] || [ -n "${REMOTE_USER:-}" ] ; then
  USER_HOME="$HOME"
else
  USER_HOME="/home/vscode"
fi

# Install SDKMAN non-interactively for the vscode user
if [ ! -d "$USER_HOME/.sdkman" ]; then
  echo "Installing SDKMAN for user at $USER_HOME" | tee -a "$BUILD_LOG"
  su -s /bin/bash -c "curl -s 'https://get.sdkman.io' | bash" vscode || true
  # Ensure SDKMAN init in bash profile
  PROFILE="$USER_HOME/.bashrc"
  if ! grep -q 'sdkman-init.sh' "$PROFILE" 2>/dev/null; then
    echo 'export SDKMAN_DIR="$HOME/.sdkman"' >> "$PROFILE"
    echo '[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"' >> "$PROFILE"
  fi
else
  echo "SDKMAN already installed at $USER_HOME/.sdkman" | tee -a "$BUILD_LOG"
fi

# Make sure user bin is in PATH
mkdir -p "$USER_HOME/.local/bin"
chown -R vscode:vscode "$USER_HOME/.local" || true

# Quick verification of installed tools
echo "--- Verification after postCreate ---" | tee -a "$BUILD_LOG"
su -s /bin/bash -c 'echo "java:"; java -version || true' vscode
su -s /bin/bash -c 'echo "kotlinc:"; kotlinc -version || true' vscode
su -s /bin/bash -c 'echo "kotlin:"; kotlin -version || true' vscode
su -s /bin/bash -c 'echo "swift:"; if command -v swift >/dev/null 2>&1; then swift --version; else echo "swift: not found"; fi' vscode

echo "postCreate finished: $(date)" | tee -a "$BUILD_LOG"
