#!/usr/bin/env bash
set -euo pipefail

BUILD_LOG=/tmp/devcontainer-build.log
exec >> "$BUILD_LOG" 2>&1

echo "postCreate: running as $(id -un)" | tee -a "$BUILD_LOG"

# Determine user home (prefer REMOTE_USER or vscode)
if [ -n "${REMOTE_USER:-}" ]; then
  TARGET_USER="$REMOTE_USER"
else
  TARGET_USER="vscode"
fi

USER_HOME="/home/${TARGET_USER}"

# Install SDKMAN non-interactively for the target user if not present
if [ ! -d "$USER_HOME/.sdkman" ]; then
  echo "Installing SDKMAN for user $TARGET_USER at $USER_HOME" | tee -a "$BUILD_LOG"
  su - "$TARGET_USER" -s /bin/bash -c "curl -s 'https://get.sdkman.io' | bash" || true
  # Ensure SDKMAN init in bash profile
  PROFILE="$USER_HOME/.bashrc"
  if ! grep -q 'sdkman-init.sh' "$PROFILE" 2>/dev/null; then
    echo 'export SDKMAN_DIR="$HOME/.sdkman"' >> "$PROFILE"
    echo '[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"' >> "$PROFILE"
  fi
else
  echo "SDKMAN already installed at $USER_HOME/.sdkman" | tee -a "$BUILD_LOG"
fi

# Make sure user bin is in PATH and owned by the user
mkdir -p "$USER_HOME/.local/bin"
chown -R "$TARGET_USER":"$TARGET_USER" "$USER_HOME/.local" || true

# Configure git global user for the container user (idempotent)
echo "Configuring git user for $TARGET_USER" | tee -a "$BUILD_LOG"
if [ "$(id -un)" = "$TARGET_USER" ]; then
  git config --global user.name "filipe cancio" || true
  git config --global user.email "filipe.cancio@outlook.com" || true
else
  su - "$TARGET_USER" -s /bin/bash -c 'git config --global user.name "filipe cancio" || true'
  su - "$TARGET_USER" -s /bin/bash -c 'git config --global user.email "filipe.cancio@outlook.com" || true'
fi

# Quick verification of installed tools
echo "--- Verification after postCreate ---" | tee -a "$BUILD_LOG"
su - "$TARGET_USER" -s /bin/bash -c 'echo "java:"; java -version || true'
su - "$TARGET_USER" -s /bin/bash -c 'echo "kotlinc:"; kotlinc -version || true'
su - "$TARGET_USER" -s /bin/bash -c 'echo "kotlin:"; kotlin -version || true'
su - "$TARGET_USER" -s /bin/bash -c 'echo "swift:"; if command -v swift >/dev/null 2>&1; then swift --version; else echo "swift: not found"; fi'

echo "postCreate finished: $(date)" | tee -a "$BUILD_LOG"
