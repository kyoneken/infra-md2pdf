FROM alpine:3.20

# 必要なパッケージのインストール
RUN apk add --no-cache \
    multimarkdown \
    chromium \
    nodejs \
    npm \
    fontconfig \
    ttf-freefont

# Playwrightのインストール
RUN npm init -y && \
    npm install playwright && \
    npx playwright install chromium

# 作業ディレクトリの設定
WORKDIR /app

# スクリプトのコピー
COPY convert_to_pdf.js .

# ENTRYPOINTは指定しない
