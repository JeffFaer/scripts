# unifi

```
[unifi]  $ sudo adduser backup-generator
[server] $ ssh-keygen -f ~/.ssh/unifi_backup -N ''
[server] $ ssh-copy-id -i ~/.ssh/unifi_backup backup-generator@unifi
[unifi]  $ sudo passwd -l backup-generator
[unifi]  $ sudo chown :backup-generator /data/autobackup
[unifi]  $ sudo chmod g+rs /data/autobackup
```
<!-- TODO: Do I need to change a umask somewhere to get g+r by default? -->

And then you should be able to make calls like:
```
[server] $ rsync --archive -e "ssh -i ~/.ssh/unifi_backup" \
               backup-generator@unifi:/data/autobackup/ unifi_backups
```
