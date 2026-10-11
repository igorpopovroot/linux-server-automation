#!/bin/bash

### Strict mode

set -euo pipefail

### Config
source "$HOME/linux-server-automation/config/monitor_memory.conf"

### Who_am_i

### (Checking for root access is not required; free - runs as a standart user) ###


### func: get_total memory

get_total() {

free -m | awk '/Mem:/ {print $2}'

}


### func: get_available memory

get_available() {

free -m | awk '/Mem:/ {print $7}'

}


### func: check memory

check_memory() {

if (( AVAILABLE <= CRIT_LIMIT && AVAILABLE <= WARN_LIMIT )); then
     echo "ATTENTION! Problem with the RAM disk!"
elif (( AVAILABLE > CRIT_LIMIT && AVAILABLE <= WARN_LIMIT )); then
      echo "WARNING! Keep an eye on the RAM disk!"
else
      echo "RAM is fine!"
fi

}


### Main (get data from 2 func (numb)

TOTAL=$(get_total)
AVAILABLE=$(get_available)
WARN_LIMIT=$(( TOTAL * WARN_PERCENT / 100 ))
CRIT_LIMIT=$(( TOTAL * CRIT_PERCENT / 100 ))
echo "Total: $TOTAL MiB"
echo "Available: $AVAILABLE MiB"
echo "WARN limit (20% of total): $WARN_LIMIT"
echo "CRIT limit (10% of total): $CRIT_LIMIT"
check_memory


