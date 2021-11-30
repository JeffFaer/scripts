#!/bin/vbash
# https://docs.vyos.io/en/latest/automation/command-scripting.html

source /opt/vyatta/etc/functions/script-template

configure

cache_size_entry=( $(show service dns forwarding cache-size) )
original_cache_size="${cache_size_entry[1]}"

set service dns forwarding cache-size $((original_cache_size-1))
commit
save

set service dns forwarding cache-size ${original_cache_size}
commit
save

exit
