# ===			===			=== Механизм пространства имен ===			===			===			
# Ядро - набор функций, методов,.. чтобы обеспечить исполнение процессов в операционной системе.
# Процесс - запущенная программа, которая работает в определенном контексте и на которую налоожены квоты(ограничения).
# Namespaces - функционал ядра линукс, ограничения со стороны ядра линукс, которые можно навешивать на программы, не дают процессам делать то, на что они не запрограммированы. 
# Ограничения можно накладывать при запуске программы (unshare) или в коде на C на низком уровне.

uname -a # вся информация об ОС

mkdir changeroot # создание нового корневого каталога для смены
# Копируем /bin/bash в новый корневой каталог:
mkdir changeroot/bin/

cp /bin/bash changeroot/bin/

ldd /bin/bash #получить список необходимых зависимостей/библиотек для /bin/bash
#Копируем библиотеки в новый каталог:
mkdir changeroot/lib/
mkdir changeroot/lib64/
cp /lib/x86_64-linux-gnu/libtinfo.so.6 changeroot/lib/
cp /lib/x86_64-linux-gnu/libc.so.6 changeroot/lib/
cp /lib64/ld-linux-x86-64.so.2 changeroot/lib64/
chroot changeroot /bin/bash # меняем корневой каталог 
pid # идентификационный номер процесса 
# для запущенных процессов в системе:
ps # моментальный снимок текущих процессов
top # выводит список всех запущенных процессов в реальном времени, ctrl+c - выход
# Копируем ls в новый корневой каталог:
whereis ls # ищем местоположение ls, чтобы установить в новый корневой каталог
mkdir changeroot/usr
mkdir changeroot/usr/bin
cp /usr/bin/ls changeroot/usr/bin/
ldd /usr/bin/ls
cp /lib/x86_64-linux-gnu/libselinux.so.1 changeroot/lib
cp /lib/x86_64-linux-gnu/libc.so.6 changeroot/lib/
cp /lib/x86_64-linux-gnu/libpcre2-8.so.0 changeroot/lib/
cp /lib64/ld-linux-x86-64.so.2 changeroot/lib64/
chroot changeroot /bin/bash
ls
exit

# Ограничить bash по сети:
ip a
sudo ip netns add <название> # webnamespace, создаем новый сетевой namespace
sudo ip netns list # посмотреть список namespace
sudo ip netns exec webnamespace bash
ip a
# научить общаться с нашей основной системой только по опрделенному сетевому интерфейсу:
# открыть новую вкладку в терминале, зайти в ту же папку: sudo ip link add veth0 type veth peer name veth1
ip a
sudo ip link set veth1 netns webnamespace
ip a
sudo ip addr add 10.0.0.1/24 dev veth0 # задаем адрес
sudo ip link set dev veth0 up # подключаем соединение
ping 10.0.0.1 # проверка
ctrl+c выход
# переходим в предыдущую вкладку терминала(контейнер) с изолированным соединением: 
ip a
sudo ip addr add 10.0.0.2/24 dev veth1 # задаем адрес
sudo ip link set dev veth1 up # подключаем соединение
ip a
ping 10.0.0.2 # проверка
ctrl+c выход
# Закрываем вкладку с изолированным соединением(контейнер)

# Команда unshare команда, позволяющая ограничивать процесс по namespace:
man unshare # мануал
ls -l /proc/$$/ns # где $$ - pid текущего процесса, вывод списка namespace для текущего bash
echo $$
sudo unshare --net /bin/bash
ip a
ls -l /proc/$$/ns # каждый дочерний процесс получает те же ограничения или еще больше
exit
ls -l /proc/$$/ns
sudo unshare --pid --net --fork --mount-proc /bin/bash # ограничения по сети, pid, списку процессов
top # мало процессов, если вызвать top в новой вкладке терминала - много, ctrl+c - выход
ls -l /proc/$$/ns












