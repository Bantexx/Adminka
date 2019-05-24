# Лабораторная работа №2
## Задание 1 (Установка ОС и настройка LVM, RAID)
1. Создание новой виртуальной машины, выдав ей следующие характеристики:
* 1 gb ram
* 1 cpu
* 2 hdd (назвав их ssd1, ssd2 и назначил равный размер, поставив галочки hot swap и ssd)
* SATA контроллер настроен на 4 порта
![alt-текст](https://github.com/Bantexx/Adminka/blob/master/Lab2/images/1stTask/beginSettings.PNG)
2. Начало установки Linux:
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images/VirtualBox_Raid_26_03_2019_16_55_33.png)
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
* В итоге получил: 
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images/VirtualBox_Raid_26_03_2019_17_12_17.png)
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
     + Выбрав Display configuration details получил следующую картину: 
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images/VirtualBox_Raid_26_03_2019_17_17_21.png)
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
* Результат команды lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT:
    + sda - ssd1
    + sdb -ssd2
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images/VirtualBox_Raid%20v2.0_07_04_2019_18_21_30.png)
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
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images2/VirtualBox_����%20Raid%20v2.0_06_04_2019_09_25_35.png) 
2. Проверка статуса RAID-массива cat /proc/mdstat
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images2/VirtualBox_����%20Raid%20v2.0_06_04_2019_09_26_27.png)
3. Добавление в интерфейсе VM нового диска такого же размера с названием ssd3
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images2/Screenshot_4.png)
4. Выполнение операций:
* Просмотр нового диска, что он приехал в систему командой fdisk -l
* Копирование таблиц разделов со старого диска на новый: sfdisk -d /dev/XXXX | sfdisk /dev/YYY
* Результат
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images2/VirtualBox_lab%202.2_07_04_2019_21_46_35.png)
* Добавление в рейд массив нового диска: mdadm --manage /dev/md0 --add /dev/YYY
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images2/VirtualBox_lab%202.2_07_04_2019_21_47_34.png)
* Результат cat /proc/mdstat
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images2/VirtualBox_lab%202.2_07_04_2019_21_48_13.png)
5. Выполение синхронизации разделов, не входящих в RAID
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images2/VirtualBox_lab%202.2_07_04_2019_21_49_01.png)
6. Установка grub на новый диск
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images2/VirtualBox_lab%202.2_07_04_2019_21_49_25.png)
7. Перезагрузка ВМ и проверка, что все работает
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images2/VirtualBox_������%20�����%20����������_06_04_2019_11_18_44.png)
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
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_15_24_43.png)
2. Добавление нового ssd диска
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_15_27_10.png)
3. Перенос данных с помощью LVM
* Копирование файловую таблицу со старого диска на новый
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_15_28_48.png)
* Копирование данных /boot на новый диск
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_15_30_23.png)
* Перемонтировака /boot на живой диск
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_15_32_40.png)
* Установка grub на новый диск
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_15_33_10.png)

Grub устанавливаем, чтобы могли загрузить ОС с этого диска
* Создание нового RAID-массива с включением туда только одного нового ssd диска:
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_15_51_49.png)
* Проверка результата
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_15_52_50.png)

Появился /dev/md63

4. Настройка LVM
* Выполнение команды pvs для просмотра информации о текущих физических томах
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_15_53_14.png)
* Создание нового физического тома, включив в него ранее созданный RAID массив:
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_15_53_59.png)
* Выполнение команд lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT и pvs
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_15_54_26.png)

К md63 добавился FSTYPE - LVM2_member, так же dev/md63 добавился к результату команды pvs
* Увеличение размера Volume Group system
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_15_55_08.png)
* Выполнение команд
```
vgdisplay system -v
pvs
vgs
lvs -a -o+devices
```
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_15_55_46.png)
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_15_56_34.png)

LV var,log,root находятся на /dev/md0
* Перемещение данных со старого диска на новый
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_16_01_11.png)
* Выполнение команд:
```
vgdisplay system -v
pvs
vgs
lvs -a -o+devices
lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT
```
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_16_01_46.png)
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_16_02_14.png)
* Изменение VG, удалив из него диск старого raid.
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_16_03_53.png)
```
lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT
pvs
vgs
```
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_16_06_45.png)

В выводе команды pvs у /dev/md0 исчезли VG и Attr.
В выводе команды vgs #PV - уменьшилось на 1, VSize, VFree - стали меньше
* Перемонтировка /boot на второй диск, проверка, что boot не пустой
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_16_07_50.png)
5. Удаление ssd3 и добавление ssd5,hdd1,hdd2

Тут названия дисков и md поменялись, т.к я сделал клонирования ВМ
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_18_38_10.png)

6. Восстановление работы основного RAID массива:
* Копирование таблицы разделов:
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_18_39_40.png)
7. Копирование загрузочного раздела /boot с диска ssd4 на ssd5
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_18_41_24.png)
8. Установка grub на ssd5
9. Изменение размера второго раздела диска ssd5
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_18_43_08.png)
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_18_43_23.png)
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_18_45_54.png)
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_18_46_11.png)
10. Перечитывание таблицы разделов
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_18_47_46.png)
* Добавление нового диска к текущему raid массиву
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_18_53_12.png)
* Расширение количество дисков в массиве до 2-х штук:
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_18_54_58.png)
11. Увеличение размера раздела на диске ssd4
* Запуск утилиты для работы с разметкой дисков
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_18_56_48.png)
12. Перечитаем таблицу разделов
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_18_57_49.png)
13. Расширение размера raid
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_18_58_43.png)

Размер md127 стал 7.5G
* Вывод команды pvs
* Расширение размера PV
* Вывод команды pvs
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_18_59_45.png)
14. Добавление вновь появившееся место VG var,root
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_Hard_06_04_2019_19_01_24.png)
15. Перемещение /var/log на новые диски
* Посмотрел какие имена имеют новые hhd диски
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_15%20������%20�������_06_04_2019_19_07_17.png)
* Создание RAID массива
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_15%20������%20�������_06_04_2019_19_09_42.png)
* Создание нового PV на рейде из больших дисков
* Создание в этом PV группу с названием data
* Создание логического тома с размером всего свободного пространства и присвоением ему имени var_log
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_15%20������%20�������_06_04_2019_19_17_14.png)
* Отформатирование созданного раздела в ext4
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_15%20������%20�������_06_04_2019_19_19_14.png)
16. Перенос данных логов со старого раздела на новый
* Примонтирование временно нового хранилище логов
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_15%20������%20�������_06_04_2019_19_20_06.png)
* Выполнение синхронизации разделов
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_15%20������%20�������_06_04_2019_19_27_22.png)
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_15%20������%20�������_06_04_2019_19_27_50.png)
* Процессы работающие с /var/log
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_15%20������%20�������_06_04_2019_19_28_34.png)
* Остановка этих процессов
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_15%20������%20�������_06_04_2019_19_29_33.png)
* Выполнение финальной синхронизации разделов
* Поменял местами разделы
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_15%20������%20�������_06_04_2019_19_30_48.png)
17. Правка /etc/fstab
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_�����%20�����_06_04_2019_19_53_13.png)
18. Проверка всего
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_�����%20�����_06_04_2019_19_54_03.png)
![alt-текст](https://github.com/Kindface/Linux-labs/blob/master/lab2/images3/VirtualBox_�����%20�����_06_04_2019_19_54_34.png)
