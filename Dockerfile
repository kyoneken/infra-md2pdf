FROM alpine:3.19

# システムのアップデートと必要なパッケージのインストール
RUN apk update && apk upgrade && \
    apk add --no-cache \
    multimarkdown \
    chromium \
    nodejs \
    npm \
    fontconfig \
    ttf-liberation \
    && rm -rf /var/cache/apk/*

# Playwrightのインストール
RUN npm init -y && \
    npm install playwright && \
    npx playwright install chromium

# 作業ディレクトリの設定
WORKDIR /app

# スクリプトのコピー
COPY convert_to_pdf.js .

# ENTRYPOINTは指定しない