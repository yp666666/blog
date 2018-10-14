---
title: elasticsearch
date: 2018-10-10 09:34:33
category:
tags: elasticsearch
---
## install es and plugins
[elasticsearch-6.4.1 download](https://www.elastic.co/downloads)
plugin: 
[analysis-smartcn](https://www.elastic.co/guide/en/elasticsearch/plugins/6.0/analysis-smartcn.html) (eg: ./bin/elasticsearch-plugin install analysis-smartcn)
[ik](https://github.com/medcl/elasticsearch-analysis-ik)

then start es: bin/elasticsearch

## surfing
### 验证分词器是否生效
```sh
curl --request POST \
  --url http://localhost:9200/_analyze \
  --header 'Content-Type: application/json'  -d \
'{
    "analyzer": "pinyin",
    "text": "小明"
}'
```
### hibernate-search-elasticsearch
[code](https://github.com/carl-zk/JavaJava/tree/master/search-service)

### config index and mapping
1. 设置analyzer
```sh
curl --request PUT \
  --url http://localhost:9200/com.wework.entity.company -d \
'{
    "index": {
        "analysis": {
        "analyzer": {
            "pinyin_analyzer": {
                "tokenizer": "my_pinyin"
            }
        },
        "tokenizer": {
            "my_pinyin": {
                "type": "pinyin",
                "keep_separate_first_letter" : false,
                "keep_full_pinyin" : true,
                "keep_original" : true,
                "limit_first_letter_length" : 16,
                "lowercase" : true,
                "remove_duplicated_term" : true
                }
            }
        }
    }
}'
```
2. 设置mapping
```sh
curl --request PUT \
  --url http://localhost:9200/com.wework.entity.company/_mapping/com.wework.entity.Company -d \
'{
    "properties": {
        "name": {
            "type": "text",
            "analyzer": "ik_smart",
            "fields": {
                "pinyin": {
                    "type": "text",
                    "store": false,
                    "term_vector": "with_offsets",
                    "analyzer": "pinyin_analyzer",
                    "boost": 10
                },
                "keyword": {
                    "type": "keyword",
                    "ignore_above": 256
                }
            }
        }
    }
}'
```
3. 查看mapping
```sh
curl --request GET \
  --url http://localhost:9200/com.wework.entity.user/_mapping \
```
4. 搜索
```sh
curl --request POST \
  --url 'http://localhost:9200/com.wework.entity.user/_search?pretty=' -d \
'{
    "query": {
        "match": {
            "name.pinyin": "xiao明"
        }
    },
    "from": 0,
    "size": 10,
    "sort": ["_score"]
}'
```

