FROM mcr.microsoft.com/devcontainers/base:ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Core packages
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    curl wget git ca-certificates unzip zip gnupg lsb-release build-essential software-properties-common \
    python3 python3-pip python3-venv openjdk-17-jdk maven sudo pkg-config libssl-dev \
  && rm -rf /var/lib/apt/lists/*

# Install Kotlin compiler (matching the version used in the repo postCreate earlier)
RUN KOTLIN_VERSION=1.9.10 \
  && curl -fsSL "https://download.jetbrains.com/kotlin/compiler/kotlin-compiler-${KOTLIN_VERSION}.zip" -o /tmp/kotlin.zip \
  && unzip /tmp/kotlin.zip -d /opt/kotlin \
  && rm /tmp/kotlin.zip \
  && ln -s /opt/kotlin/kotlinc/bin/kotlinc /usr/local/bin/kotlinc || true \
  && ln -s /opt/kotlin/kotlinc/bin/kotlin /usr/local/bin/kotlin || true

# Install Dart SDK
RUN wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/dart.gpg \
  && echo "deb [signed-by=/usr/share/keyrings/dart.gpg] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main" > /etc/apt/sources.list.d/dart_stable.list \
  && apt-get update && apt-get install -y dart \
  && rm -rf /var/lib/apt/lists/*

# Install Swift (pre-packaged release for Ubuntu 22.04). Adjust SWIFT_VERSION if you need a newer release.
RUN SWIFT_VERSION=5.9.3 \
  && SWIFT_TAR="swift-${SWIFT_VERSION}-RELEASE-ubuntu22.04.tar.gz" \
  && SWIFT_URL="https://swift.org/builds/swift-${SWIFT_VERSION}-release/ubuntu2204/swift-${SWIFT_VERSION}-RELEASE/${SWIFT_TAR}" \
  && mkdir -p /opt/swift \
  && curl -fsSL "$SWIFT_URL" -o /tmp/swift.tar.gz \
  && tar -xzf /tmp/swift.tar.gz -C /opt/swift --strip-components=1 \
  && rm /tmp/swift.tar.gz \
  && ln -s /opt/swift/usr/bin/swift /usr/local/bin/swift || true

# Put common locations into PATH (Dart is installed to /usr/lib/dart/bin by the package)
ENV PATH="/usr/local/bin:/usr/lib/dart/bin:${PATH}"

# Ensure vscode user exists and has home directory
RUN useradd -m -s /bin/bash vscode || true \
  && mkdir -p /home/vscode/.local/bin \
  && chown -R vscode:vscode /home/vscode

SHELL ["/bin/bash", "-lc"]

# Quick verification (non-fatal)
RUN echo "Verify installed tools:" \
  && java -version || true \
  && javac -version || true \
  && python3 --version || true \
  && kotlinc -version || true \
  && dart --version || true \
  && swift --version || true
