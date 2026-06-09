FROM alpine:latest

COPY srun-login /bin/srun
COPY resources/autologin.sh /opt/autologin.sh

RUN chmod +x /bin/srun && chmod +x /opt/autologin.sh

ENTRYPOINT ["/opt/autologin.sh", "/var/log/hdunet.log", "/var/log/hdulogin.log"]
