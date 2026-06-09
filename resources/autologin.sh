#!/bin/sh

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <log_file> <srun_log_file>" >&2
    exit 1
fi
if [ -z "$USERNAME" ] || [ -z "$PASSWORD" ]; then
    echo "Error: USERNAME and PASSWORD must be set" >&2
    exit 1
fi

is_down=0
while true; do
    sleep 20

    wget -q --spider -T 3 'http://connectivitycheck.platform.hicloud.com/generate_204'
    res="$?"
    {
        if [ "$res" -ne 0 ]; then
                /bin/srun --username="$USERNAME" --password="$PASSWORD" 2>&1
                printf 'Exit code: %d\n' "$?"
        fi
    } >>"$2"
    {
        date="$(date '+%Y-%m-%d %H:%M:%S')"
        if [ "$res" -ne 0 ] && [ "$is_down" -eq 0 ]; then
            echo "[$date] Network DOWN"
            is_down=1
        elif [ "$res" -eq 0 ] && [ "$is_down" -eq 1 ]; then
            echo "[$date] Network UP"
            is_down=0
        fi
    } >>"$1"
done
