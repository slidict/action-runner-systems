FROM ghcr.io/actions/actions-runner:latest

# root 権限で apt 実行できるように
USER root

# 必要なツールをインストール（yq, curl, unzip, docker CLI）
RUN apt-get update && \
    apt-get install -y \
        curl \
        unzip \
        docker.io && \
    curl -L https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -o /usr/bin/yq && \
    chmod +x /usr/bin/yq

# 必要に応じてユーザーを runner に戻す
USER runner

# ワーキングディレクトリ（GitHub Actions ランナーが使う）
WORKDIR /home/runner
