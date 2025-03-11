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

# ロケールの設定
RUN locale-gen ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8

# フォントキャッシュの更新
RUN fc-cache -fv

# Google Chromeリポジトリの追加とインストール
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list \
    && apt-get update \
    && apt-get install -y \
    google-chrome-stable \
    # Chromeの依存関係
    libnss3 \
    libnspr4 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libpango-1.0-0 \
    libcairo2 \
    libasound2 \
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

# Playwrightのインストール（ブラウザはスキップ）
RUN npm init -y && \
    npm install playwright@latest

# Playwrightの環境変数設定
ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
ENV PLAYWRIGHT_BROWSERS_PATH=0
ENV CHROME_PATH=/usr/bin/google-chrome

# スクリプトのコピー
COPY . .

# シェルをデフォルトのコマンドとして設定
CMD ["/bin/bash"]