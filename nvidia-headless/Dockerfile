FROM platina/kernel-ubuntu:5.15.0-105.115 AS ksrc
FROM ubuntu:jammy-20240530 AS build

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y --no-install-recommends \
    gnupg2 curl ca-certificates

RUN curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb -o cuda-keyring_1.1-1_all.deb && \
    dpkg -i cuda-keyring_1.1-1_all.deb && \
    rm -rf /var/lib/apt/lists/*

RUN apt update && apt install -y linux-headers-5.15.0-105-generic kmod nvidia-driver-535
RUN apt install -y linux-modules-extra-5.15.0-105-generic
#RUN apt install -y quilt bison lsb-base chrpath pkg-config tcl swig graphviz flex debhelper tk libfuse2t64 lsof ethtool pciutils
#
### Mellanox OFED
#RUN curl --output MLNX_OFED_LINUX-24.10-2.1.8.0-ubuntu24.04-x86_64.tgz https://content.mellanox.com/ofed/MLNX_OFED-24.10-2.1.8.0/MLNX_OFED_LINUX-24.10-2.1.8.0-ubuntu24.04-x86_64.tgz && \
#    tar xf /MLNX_OFED_LINUX-24.10-2.1.8.0-ubuntu24.04-x86_64.tgz && \
#    rm /MLNX_OFED_LINUX-24.10-2.1.8.0-ubuntu24.04-x86_64.tgz
#WORKDIR MLNX_OFED_LINUX-24.10-2.1.8.0-ubuntu24.04-x86_64
#
## take snapshot
#RUN ./mlnxofedinstall -k 5.15.0-105-generic --force --without-fw-update --without-xpmem-dkms --kernel-only -k 5.15.0-105-generic

FROM ubuntu:jammy-20240530
RUN apt update && apt install -y kmod
COPY --from=build /lib/modules/5.15.0-105-generic/updates/dkms/*.ko /
COPY --from=build /usr/lib/modules/5.15.0-105-generic/kernel/drivers/char/ipmi/*.ko /
COPY --from=build /usr/lib/firmware /usr/lib/firmware
RUN touch /usr/lib/firmware/nvidia/hook
COPY check.sh /check.sh
ENTRYPOINT ["/bin/sh", "/check.sh"]
