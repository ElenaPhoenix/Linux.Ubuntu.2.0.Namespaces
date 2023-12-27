###             ###             ### Docker Compose и Docker Swarm ###           ###             ###             
# Docker Compose - управляет несколькими контейнерами из 1 YAML-файла, решает задачи по развертыванию сложных проектов

docker run --name newsql1 -e MYSQL_ROOT_PASSWORD=0000 -d mysql:8.0.31
docker ps
docker run --name newphp1 -d --link newsql1:db -p 8081:80 phpmyadmin/phpmyadmin
ps

# YAML - язык для сериализации данных. Позволяет хранить сложноорганизованные данные в компактном и читаемом формате. 
nano example.YAML
# внутри:
first_name: Elena
last_name: Phoenix

animals:
  cat:
    name: Pusik
    age: 1-year
  dog:
    name: Charles
    age: 1-year
# ctrl+o enter ctrl+x
#####
nano project.YAML
# внутри:
version: '3.9' # Docker Compose

services:

  db: # описывает название сервиса, который будет запущен, можно придумать любое название
    # build: ./db # build - ключевое слово, которое позволяет задать путь к Dockerfile, который будет использован для создания нашего образа, если захотим его создать
    image: mariadb:10.10.2 # указывается образ, который будет использоваться. будет по умолчанию скачиваться с Docker Hub
    restart: always # позволяет определить политику перезапуска контейнера. Варианты: no, restart no, (пустая ячейка), on failure, always, unless stoped
    environment: # прописываем переменные, которые могут быть использованы для работы того или иного контейнера
      MYSQL_ROOT_PASSWORD: 0000

  adminer:
    image: adminer:4.8.1
    restart: always
    port:
      - 6080:8080
# ctrl+o enter ctrl+x
####3
docker-compose up -d
docker ps
docker container inspect root_adminer_1
docker container inspect root_db_1
#тест на вебе
...
docker-compose stop
docker-compose start
docker-compose logs
docker-compose down
docker ps -a
#####
nano project.YAML
# внутри:
version: '3.9' # версия Docker Compose, как ведут себя директивы в этом файле

services:

  db: # название контейнера, который будет запущен, можно придумать любое название
    build: # build - ключевое слово, которое позволяет задать путь к Dockerfile, который будет использован для создания нашего образа, если захотим его создать
      dockerfile: ./Dockerfile # можно сразу собрать контейнер из Dockerfile без предварительного создания образа
    environment: # прописываем переменные, которые могут быть использованы для работы того или иного контейнера
      MYSQL_ROOT_PASSWORD: 0000
    deploy: # указывает, сколько реплик запустим одновременно
      mode: replicated
      replicas: 2

  adminer:
    image: adminer:4.8.1
    restart: always # если контейнер упадет, на каких условиях произойдет перезапуск
    ports:
      - 6080:8080
    volumes:
      - ./myfolder:/myfolder
    deploy:
      mode: replicated
      replicas: 1
# ctrl+o enter ctrl+x
#####
nano project.YAML
# внутри:
version: '3'

services:

  db:
    image: mysql:8.0
    container_name: db
    restart: unless-stopped
    env_file: .env
    environment:
      - MYSQL_DATABASE=wordpress
    volumes:
      - dbdata:/var/lib/mysql
    command: '--default-authentication-plugin=mysql_native_password'
    networks:
      - app.network2

  wordpress:
    depends_on:
      - db
    image: wordpress:6.0.1-php8.0-fpm-alpine
    container_name: wordpress
    restart: unless-stopped
    env_file: .env
    environment:
      - WORDPRESS_DB_HOST=db:3306
      - WORDPRESS_DB_USER=$MYSQL_USER
      - WORDPRESS_DB_PASSWORD=$MYSQL_PASSWORD
      - WORDPRESS_DB_NAME=wordpress
    volumes:
      - wordpress:/var/www/html
    networks:
      - app-network
      - app-network2

  webserver:
    depends_on:
      - wordpress
    image: nginx:1.22.0-alpine
    container_name: webserver
    restart: unless-stopped
    ports: 
      - "80:80"
    volumes:
      - wordpress:/var/www/html
      - ./nginx-conf:/etc/nginx/conf.d
    networks:
      - app-network
volumes:
  wordpress:
  dbdata:

networks:
  app-network:
    driver: bridge
  app-network2:
    driver: bridge
# ctrl+o enter ctrl+x
docker-compose down
docker-compose up

######
version: '3.8'

services:

  db:
    image: mariadb:10.10.2
    environment:
      MYSQL_ROOT_PASSWORD: 0000
    volumes:
      - /home/elena/mydb1
    deploy:
      mode: replicated
      replicas: 2

  adminer:
    image: adminer:4.8.1
    restart: always
    ports:
      - 6080:8080
    volumes:
      - /home/elena/dumps:/dumps
    deploy:
      mode: replicated
      replicas: 1


# Оркестрация контейнеров - централизованное и эффективное управление, мониторинг контейнеров
# Оркестратор (инструмент оркестрации). Ключевые элементы: развертывание (с помощью манифестов), масштабирование, надежность
docker-compose build # позволяет собрать сервисы, описанные в конфигурационных файлах
docker-compose up # деплоит, запускает проект
docker-compose up -d # ... в фоновом режиме
docker run -d # =
docker-compose start # запускает любые ранее остановленные сервисы в соответствии с параметрами указанными в манифесте
docker-compose stop # останавливает все сервисы, описанные в конфигурации. никакие ранее созданные сущности не удаляет
docker-compose down # останавливает проект, удаляет все сущности, запущенные ранее, которые были необходимы для этого проекта
docker-compose logs -f <service_name> # позволяет собрать логи запущенного нами сервиса
docker-compose exec # позволяет выполнить команду в сервисе, не заходя внутрь контейнера
docker-compose images # выводит список образов, которые будут доступны в конфигурационном файле

####################### 
# Docker Swarm - отказоустойчивость, увеличение ресурсов
# Node (нода) - наш сервер с установленным на нем Docker. Нодой мб физические сервера и виртуальные машины
# Компоненты: stack - набор сервисов, которые мб связаны м/у собой логически; сервис - составляющая стэка; task (задача) - непосредственно созданный контейнер
docker swarm init # нода инициализируется как кластер. В кластер можно зайти только с другой машины, там в терминале ввести строку, которую первый DS сказал сделать 
docker node ls # на первой, хостовой машине пишем. входим в кластер
docker node update --label-and <название_ноды> <id_ноды> # назвначаем имя ноде
docker service create --name nginx --label <название_ноды> --replicas 3 nginx:alpine; # если на хосте на текущий момент не открыт nginx:alpine, то одна реплика останется на хосте
docker network create --driver overlay --subnet 4.5.6.0/24 test-network-my-db-1 --attachable # создание сети на мастер-ноде
docker run -d --ip 4.5.6.7 --net test-network-my-gb-1 --name container-my-gb-123 busybox sleep 3600 # запуск на хостовой машине
docker ps
docker exec -it <id_спящего контейнера> sh
docker run -d --ip 4.5.6.8 --net test-network-my-gb-1 --name container-2345 busybox sleep 3600 # запуск на ноде
# далее подсоединиться к контейнеру внутри вирт.машины и пропинговать предыдущий ip

###             ###             ### Overlay сети ###            ###             ###             
# Overlay создает простую подсеть, которая мб использована контейнерами на разных хостах swarm-кластера
# ingress - тип сети используется в docker swarm по умолчанию при создании кластера. Отвечает за связи, которые устанавливаются между контейнерами и внешним миром
# vxlan - при использовании этого типа сетей происходит инкапсуляция пакетов 2 слоя модели OSi в четвертый
# docker_gwbridge - эта сеть создается на каждом узле кластера. Позволяет соединить трафик из контейнеров , находящихся внутри docker swarm кластера с внешним миром
docker network ls
docker network create --driver overlay --subnet 4.5.6.0/24 test-network attachable



