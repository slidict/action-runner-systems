FROM ghcr.io/actions/actions-runner:latest

# root ユーザーに切り替え
USER root

# 必要なツールをインストール（curl, unzip, yq, GitHub CLI, Docker CLI + Compose）
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    unzip \
    gnupg \
    lsb-release && \
    \
    # yq のインストール
    curl -L https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -o /usr/bin/yq && \
    chmod +x /usr/bin/yq && \
    \
    # GitHub CLI のインストール
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
      gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
      > /etc/apt/sources.list.d/github-cli.list && \
    apt-get update && apt-get install -y gh && \
    \
    # Docker CLI + Compose Plugin のインストール
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
      gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y docker-ce-cli docker-compose-plugin && \
    \
    # setup-ruby に必要な ToolCache ディレクトリ
    mkdir -p /opt/hostedtoolcache && \
    chmod -R 777 /opt/hostedtoolcache

# runner ユーザーに戻す
USER runner

# GitHub Actions が使う作業ディレクトリ
WORKDIR /home/runner
