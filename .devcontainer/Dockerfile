FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    zip \
    git \
    openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin

RUN useradd -m -s /bin/bash vscode

USER vscode
WORKDIR /home/vscode

RUN curl -s https://get.sdkman.io | bash \
    && bash -c "source /home/vscode/.sdkman/bin/sdkman-init.sh && sdk install kotlin"

ENV PATH=$PATH:/home/vscode/.sdkman/candidates/kotlin/current/bin