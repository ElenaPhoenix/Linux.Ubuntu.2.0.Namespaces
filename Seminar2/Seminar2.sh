###         ###         ### cgroup (контрольные группы) - механизм для иерархической организации процессов и распределения ###          ###         ###         
# системных ресурсов
# LXC подсистема контейнеризации. Позволяет запускать несколько изолированных друг от друга экземпляров ОС Линукс на одном узле.
# Не использует виртуализацию, создает вирт.окружение с собственным пространством процессов и собственным сетевым стеком
sudo apt install cgroup-tools -y

#Установка lxc, развертывание контейнера, ограничить его по оперативной памяти
sudo apt install lxc debootstrap bridge-utils lxc-templates -y # установка lxc
sudo lxc-create -n test-elena-1 -t ubuntu # Тип ОС дб как у хостовой машины !!! Будет большой вес!!
sudo lxc-start -n test-elena-1
sudo lxc-attach -n test-elena-1 # зайти внутрь контейнера
cd /
ls -l # просмотр всех файлов контейнера
free -m # посмотреть сколько в наличии оперативной памяти доступно
exit
sudo lxc-cgroup -n test-elena-1 memory.max 256M #назначаем контейнеру сколько оперативной памяти будет использоваться
# The default user is 'ubuntu' with password 'ubuntu'!
# Use the 'sudo' command to run tasks as root in the container.
sudo lxc-attach -n test-elena-1 # lxc-контейнера у многих не работают
free -m