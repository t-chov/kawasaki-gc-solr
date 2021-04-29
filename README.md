# kawasaki-gc-solr

川崎市のゴミ分別を検索するための全文検索エンジン

## 必要なもの

- Docker
  - または Apache Solr

## 起動方法(Docker build 中にインデクシングまでやります)

```shell
$ docker build -t kawasaki-gc-solr .
$ docker run --rm -p 8983:8983 kawasaki-gc-solr:latest solr-fg
```

## やっていること

1. [川崎市のサイト](https://www.city.kawasaki.jp/300/page/0000075059.html) からゴミ分別の CSV をダウンロードする
2. CSV を UTF-8, LF に変換し、1 行目を下記のものに変換
   - `id,head_letter,name,ruby,synonyms,general_type,detailed_type,description,url1`
3. curl で送信
   - `curl -XPOST -H'Content-Type:application/csv' 'http://localhost:8983/solr/kawasaki-gc/update?commit=true&f.synonyms.split=true&f.synonyms.separator=%20' --data-binary @garbage.csv`

## 確認方法

http://localhost:8983/solr

で確認

## TODO

- [ ] highlighting してシノニムへのヒットを表示する
- [ ] API の説明
