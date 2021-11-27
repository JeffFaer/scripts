#!/bin/vbash
# https://docs.vyos.io/en/latest/automation/command-scripting.html

source /opt/vyatta/etc/functions/script-template

configure
commit
save
exit
