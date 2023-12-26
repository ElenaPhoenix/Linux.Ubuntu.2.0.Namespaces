###         ###         ### Docker ###          ###         ###         
# Содержит: 
# - образ Docker Image (при работе с Docker запускаются контейнеры, а не образы. Образы нужны для переноса данных между платформами)
# - контейнер Docker Container (собранный проект, запускающийся из образов. Упакованное приложение, которое в дальнейшем будет использоваться . Вместе с приложением упаковывается также среда контейнера. Выполняемый контейнер - запущнный процесс, изолированный от других процессов на выполняемой системе, имеет свои ограничения, если их там сделали)
# - Демон docker daemon (служба, которая управляет docker-объектами: образы, контейнеры, хранилища, сети,... Программная платформа для создания, упаковки, выполнения, распространения приложения)
# - Репозиторий Docker Registry (Репозиторий, где хранятся образы. Напр., Docker Hub, Google Cloud Container Registry)

# Установка по инструкции с Docker Hub
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done # удаление старых версий
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin # Установка последней версии
sudo chmod 666 /var/run/docker.sock
sudo docker run hello-world # тест
############################################################################################
man docker
docker --help # список команд
docker run --help # список флагов к команде

docker --version # посмотреть версию
docker info # инфа о системе
docker images # вывести список образов
docker images -aq # вывести id образов

docker rmi <название_образа> # удаление образа
docker rmi $(docker images -aq) # удаление всех образов
docker rmi $(docker images -aq) --force # удаление всех образов, даже на которые ссылается работающий контейнер

docker pull <название_образа> # скачивание образа без запуска

docker ps -a # вывести список контейнеров
docker ps -q # вывести список id запущенных контейнеров
docker ps -a -q # вывести список всех контейнеров

docker run -it ubuntu:22.04 bash # разворачивание образа в контейнере в интерактивном режиме (не в фоновом) в bash
cd /
ip a
# ! Внутри образа ничего не доустанавливать, чтобы его не поломать, он на это не рассчитан. В нем уже дб всё, что нужно дял работы. Или собрать свой образ
docker run -it -h FirstCont ubuntu:22.04 bash # запуск контейнера в интерактивном режиме 
docker start <id_контейнера> # запуск контейнера в режиме get-touch/background/daemon/фоновом
docker exec -it <id_контейнера> bash # вход в запущенный контейнер
docker stop <id_контейнера> # остановка контейнера
docker volume ls # виртуальное хранилище, "жесткий диск" контейнера

docker rm <название_контейнера> # удалить контейнер
docker system  # информация по занимаемому месту
docker system prune -af # удаление остановленных контейнеров и неиспользуемых образов

# Публикация портов
docker run --publish 8080:80 nginx
ctrl+x # выход

docker run -d --publish 8080:80 nginx # запуск в режиме демона
curl 127.0.0.1:8080 # тест

######################## Установка mysql
docker run --name db_mariadb -e MARIADB_ROOT_PASSWORD=0000 -v ./mydb:/var/lib/mysql -d mariadb:10.10.2
cd mydb/
docker exec -it db_mariadb bash
mysql -u root -p
0000 # пароль
create database my_first_db;
show databases;

######################## Установка phpmyadmin - интерфейс для менеджмента баз данных
docker run --name db_phpmyadmin --link db_mariadb:db -p 8081:80 -d phpmyadmin/phpmyadmin
docker ps
# можно посмотреть результат, открыв вкладку в веб-браузере: http://localhost:8081/     root 0000