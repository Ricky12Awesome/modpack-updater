FROM alpine:edge

RUN apk add jq
RUN apk add curl
RUN apk add unzip

VOLUME [ "/data" ]
WORKDIR /data

COPY --chmod=755 download_modpack.sh /download_modpack.sh

ENTRYPOINT [ "/download_modpack.sh" ]