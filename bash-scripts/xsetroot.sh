#!/usr/bin/env bash
# original script created by clusterF modified
# by ManyRoads
#

# while true; do
#
#         date '+  %a. %d %b.   %R ' > /tmp/CurTime.tmp
#
#         sleep 60s
# done &

while true; do

        LOCALTIME=$(< /tmp/CurTime.tmp)
        BAT=$(acpi | awk '{print $4}' | sed s/,//)
        # DB=$(dropbox status)
        # VOL=$(pamixer --get-volume-human)
        MEM=$(free -h --kilo | awk '/^Mem:/ {print $3 "/" $2}')
        # CPU=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}' )
        TEMP=$(sensors|grep 'Core 0'|awk '{print $3}' )
        DISK=$(df -Ph | grep "/dev/nvme0n1p6" | awk {'print $5'})
        WIFI=$(nmcli -f ACTIVE,SIGNAL dev wifi list | awk '$1=="yes" {print $2}')
        # xsetroot -name "  $MEM   $CPU%  $TEMP   $DISK    $VOL   $WIFI%   $DB  $LOCALTIME    "
        xsetroot -name "  $MEM  $TEMP    $DISK    $WIFI%;$LOCALTIME $BAT";
        sleep 1s
done &
