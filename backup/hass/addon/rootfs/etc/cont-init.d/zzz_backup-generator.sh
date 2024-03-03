#!/usr/bin/with-contenv bashio

chmod 0700 ~root/create-hass-backup
rm -f ~root/addons ~root/config ~root/share ~root/ssl

echo "${SUPERVISOR_TOKEN}" > ~root/supervisor_token

if bashio::config.has_value "backup_generator_authorized_keys"; then
    mkdir -p ~backup-generator/.ssh
    chmod 0700 ~backup-generator/.ssh
    chown backup-generator:backup-generator ~backup-generator/.ssh

    rm -f ~backup-generator/.ssh/authorized_keys

    # bashio::config doesn't like being piped directly into a file.
    while read -r line; do
        echo "$line" >> ~backup-generator/.ssh/authorized_keys
    done <<< "$(bashio::config "backup_generator_authorized_keys")"

    chmod 0600 ~backup-generator/.ssh/authorized_keys
    chown -R backup-generator:backup-generator ~backup-generator/.ssh

    PASSWORD="$(pwgen -s 64 1)"
    echo "backup-generator:${PASSWORD}" | chpasswd &> /dev/null
fi
