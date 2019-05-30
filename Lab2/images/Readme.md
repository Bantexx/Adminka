# Лабораторная работа №2
## Задание 1 (Установка ОС и настройка LVM, RAID)
1. Создание новой виртуальной машины, выдав ей следующие характеристики:
* 1 gb ram
* 1 cpu
* 2 hdd (назвав их ssd1, ssd2 и назначил равный размер, поставив галочки hot swap и ssd)
* SATA контроллер настроен на 4 порта
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/1stTask/beginSettings.PNG)
2. Начало установки Linux:
* Настройка отдельного раздела под /boot: Выбрав первый диск, создал на нем новую таблицу разделов
    + Partition size: 512M
    + Mount point: /boot
    + Повторил настройки для второго диска, выбрав mount point:none
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/1stTask/VirtualBox_MyNewLinuxd_24_05_2019_17_32_09.png)
* Настройка RAID
    + Выбрал свободное место на первом диске и настроил в качестве типа раздела physical volume for RAID
    + Выбрал "Done setting up the partition"
    + Повторил настройку для второго диска
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/1stTask/RazdelDiskov.PNG)
* Выбрал пункт "Configure software RAID"
    + Create MD device
    + Software RAID device type: Выберал зеркальный массив
    + Active devices for the RAID XXXX array: Выбрал оба диска
    + Spare devices: Оставил 0 по умолчанию
    + Active devices for the RAID XX array: Выбрал разделы, которые создавал под raid
    + Finish
* Настройка LVM: Выбрал Configure the Logical Volume Manager
    + Keep current partition layout and configure LVM: Yes
    + Create volume group
    + Volume group name: system
    + Devices for the new volume group: Выбрал созданный RAID
    + Create logical volume
    + logical volume name: root
    + logical volume size: 2\5 от размера диска
    + Create logical volume
    + logical volume name: var
    + logical volume size: 2\5 от размера диска
    + Create logical volume
    + logical volume name: log
    + logical volume size: 1\5 от размера диска
    + Завершив настройку LVM увидел следующее:
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/1stTask/LVM.png)
* Разметка разделов: по-очереди выбрал каждый созданный в LVM том и разметил их, например, для root так:
    + Use as: ext4
    + mount point: /
    + повторил операцию разметки для var и log выбрав соответствующие точки монтирования (/var и /var/log), получив следующий результат:
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/1stTask/RazmetkaRazdelov%20LVM.png)
* Финальный результат получился вот таким:
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/1stTask/VirtualBox_os_24_05_2019_18_05_49.png)
3. Закончил установку ОС, поставив grub на первое устройство (sda) и загрузил систему.
4. Выполнил копирование содержимого раздела /boot с диска sda (ssd1) на диск sdb (ssd2)
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/1stTask/Perenosrazdelov.PNG)
5. Выполнил установку grub на второе устройство:

     ![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/1stTask/Grub-instal.PNG)
* Результат команды fdisk -l:
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/1stTask/fdisk-l.png)
* Посмотрел информацию о текущем raid командой cat /proc/mdstat:
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/1stTask/cat%20proct.png)
Увидел, что активны два raid1 sda2[0] и sdb2[1]
* Выводы команд: pvs, vgs, lvs, mount:
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/1stTask/pvs%2Clvs.PNG)
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/1stTask/mount.png)
* С помощью этих команд увидел информацию об physical volumes, volume groups, logical volumes, примонтированных устройств.
## Вывод
В этом задании научился устанавливать ОС Linux, настраивать LVM и RAID, а также ознакомился с командами:
 * lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT
 * fdisk -l
 * pvs,lvs,vgs
 * cat /proc/mdstat
 * mount
 * dd if=/dev/xxx of=/dev/yyy
 * grub-install /dev/XXX 
* В результате получил виртуальную машину с дисками ssd1, ssd2.
# Задание 2 (Эмуляция отказа одного из дисков)
1. Удаление диска ssd1 в свойствах машины, проверка работоспособности виртуальной машины.
2. Проверка статуса RAID-массива cat /proc/mdstat
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/2ndTask/CheckRaid.PNG)
3. Добавление в интерфейсе VM нового диска такого же размера с названием ssd3
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/2ndTask/CheckDisks.PNG)
4. Выполнение операций:
* Просмотр нового диска, что он приехал в систему командой fdisk -l
* Копирование таблиц разделов со старого диска на новый: sfdisk -d /dev/XXXX | sfdisk /dev/YYY
* Результат
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/2ndTask/add_newdisk.png)
* Добавление в рейд массив нового диска: mdadm --manage /dev/md0 --add /dev/YYY
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/2ndTask/add_Raid.png)
* Результат cat /proc/mdstat
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/2ndTask/add_Raid.png)
5. Выполение синхронизации разделов, не входящих в RAID
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/2ndTask/Information%20about%20raid.png)
6. Установка grub на новый диск
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/2ndTask/Information%20about%20raid.png)
7. Перезагрузка ВМ и проверка, что все работает
## Вывод
В этом задании научился:
* Удалять диск ssd1
* Проверять статус RAID-массива
* Копировать таблицу разделов со старого диска на новый
* Добавлять в рейд массив новый диск
* Выполнять синхронизацию разделов, не входящих в RAID

Изучил новые команды:
* sfdisk -d /dev/XXXX | sfdisk /dev/YYY
* mdadm --manage /dev/md0 --add /dev/YYY

Результат: Удален диск ssd1, добавлен диск ssd3, ssd2 сохранили
# Задание 3 (Добавление новых дисков и перенос раздела)
1. Эмулирование отказа диска ssd2 и просмотр состояние дисков RAID
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/2ndTask/lsblk(new).png)
2. Добавление нового ssd диска
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/2ndTask/add_newdisk.png)
3. Перенос данных с помощью LVM
* Копирование файловую таблицу со старого диска на новый
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/2ndTask/sfdiskfornewdisk.png)
* Копирование данных /boot на новый диск
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/2ndTask/copyboot.png)
* Перемонтировака /boot на живой диск
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/2ndTask/switchboottonew.png)
* Установка grub на новый диск
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/1stTask/Grub-instal.PNG)

Grub устанавливаем, чтобы могли загрузить ОС с этого диска
* Создание нового RAID-массива с включением туда только одного нового ssd диска:
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/createraidmd63.png)
* Проверка результата
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/CheckNewRaids.png)

Появился /dev/md63

4. Настройка LVM
* Выполнение команды pvs для просмотра информации о текущих физических томах
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/pvsnew.png)
* Создание нового физического тома, включив в него ранее созданный RAID массив:
* Выполнение команд lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT и pvs
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/pvsnew.png)

К md63 добавился FSTYPE - LVM2_member, так же dev/md63 добавился к результату команды pvs
* Увеличение размера Volume Group system
* Выполнение команд
```
vgdisplay system -v
pvs
vgs
lvs -a -o+devices
```
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/vgdisplay%20system-v.png)
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/commandaftevgeextned.png)

LV var,log,root находятся на /dev/md0
* Перемещение данных со старого диска на новый
* Выполнение команд:
```
vgdisplay system -v
pvs
vgs
lvs -a -o+devices
lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT
```
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/VirtualBox_MyNewLinuxd_24_05_2019_20_50_59.png)
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/VirtualBox_MyNewLinuxd_24_05_2019_20_51_19.png)
* Изменение VG, удалив из него диск старого raid.
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/VirtualBox_MyNewLinuxd_24_05_2019_20_53_01.png)
В выводе команды pvs у /dev/md0 исчезли VG и Attr.
В выводе команды vgs #PV - уменьшилось на 1, VSize, VFree - стали меньше
* Перемонтировка /boot на второй диск, проверка, что boot не пустой
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/VirtualBox_MyNewLinuxd_24_05_2019_20_53_01.png)
5. Удаление ssd3 и добавление ssd5,hdd1,hdd2
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/VirtualBox_MyNewLinuxd_24_05_2019_21_10_27.png)

6. Восстановление работы основного RAID массива:
* Копирование таблицы разделов:
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/VirtualBox_MyNewLinuxd_24_05_2019_21_10_56.png)
7. Копирование загрузочного раздела /boot с диска ssd4 на ssd5
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/VirtualBox_MyNewLinuxd_24_05_2019_21_10_27.png)
8. Установка grub на ssd5
9. Изменение размера второго раздела диска ssd5
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/VirtualBox_MyNewLinuxd_24_05_2019_21_10_56.png)
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/VirtualBox_MyNewLinuxd_24_05_2019_21_15_26.png)
10. Перечитывание таблицы разделов
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/VirtualBox_MyNewLinuxd_24_05_2019_21_24_54.png)
* Добавление нового диска к текущему raid массиву
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/AddRaidoSda2.png)
* Расширение количество дисков в массиве до 2-х штук:
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/VirtualBox_MyNewLinuxd_24_05_2019_21_33_04.png)
11. Увеличение размера раздела на диске ssd4
* Запуск утилиты для работы с разметкой дисков
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/VirtualBox_MyNewLinuxd_24_05_2019_21_35_16.png)
12. Перечитаем таблицу разделов
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/VirtualBox_MyNewLinuxd_24_05_2019_21_35_16.png)
13. Расширение размера raid
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/VirtualBox_MyNewLinuxd_24_05_2019_21_36_27.png)

Размер md127 стал 7.5G
* Вывод команды pvs
* Расширение размера PV
* Вывод команды pvs
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/VirtualBox_MyNewLinuxd_24_05_2019_21_38_34.png)
14. Добавление вновь появившееся место VG var,root
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/VirtualBox_MyNewLinuxd_24_05_2019_21_38_34.png)
15. Перемещение /var/log на новые диски
* Посмотрел какие имена имеют новые hhd диски
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/VirtualBox_MyNewLinuxd_24_05_2019_21_39_34.png)
* Создание RAID массива
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/VirtualBox_MyNewLinuxd_24_05_2019_21_45_38.png)
* Создание нового PV на рейде из больших дисков
* Создание в этом PV группу с названием data
* Создание логического тома с размером всего свободного пространства и присвоением ему имени var_log
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/VirtualBox_MyNewLinuxd_24_05_2019_21_45_59.png)
* Отформатирование созданного раздела в ext4
![alt-текст](hhttps://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/VirtualBox_MyNewLinuxd_24_05_2019_21_46_54.png)
16. Перенос данных логов со старого раздела на новый
* Примонтирование временно нового хранилище логов
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/VirtualBox_MyNewLinuxd_24_05_2019_21_51_41.png)
* Выполнение синхронизации разделов
* Процессы работающие с /var/log
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/VirtualBox_MyNewLinuxd_24_05_2019_21_49_28.png)
* Остановка этих процессов
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/VirtualBox_MyNewLinuxd_24_05_2019_21_50_40.png)
* Выполнение финальной синхронизации разделов
* Поменял местами разделы
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/VirtualBox_MyNewLinuxd_24_05_2019_21_51_41.png)
17. Правка /etc/fstab
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/VirtualBox_MyNewLinuxd_24_05_2019_21_53_31.png)
18. Проверка всего
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/lastscreens.png)
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/3rdTask/lastscreens2.png)
