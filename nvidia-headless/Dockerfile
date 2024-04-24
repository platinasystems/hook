FROM platina/kernel-ubuntu:5.15.0-102.112 AS ksrc
FROM ubuntu:jammy-20240405 AS build

RUN apt update && apt install -y nvidia-headless-550-server kmod

FROM ubuntu:focal-20240410
RUN apt update && apt install -y kmod
COPY --from=build /lib/modules/5.15.0-102-generic/updates/dkms/nvidia*.ko /
COPY check.sh /check.sh
ENTRYPOINT ["/bin/sh", "/check.sh"]
