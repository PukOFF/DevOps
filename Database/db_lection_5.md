# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

---
```bash
lex@userver:~/DevOps/Docker$ cat docker-compose.yml
version: '3'
services:
    elasticsearch:
        image: elasticsearch:7.17.5
        container_name: elasticsearch
        user: elasticsearch
        restart: unless-stopped
        ports:
          - 9200:9200
          - 9300:9300
        volumes:
                - elastic:/var/lib/elasticsearch/data
        environment:
          - node.name=netology-test
          - path.data=/var/lib/elasticsearch/data
          - discovery.type=single-node
          - xpack.security.enabled=false
          - "ES_JAVA_OPTS=-Xms1g -Xmx1g"
volumes:
  elastic:
```

[Docker Hub link] (https://hub.docker.com/repository/docker/pukoff/elasticsearch)

---


## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

---

```bash
elasticsearch@45b4069da7f1:~$ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases Kdnc9tIiRi-SK8TBTAmeRg   1   0         40            0     37.7mb         37.7mb
green  open   ind-1            xoPJ_qzOTwCelOOpHvvzGA   1   0          0            0       226b           226b
yellow open   ind-3            yAH6NfWNRAK_BLkZAHopww   4   2          0            0       904b           904b
yellow open   ind-2            UIb5KXchTDeNI9_PbeS5eg   2   1          0            0       452b           452b
elasticsearch@45b4069da7f1:~$
```

```bash
elasticsearch@45b4069da7f1:~$ curl -X GET 'http://localhost:9200/_cluster/health/ind-1?pretty'
{
  "cluster_name" : "docker-cluster",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 1,
  "active_shards" : 1,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}
elasticsearch@45b4069da7f1:~$ curl -X GET 'http://localhost:9200/_cluster/health/ind-2?pretty'
{
  "cluster_name" : "docker-cluster",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 2,
  "active_shards" : 2,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 2,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 44.44444444444444
}
elasticsearch@45b4069da7f1:~$ curl -X GET 'http://localhost:9200/_cluster/health/ind-3?pretty'
{
  "cluster_name" : "docker-cluster",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 4,
  "active_shards" : 4,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 8,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 44.44444444444444
}
elasticsearch@45b4069da7f1:~$

```
---

Получите состояние кластера `elasticsearch`, используя API.
```bash
elasticsearch@45b4069da7f1:~$ curl -X GET http://localhost:9200/_cluster/health/?pretty=true
{
  "cluster_name" : "docker-cluster",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 8,
  "active_shards" : 8,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 44.44444444444444
}

```


Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Так как отсуствуют другие сервера, но при это указано количество реплик.

Удалите все индексы.

```bash
elasticsearch@45b4069da7f1:~$ curl -X DELETE localhost:9200/ind-1
{"acknowledged":true}
elasticsearch@45b4069da7f1:~$ curl -X DELETE localhost:9200/ind-2
{"acknowledged":true}
elasticsearch@45b4069da7f1:~$ curl -X DELETE localhost:9200/ind-3
{"acknowledged":true}
elasticsearch@45b4069da7f1:~$

```
---


**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

**Запрос**
POST http://hostname:9200/_snapshot/netology_backup

```json
{
  "type": "fs",
  "settings": {
    "location": "/usr/share/elasticsearch/snapshots"
  }
}
```

**Ответ***
```json
{
	"netology_backup": {
		"type": "fs",
		"settings": {
			"location": "/usr/share/elasticsearch/snapshots"
		}
	}
}
```

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

---

**Запрос**

PUT http://hostname:9200/test
```json
{ "settings":
 { 
	 "number_of_shards": 1,  
	 "number_of_replicas": 0 
 }
}
```


**Ответ**
```json
{
  "test" : {
    "aliases" : { },
    "mappings" : { },
    "settings" : {
      "index" : {
        "routing" : {
          "allocation" : {
            "include" : {
              "_tier_preference" : "data_content"
            }
          }
        },
        "number_of_shards" : "1",
        "provided_name" : "test",
        "creation_date" : "1658337224088",
        "number_of_replicas" : "0",
        "uuid" : "EO81Q-yBTYOljqbOW7nQvg",
        "version" : {
          "created" : "7170599"
        }
      }
    }
  }
}

health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases Kdnc9tIiRi-SK8TBTAmeRg   1   0         40            0     37.7mb         37.7mb
green  open   test             84waBErQQLq-9G98asjlWw   1   0          0            0       226b           226b
```
---

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Запрос**
PUT http://localhost:9200/_snapshot/netology_backup/elasticsearch?wait_for_completion=true

**Ответ**

```json
{
	"snapshot": {
		"snapshot": "elasticsearch",
		"uuid": "8tpYYrtCTqa0QcXqM6Dp2A",
		"repository": "netology_backup",
		"version_id": 7170599,
		"version": "7.17.5",
		"indices": [
			".ds-ilm-history-5-2022.07.20-000001",
			".geoip_databases",
			".ds-.logs-deprecation.elasticsearch-default-2022.07.20-000001",
			"test"
		],
		"data_streams": [
			"ilm-history-5",
			".logs-deprecation.elasticsearch-default"
		],
		"include_global_state": true,
		"state": "SUCCESS",
		"start_time": "2022-07-20T18:49:33.915Z",
		"start_time_in_millis": 1658342973915,
		"end_time": "2022-07-20T18:49:35.567Z",
		"end_time_in_millis": 1658342975567,
		"duration_in_millis": 1652,
		"failures": [],
		"shards": {
			"total": 4,
			"failed": 0,
			"successful": 4
		},
		"feature_states": [
			{
				"feature_name": "geoip",
				"indices": [
					".geoip_databases"
				]
			}
		]
	}
}
```

PUT http://localhost:9200/_snapshot/baskup_repo/elasticsearch
---

**Приведите в ответе** список файлов в директории со `snapshot`ами.

```bash
root@701385f9c9bd:/usr/share/elasticsearch/snapshots# ls -l
total 48
-rw-rw-r-- 1 elasticsearch root  1425 Jul 20 18:49 index-4
-rw-rw-r-- 1 elasticsearch root     8 Jul 20 18:49 index.latest
drwxrwxr-x 6 elasticsearch root  4096 Jul 20 18:49 indices
-rw-rw-r-- 1 elasticsearch root 29292 Jul 20 18:49 meta-8tpYYrtCTqa0QcXqM6Dp2A.dat
-rw-rw-r-- 1 elasticsearch root   712 Jul 20 18:49 snap-8tpYYrtCTqa0QcXqM6Dp2A.dat
root@701385f9c9bd:/usr/share/elasticsearch/snapshots#

```

---

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

```json
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases Kdnc9tIiRi-SK8TBTAmeRg   1   0         40            0     37.7mb         37.7mb
```

**Запрос**
PUT http://localhost:9200/test-2

```json
{ "settings": 
 { 
	 "number_of_shards": 1,  
	 "number_of_replicas": 0 
 }
}
```

**Ответ**
```json
{
	"acknowledged": true,
	"shards_acknowledged": true,
	"index": "test-2"
}

health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases Kdnc9tIiRi-SK8TBTAmeRg   1   0         40            0     37.7mb         37.7mb
green  open   test-2           Brmi8VUJTKShSTGoJxqZyg   1   0          0            0       226b           226b
```

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

**Запрос**
POST http://localhost:9200/_snapshot/netology_backup/elasticsearch/_restore?pretty

```json
{
	"indices":"test",
	"include_global_state":true
}
```

**Ответ**
```json
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2           Brmi8VUJTKShSTGoJxqZyg   1   0          0            0       226b           226b
green  open   .geoip_databases cb-19TqVT5uUjOROw2hzXA   1   0         40            0     37.7mb         37.7mb
green  open   test             kp-DQOg9Qt2r6-_FcqITKg   1   0          0            0       226b           226b
```

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

---