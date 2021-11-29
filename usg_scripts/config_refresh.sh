#!/bin/vbash
# https://docs.vyos.io/en/latest/automation/command-scripting.html

source /opt/vyatta/etc/functions/script-template

configure

hostname=( $(show system host-name) )

set system host-name "${hostname[1]}"-tmp
set system host-name "${hostname[1]}"

commit
save
exit
