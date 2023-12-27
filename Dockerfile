FROM debian:stable-slim

RUN useradd -r bells  \
  && apt-get update -y \
  && apt-get install -y curl wget gnupg \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV GOSU_VERSION 1.12
RUN set -x \
  && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture)" \
  && chmod +x /usr/local/bin/gosu \
  && gosu --version


ARG version=2.0.0

RUN \
  case $(dpkg --print-architecture) in \
    "amd64")  DOWNLOAD_ARCH="x86_64-linux-gnu"  ;; \
    "armhf") DOWNLOAD_ARCH="arm-linux-gnueabihf"  ;; \
    "i386") DOWNLOAD_ARCH="i686-pc-linux-gnu"  ;; \
    "arm64") DOWNLOAD_ARCH="aarch64-linux-gnu"  ;; \
  esac && \
  wget https://github.com/Nintondo/bellscoin/releases/download/${version}/bells-${version}-${DOWNLOAD_ARCH}.tar.gz && \
  tar -vxf /bells-${version}-${DOWNLOAD_ARCH}.tar.gz && \
  cd bells-${version}/bin && \
  chmod +x bellsd && \
  mv bellsd /usr/local/bin

ENV BELLS_DATA=/home/bells/.bells

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["bellsd"]