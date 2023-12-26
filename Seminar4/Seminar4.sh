###         ###         ### Dockerfile и слои ###           ###         ###         
# Dockerfile - инструкция по созданию образа. В самом начале (первые слои) лучше вставлять аргументы, которые не планируется изменять. Чем выше измененный слой, тем меньше будет дополнительных пересборок
# Инструкции:
# - FROM - задает базовый образ
# - LABEL - добавление метаданных в образ
# - ENV - задает постоянные переменные среды
# - ARG - задание переменных во время сборки образа, можно назначить значение по умолчанию, которое будет меняться или нет
# - RUN - выполнение команды Linux во время сборки образа, создается отдельный слой, состояние слоя фиксируется

# - COPY - копирование файлов и  из локальной подсистемы в рабочую директорию образа, в случае отсутствия создает ее
# - ADD - копирование файлов и папок+распаковка архивов как COPY + добавление файлов из удаленных источников, распаковка tar-файлов

# - WORKDIR - задание рабочей директории для описанных последующих инструкций из dockerfile, лучше указывать абсолютные пути при обращении к файлам, в случае отсутствия директории создает ее
# - CMD - задание команды, выполняющейся при запуске образа. Аргументы, дающиеся в CMD, можно переопределить при запуске. Результат не добавляется в образ во время сборки!
# - ENTRYPOINT - задание команды, выполняющейся при запуске . Аргументы нельзя переопределить
# - EXPOSE - необходимость открытия порта с уже работающим контейнером. это инструкция, сама не открывает
# - VOLUME - указывает место в локальной системе, которое контейнер будет использовать для хранения данных


apt install cowsay
/usr/games/cowsay "Happiness"
nano Dockerfile
# внутри файла пишем:
FROM ubuntu:22.04
RUN apt-get update
RUN apt-get install -y cowsay
RUN ln -s /usr/games/cowsay /usr/bin/cowsay
CMD ["cowsay"]
# ctrl+o enter ctrl+x
docker build -t <название_образа> . # точка указывает, что Dockerfile  находится локально, в текущей директории, где мы находимся
docker run -it cowsaytest bash
ps -aux
hostname
cowsay "hi"
exit
docker run cowsaytest cowsay "woooooooooooow"
docker images
nano Dockerfile
# внутри файла пишем:
FROM ubuntu:22.04
RUN apt-get update && \
    apt-get install -y cowsay && \
    ln -s /usr/games/cowsay /usr/bin/cowsay && \
    rm -rf /var/lib/apt/lists/*
CMD ["cowsay"]
# ctrl+o enter ctrl+x
docker build -t <название_образа> .
docker images

######################
nano Dockerfile
# внутри файла пишем:
FROM ubuntu:22.04
RUN apt update && \
    apt install -y nginx
EXPOSE 80
WORKDIR /var/www
#COPY nginx.conf /etc/nginx/nginx.conf
CMD ["nginx", "-g", "daemon off";]
# ctrl+o enter ctrl+x
docker build -t <название_образа> .
docker run -d -p 8081:80 <название_образа>


