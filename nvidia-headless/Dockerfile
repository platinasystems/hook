FROM platina/kernel-ubuntu:5.15.0-105.115 AS ksrc
FROM ubuntu:jammy-20240530 AS build

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 curl ca-certificates

RUN curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb -o cuda-keyring_1.1-1_all.deb && \
    dpkg -i cuda-keyring_1.1-1_all.deb && \
    rm -rf /var/lib/apt/lists/*

RUN apt update && apt install -y linux-headers-5.15.0-105-generic kmod nvidia-driver-535
RUN apt install -y linux-modules-extra-5.15.0-105-generic

FROM ubuntu:jammy-20240530
RUN apt update && apt install -y kmod
COPY --from=build /lib/modules/5.15.0-105-generic/updates/dkms/nvidia*.ko /
COPY --from=build /usr/lib/modules/5.15.0-105-generic/kernel/drivers/char/ipmi/*.ko /
COPY check.sh /check.sh
ENTRYPOINT ["/bin/sh", "/check.sh"]
