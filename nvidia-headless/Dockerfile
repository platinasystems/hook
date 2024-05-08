FROM platina/kernel-ubuntu:5.15.0-105.115 AS ksrc
FROM ubuntu:jammy-20240427 AS build

RUN apt update && apt install -y linux-headers-5.15.0-105-generic nvidia-headless-550-server kmod

FROM ubuntu:jammy-20240427
RUN apt update && apt install -y kmod
COPY --from=build /lib/modules/5.15.0-105-generic/updates/dkms/nvidia*.ko /
COPY check.sh /check.sh
ENTRYPOINT ["/bin/sh", "/check.sh"]
