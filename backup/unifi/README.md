# unifi

Scripts for periodically backing up a unifi controller (cloud key).

  - `backup-unifi`

    rsync's the unifi controller's automatic backups to a local directory
    (`$1`).
    - `UNIFI_SSH_FLAGS`: any flags that should be used when ssh'ing to the
      unifi controller.
    - `UNIFI_CONNECTION`: the ssh destination to connect to the unifi
      controller.

  - `backup-unifi.cron`

    Should be executed periodically by cron. It runs `backup-unifi`, then adds a
    couple additional pieces of monitoring on top of that to make sure (1) we
    have backup data from the unifi controller and (2) the data was recently
    modified.
    - `UNIFI_BACKUP_INTERVAL`: the number of seconds that we expect to elapse
      between the unifi controller's automated backups. Defaults to 8d.

```
[unifi]  $ sudo adduser backup-generator
[server] $ ssh-keygen -f ~/.ssh/unifi_backup -N ''
[server] $ ssh-copy-id -i ~/.ssh/unifi_backup backup-generator@unifi
[unifi]  $ sudo passwd -l backup-generator
[unifi]  $ sudo chmod +x /data/autobackup
[unifi]  $ sudo chmod -R +r /data/autobackup
```
<!-- TODO: Do I need a setfacl -d -m user:backup-generator /data/autobackup? -->

And then you should be able to make calls like:
```
[server] $ rsync --archive -e "ssh -i ~/.ssh/unifi_backup" \
               backup-generator@unifi:/data/autobackup/ unifi_backups
```
