FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV BUILD_LOG=/tmp/devcontainer-build.log

# Ensure build log exists and use bash for verbose failure output inside RUNs
RUN mkdir -p $(dirname $BUILD_LOG) && echo "Build started: $(date)" | tee -a $BUILD_LOG

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
