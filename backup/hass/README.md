# hass

Scripts for periodically backing up a hass installation.

  - `backup-hass`

    ssh's into the hass, triggers a backup, then moves it to a local directory
   (`$1`).
   - `HASS_SSH_FLAGS`: any flags that should be used when ssh'ing to the hass.
   - `HASS_CONNECTION`: the ssh destination to connect to the hass.

  - `backup-hass.cron`

    Should be executed periodically by cron. Every so often, it will run
    `backup-hass` to create a backup in a local directory (`$1`). It has a
    maximum number allowed backuped, so it will delete backups older than that
    after running `backup-hass`.
    - `HASS_BACKUP_INTERVAL`: the number of seconds that should elapse between
      backups. Defaults to 7d.
    - `HASS_MAX_BACKUPS`: the number of backups that should be retained.
      Defaults to 52.

  - `create-hass-backup`

    A file that runs on the hass to trigger a backup. It's a separate script so
    that we can create a user whose only special privilege is to run this script
    that creates a backup.
    ```
    [hass]   $ sudo adduser backup-generator
    [server] $ ssh-keygen -f ~/.ssh/hass_backup -N ''
    [server] $ ssh-copy-id -i ~/.ssh/hass_backup backup-generator@hass
    [server] $ scp create-hass-backup jeffrey@hass:~
    [hass]   $ sudo passwd -l backup-generator
    [hass]   $ cat /etc/sudoers.d/backup-generator
    backup-generator ALL = (root) NOPASSWD: /home/jeffrey/create-hass-backup
    ```

    And then you should be able to make calls like:
    ```
    [server] $ ssh -i ~/.ssh/hass_backup backup-generator@hass -- "sudo
/home/jeffrey/create-hass-backup"
    ```
