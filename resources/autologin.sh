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

    if
        code="$(curl -s -o /dev/null -w '%{http_code}' --connect-timeout 3 --max-time 5 --ssl-reqd 'https://connectivitycheck.platform.hicloud.com/generate_204')" &&
            [ "$code" = 204 ]
    then
        okay=1
    else
        okay=0
    fi

    if [ "$okay" -ne 1 ]; then
        {
            {
                /bin/srun --username="$USERNAME" --password="$PASSWORD"
                printf '/bin/srun exited with %d\n' "$?"
            } 2>&1 1>&3 | tee -a "$2" >&2
        } 3>&1 | tee -a "$2"
    fi
    {
        date="$(date '+%Y-%m-%d %H:%M:%S')"
        if [ "$okay" -ne 1 ] && [ "$is_down" -eq 0 ]; then
            echo "[$date] Network DOWN"
            is_down=1
        elif [ "$okay" -eq 1 ] && [ "$is_down" -eq 1 ]; then
            echo "[$date] Network UP"
            is_down=0
        fi
    } | tee -a "$1"
done
