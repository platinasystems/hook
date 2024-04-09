FROM quay.io/tinkerbell/hook-kernel:5.10.85-4fe9d417745026ee14c5e103546bb2e644bf38b2 AS ksrc
FROM linuxkit/alpine:e2391e0b164c57db9f6c4ae110ee84f766edc430 AS build

RUN apk add build-base git xz bash

COPY --from=ksrc /kernel-dev.tar /
RUN tar xf kernel-dev.tar

# fetch NVIDIA opensource driver code
RUN git clone https://github.com/NVIDIA/open-gpu-kernel-modules.git
WORKDIR open-gpu-kernel-modules
RUN git checkout tags/525.147.05 -b 525.147.05

RUN make SYSSRC=/usr/src/linux-headers-5.10.85-linuxkit modules -j$(getconf _NPROCESSORS_ONLN)

# Package
FROM alpine:3.19
COPY --from=build /open-gpu-kernel-modules/kernel-open/*.ko /
COPY check.sh /check.sh
ENTRYPOINT ["/bin/sh", "/check.sh"]