# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    {
        "info": "Sample JSON output from our service\t",
        "elements": [
            {
                "name": "first",
                "type": "server",
                "ip": "71.75" 
            }
            { 
                "name": "second",
                "type": "proxy",
                "ip": "71.78.22.43"
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
import socket
import os
import pickle
import json
import yaml

def check_dns(hosts):
    dictionary = {}
    for hostname in hosts:
        dictionary[hostname] = socket.gethostbyname(hostname)
    return(dictionary)

def write_to_pickle(data, filename):
    with open(filename,'wb') as f:
        pickle.dump(data, f)

def write_to_json(data, filename):
    with open(filename,'w') as js:
        js.write(json.dumps(data))

def write_to_yaml(data, filename):
    with open(filename,'w') as ym:
        ym.write(yaml.dump(data, default_flow_style=False))

def read_from_file():
    with open('data.pickle','rb') as f:
        data = pickle.load(f)
        return data

def delimeter():
    print("="*50)

SITES = ("drive.google.com", "mail.google.com", "google.com")
PICKLE_FILE = "data.pickle"
JSON_FILE = "data.json"
YAML_FILE = "data.yml"


delimeter()

if os.path.isfile(PICKLE_FILE):

    old_dict = read_from_file()
    new_dict = check_dns(SITES)

    for host in SITES:
        if old_dict[host] == new_dict[host]:
            print('{:>11} {:>0} - {:>10}'.format("",host, old_dict[host]))
        else:
            print('[ERROR] {:>20} IP mismatch [OLD]: {:>10} [NEW]: {:>10}'.format(host, old_dict[host], new_dict[host]))
            write_to_json(new_dict, 'data.json')
            write_to_yaml(new_dict, 'data.yaml')
    delimeter()
else:
    temp = check_dns(SITES)
    print(temp)
    write_to_pickle(temp, PICKLE_FILE)
    print("File 'data.pickle' is created.")
    print("This file is template fo tests")
```

### Вывод скрипта при запуске при тестировании:
```bash
alex@AlexPC:~/GitHub/DevOps/Linux$ python3 netology.py 
==================================================
{'drive.google.com': '108.177.14.194', 'mail.google.com': '74.125.131.18', 'google.com': '74.125.131.113'}
File 'data.pickle' is created.
This file is template fo tests
alex@AlexPC:~/GitHub/DevOps/Linux$ python3 netology.py 
==================================================
            drive.google.com - 108.177.14.194
[ERROR]      mail.google.com IP mismatch [OLD]: 74.125.131.18 [NEW]: 74.125.131.17
[ERROR]           google.com IP mismatch [OLD]: 74.125.131.113 [NEW]: 74.125.131.100
==================================================
alex@AlexPC:~/GitHub/DevOps/Linux$ 
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
{"drive.google.com": "108.177.14.194", "mail.google.com": "74.125.131.17", "google.com": "74.125.131.101"}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
drive.google.com: 108.177.14.194
google.com: 74.125.131.101
mail.google.com: 74.125.131.17
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так как команды в нашей компании никак не могут прийти к единому мнению о том, какой формат разметки данных использовать: JSON или YAML, нам нужно реализовать парсер из одного формата в другой. Он должен уметь:
   * Принимать на вход имя файла
   * Проверять формат исходного файла. Если файл не json или yml - скрипт должен остановить свою работу
   * Распознавать какой формат данных в файле. Считается, что файлы *.json и *.yml могут быть перепутаны
   * Перекодировать данные из исходного формата во второй доступный (из JSON в YAML, из YAML в JSON)
   * При обнаружении ошибки в исходном файле - указать в стандартном выводе строку с ошибкой синтаксиса и её номер
   * Полученный файл должен иметь имя исходного файла, разница в наименовании обеспечивается разницей расширения файлов

### Ваш скрипт:
```python
???
```

### Пример работы скрипта:
???