# octopi

Scripts for periodically backing up an octopi.

  - `backup-octopi`

    ssh's into the octopi, triggers a backup, then moves it to a local
    directory (`$1`).
    - `OCTOPI_SSH_FLAGS`: any flags that should be used when ssh'ing to the
      octopi.
    - `OCTOPI_CONNECTION`: the ssh destination to connect to the octopi.

  - `backup-octopi.cron`

    Should be executed periodically by cron. Every so often, it will run
    `backup-octopi` to create a backup in a local directory (`$1`). It has a
    maximum number allowed backups, so it will delete backups older than that
    after running `backup-octopi`.
    - `OCTOPI_BACKUP_INTERVAL`: the number of seconds that should elapse between
      backups. Defaults to 7d.
    - `OCTOPI_MAX_BACKUPS`: the number of backups that should be retained.
      Defaults to 52.

  - `create-octoprint-backup`

    A file that runs on the octopi to trigger a backup. It's a separate script
    so that we can create a user whose only special prvilege is to run this
    script that creates a backup. To set it up, do the following
    ```
    [octopi] $ sudo adduser backup-generator
    [server] $ ssh-keygen -f ~/.ssh/octopi_backup -N ''
    [server] $ ssh-copy-id -i ~/.ssh/octopi_backup backup-generator@octopi
    [server] $ scp create-octoprint-backup pi@octopi:~
    [octopi] $ sudo passwd -l backup-generator
    [octopi] $ cat /etc/sudoers.d/backup-generator
    backup-generator ALL = (pi) NOPASSWD: /home/pi/create-octoprint-backup
    [octopi] $ sudo mkdir -p /data/backups
    [octopi] $ sudo chmod +w /data/backups
    ```

    And then you should be able to make calls like:
    ```
    [server] $ ssh -i ~/.ssh/octopi_backup backup-generator@octopi -- \
                   "sudo -u pi /home/pi/create-octoprint-backup /data/backups/backup.zip"
    ```
