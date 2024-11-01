# SyoDon-V

ミニマルなActivityPub実装(を作れたら良いな、なプロジェクト)です。

## ビルド時依存

- V
- sqlite3

```sh
v install markdown
```

## ビルド

```sh
v ./compile_json.vsh
v -prod .
```

### ビルドオプション

- `-d httpsig=cavage`: cavage版のHTTP Signatureを使用します
- `-d httpsig=rfc9421`: RFC9421準拠のHTTP Signatureを使用します
- `-d httpsig=hybrid`: 両方で解釈できるようなヘッダを送信します
