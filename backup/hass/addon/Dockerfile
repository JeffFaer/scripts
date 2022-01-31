ARG BUILD_ARCH
FROM homeassistant/${BUILD_ARCH}-addon-ssh

RUN \
  apk add --no-cache \
    sudo \
    rsync \
    shadow \
  && useradd -s /bin/bash -m backup-generator \
  && apk del --no-cache --purge shadow

COPY rootfs /
