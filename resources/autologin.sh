#! /bin/bash

isdown=0
while [ 1 ]
do
    sleep 5
    ping -c 4 -W 1 223.5.5.5
    res=$?
    if [ "$res" != "0" ];then
        /bin/srun --username=$USERNAME --password=$PASSWORD >> $2
        echo "" >> $2
    fi
    if [[ "$res" != "0" && $isdown == 0 ]];then
        time=$(date "+%Y-%m-%d %H:%M:%S")
        echo "[${time}] Network DOWN" >> $1
        isdown=1
    fi
    if [[ "$res" == "0" && $isdown == 1 ]];then
        time=$(date "+%Y-%m-%d %H:%M:%S")
        echo "[${time}] Network UP" >> $1
        isdown=0
    fi
done