#!/bin/sh

if [ "$#" -lt 2 ]; then
    echo "Usage: USERNAME=... PASSWORD=... $0 <log_file> <srun_log_file>" >&2
    exit 1
fi
: "${USERNAME:?Error: USERNAME must be set}"
: "${PASSWORD:?Error: PASSWORD must be set}"

set -u

is_down=0
while true; do
    sleep 20

    wget -q --spider -T 3 'https://connectivitycheck.platform.hicloud.com/generate_204'
    res="$?"
    if [ "$res" -ne 0 ]; then
        {
            {
                /bin/srun --username="$USERNAME" --password="$PASSWORD"
                printf '/bin/srun exited with %d\n' "$?"
            } 2>&1 1>&3 | tee -a "$2" >&2
        } 3>&1 | tee -a "$2"
    fi
    {
        date="$(date '+%Y-%m-%d %H:%M:%S')"
        if [ "$res" -ne 0 ] && [ "$is_down" -eq 0 ]; then
            echo "[$date] Network DOWN"
            is_down=1
        elif [ "$res" -eq 0 ] && [ "$is_down" -eq 1 ]; then
            echo "[$date] Network UP"
            is_down=0
        fi
    } | tee -a "$1"
done
