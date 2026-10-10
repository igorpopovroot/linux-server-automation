#!/bin/bash

### Strict mode

set -euo pipefail

### Who_am_i (Checking for root access is not required; free - runs as a standart user) ###


### func: get_total memory


get_total() {

free -m | awk '/Mem:/ {print $2}'

}

### func: get_available memory


get_available() {

free -m | awk '/Mem:/ {print $7}'

}

### Main (get data from 2 func (numb)

TOTAL=$(get_total)
AVAILABLE=$(get_available)
echo "Total: $TOTAL MiB"
echo "Available: $AVAILABLE MiB"


