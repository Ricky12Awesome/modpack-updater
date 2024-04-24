FROM alpine:edge

RUN apk add --no-cache -U jq curl unzip su-exec

VOLUME [ "/data" ]
WORKDIR /data

RUN addgroup -g 1000 minecraft
RUN adduser -Ss /bin/false -u 1000 -G minecraft -h /home/minecraft minecraft

COPY --chmod=755 download-modpack.sh /download-modpack.sh
COPY --chmod=755 init /init

ENTRYPOINT [ "/init" ]