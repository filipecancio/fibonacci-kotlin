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






# Core packages (log output to $BUILD_LOG for debugging rebuild failures)
RUN bash -lc 'set -eux; ( \
  apt-get update \
  && apt-get install -y --no-install-recommends \
    curl wget git ca-certificates unzip zip gnupg lsb-release build-essential software-properties-common \
    python3 python3-pip python3-venv openjdk-17-jdk maven sudo pkg-config libssl-dev \
  && rm -rf /var/lib/apt/lists/* \
) 2>&1 | tee -a $BUILD_LOG'

# Install Kotlin compiler (matching the version used in the repo postCreate earlier)
RUN bash -lc 'set -eux; ( \
  KOTLIN_VERSION=1.9.10 \
  && curl -fsSL "https://download.jetbrains.com/kotlin/compiler/kotlin-compiler-${KOTLIN_VERSION}.zip" -o /tmp/kotlin.zip \
  && unzip /tmp/kotlin.zip -d /opt/kotlin \
  && rm /tmp/kotlin.zip \
  && ln -s /opt/kotlin/kotlinc/bin/kotlinc /usr/local/bin/kotlinc || true \
  && ln -s /opt/kotlin/kotlinc/bin/kotlin /usr/local/bin/kotlin || true \
) 2>&1 | tee -a $BUILD_LOG'

# Install Dart SDK
RUN bash -lc 'set -eux; ( \
  wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/dart.gpg \
  && echo "deb [signed-by=/usr/share/keyrings/dart.gpg] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main" > /etc/apt/sources.list.d/dart_stable.list \
  && apt-get update && apt-get install -y dart \
  && rm -rf /var/lib/apt/lists/* \
) 2>&1 | tee -a $BUILD_LOG'

# Install Swift (pre-packaged release for Ubuntu 22.04). Adjust SWIFT_VERSION if you need a newer release.
RUN bash -lc 'set -eux; ( \
  SWIFT_VERSION=5.9.3; \
  mkdir -p /opt/swift; \
  # Try ubuntu24.04 build first, fall back to ubuntu22.04 if not available
  SWIFT_TAR_2404="swift-${SWIFT_VERSION}-RELEASE-ubuntu24.04.tar.gz"; \
  SWIFT_URL_2404="https://swift.org/builds/swift-${SWIFT_VERSION}-release/ubuntu2404/swift-${SWIFT_VERSION}-RELEASE/${SWIFT_TAR_2404}"; \
  SWIFT_TAR_2204="swift-${SWIFT_VERSION}-RELEASE-ubuntu22.04.tar.gz"; \
  SWIFT_URL_2204="https://swift.org/builds/swift-${SWIFT_VERSION}-release/ubuntu2204/swift-${SWIFT_VERSION}-RELEASE/${SWIFT_TAR_2204}"; \
  if curl -fsSL "$SWIFT_URL_2404" -o /tmp/swift.tar.gz; then \
    echo "Using ubuntu24.04 Swift build"; \
  elif curl -fsSL "$SWIFT_URL_2204" -o /tmp/swift.tar.gz; then \
    echo "Fell back to ubuntu22.04 Swift build"; \
  else \
    echo "Could not download Swift for ubuntu24.04 or ubuntu22.04" >&2; exit 1; \
  fi; \
  tar -xzf /tmp/swift.tar.gz -C /opt/swift --strip-components=1; \
  rm /tmp/swift.tar.gz; \
  ln -s /opt/swift/usr/bin/swift /usr/local/bin/swift || true; \
) 2>&1 | tee -a $BUILD_LOG'

# Put common locations into PATH (Dart is installed to /usr/lib/dart/bin by the package)
ENV PATH="/usr/local/bin:/usr/lib/dart/bin:${PATH}"

# Ensure vscode user exists and has home directory
RUN bash -lc 'set -eux; ( \
  useradd -m -s /bin/bash vscode || true \
  && mkdir -p /home/vscode/.local/bin \
  && chown -R vscode:vscode /home/vscode \
  && if [ -e "$BUILD_LOG" ]; then chown vscode:vscode "$BUILD_LOG" || true; chmod 666 "$BUILD_LOG" || true; fi \
) 2>&1 | tee -a $BUILD_LOG'

# Quick verification (non-fatal) - log output for easier post-failure inspection
RUN bash -lc 'set -eux; ( \
  echo "Verify installed tools:" \
  && java -version || true \
  && javac -version || true \
  && python3 --version || true \
  && kotlinc -version || true \
  && dart --version || true \
  && swift --version || true \
) 2>&1 | tee -a $BUILD_LOG'
