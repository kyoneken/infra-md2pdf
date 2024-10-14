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

# Playwrightのインストールと設定（Chromeを含む）
RUN npm init -y && \
    npm install playwright@latest && \
    npx playwright install chromium --with-deps

# スクリプトのコピー
COPY convert_to_pdf.js .

# シェルをデフォルトのコマンドとして設定
CMD ["/bin/bash"]