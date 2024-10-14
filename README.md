# infra-md2pdf

## Usage

1. ビルド&コンテナ起動

```
docker build -t markdown-pdf-converter .
docker run -it --rm -v $(pwd)/test-files:/app/test-files markdown-pdf-converter
```

2. Markdown to HTML(コンテナ内)

```
multimarkdown test-files/sample1.md -o output/sample1.html
multimarkdown test-files/sample2.md -o output/sample2.html
```

3. HTML to PDF(コンテナ内)

```
node convert_to_pdf.js ./output output/*
```