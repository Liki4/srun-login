FROM alpine:latest

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.bfsu.edu.cn/g' /etc/apk/repositories && \
        apk add --no-cache bash

COPY srun-login /bin/srun
COPY resources/autologin.sh /opt/autologin.sh

RUN chmod +x /bin/srun && chmod +x /opt/autologin.sh

ENTRYPOINT ["/bin/bash", "/opt/autologin.sh", "/var/log/hdunet.log", "/var/log/hdulogin.log"]
