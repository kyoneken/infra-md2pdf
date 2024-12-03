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

# nonrootユーザーとグループの作成
RUN groupadd -g 1100 nonroot && \
    useradd -u 1100 -g nonroot -s /bin/bash -m -d /home/nonroot nonroot

    # アプリケーションディレクトリの作成と権限設定
RUN mkdir -p /app && \
    chown -R nonroot:nonroot /app && \
    chmod -R 777 /app

# Playwrightのグローバルインストールディレクトリを作成し、権限を設定
RUN mkdir -p /home/nonroot/.cache/ms-playwright && \
    mkdir -p /home/nonroot/.npm && \
    mkdir -p /usr/local/share/.cache/ms-playwright && \
    chmod -R 777 /usr/local/share/.cache/ms-playwright && \
    chown -R nonroot:nonroot /home/nonroot

# 作業ディレクトリの設定
WORKDIR /app

# Playwrightのインストールと設定（Chromeを含む）
RUN npm init -y && \
    npm install playwright@latest && \
    PLAYWRIGHT_BROWSERS_PATH=/usr/local/share/.cache/ms-playwright \
    npx playwright install --with-deps chromium && \
    chown -R nonroot:nonroot /app /home/nonroot/.cache /home/nonroot/.npm /usr/local/share/.cache/ms-playwright

# 環境変数の設定
ENV PLAYWRIGHT_BROWSERS_PATH=/usr/local/share/.cache/ms-playwright
ENV npm_config_cache=/home/nonroot/.npm

# nonrootユーザーに切り替え
USER nonroot

# スクリプトのコピー
COPY . .

# シェルをデフォルトのコマンドとして設定
CMD ["/bin/bash"]