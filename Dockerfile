FROM debian:bookworm-slim

# 必要なパッケージのインストール
RUN apt-get update && apt-get install -y \
    nodejs \
    npm \
    fontconfig \
    fonts-liberation \
    ca-certificates \
    git \
    build-essential \
    cmake \
    wget \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# MultiMarkdownのソースからのビルドとインストール
RUN git clone https://github.com/fletcher/MultiMarkdown-6.git && \
    cd MultiMarkdown-6 && \
    git submodule update --init --recursive && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install && \
    cd ../.. && \
    rm -rf MultiMarkdown-6

# 作業ディレクトリの設定
WORKDIR /app

# Playwrightの環境変数設定
ENV PLAYWRIGHT_BROWSERS_PATH=/github/home/.cache/ms-playwright

# Playwrightのインストールとブラウザのセットアップ
RUN mkdir -p /github/home/.cache/ms-playwright && \
    npm init -y && \
    npm install playwright && \
    npx playwright install chromium --with-deps && \
    # ディレクトリの権限を調整
    chmod -R 777 /github/home/.cache/ms-playwright

# スクリプトのコピー
COPY . .

# シェルをデフォルトのコマンドとして設定
CMD ["/bin/bash"]