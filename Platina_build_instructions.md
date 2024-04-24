# Build instructions for Platina customisations

The following steps were tested on Ubuntu 22.04.4 LTS (Jammy Jellyfish).

## build requirements
  - install needed packages
    ```shell
    apt update ; apt upgrade -y ; apt install -y build-essential docker-buildx
    ```
  - build LinuxKit from sourcecode, version v0.8.1
    ```shell
    git clone https://github.com/linuxkit/linuxkit ; cd linuxkit
    git checkout tags/v0.8.1 -b v0.8.1
    make
    make install
    cd ..
    ```
  - clone the hook repository
    ```shell
    git clone https://github.com/platinasystems/hook.git ; cd hook
    ```
  - switch to specific branch if needed
    ```shell
    git checkout origin/<mybranch> -b <mybranch>
    cd ..
    ```

## building the kernel (old alpine-based method)
  - make the kernel
    ```shell
    cd kernel
    make kconfig_amd64
    docker run --rm -ti -v $(pwd):/src:z quay.io/tinkerbell/kconfig
    cd linux-5.10.85 ; make menuconfig
    ```
  - do manual kernel config customisation (e.g. enable some device driver like `CONFIG_SCSI_MPT3SAS`), save and exit
  - copy config file outside of container
    ```shell
    cp .config /src/config-5.10.x-x86_64
    ```
  - exit from docker container
  - launch the build and patiently wait
    ```shell
    make devbuild_5.10.x
    cd ..
    ```

## building the kernel (new ubuntu-based method)
  - patch linuxkit
    ```shell
    cd linuxkit
    patch -p1 < ../hook/linuxkit-ubuntu.patch
    ```
  - build the image
    ```shell
    cd contrib/foreign-kernels
    sudo ./ubuntu.sh platina/kernel-ubuntu 5.15.0-102 112
    cd ../../..
    ```

## building the NVIDIA driver for the alpine-based kernel
  - build it
    ```shell
    cd nvidia
    docker build --no-cache -t nvkmod .
    cd ..
    ```
  - (optional) convenience script for developing: build + test
    ```shell
    apt install qemu-system-x86
    ./test.sh
    ```

## building the NVIDIA driver for the ubuntu-based kernel
  - change the `ksrc` image tag and kernel version in the `COPY --from=build` line if needed
  - build it
    ```shell
    cd nvidia-headless
    docker build --no-cache -t nvhkmod .
    cd ..
    ```
  - (optional) convenience script for developing: build + test
    ```shell
    apt install qemu-system-x86
    ./test.sh
    ```

## building hook
  - for alpine-based kernel:
    - update `kernel.image` name in `hook-alpine.yaml` file reflecting the output of `git ls-tree --full-tree HEAD | grep kernel | awk '{print $3}'`
    - ```shell
      cp hook-alpine.yaml hook.yaml
      ```
  - for ubuntu-based kernel:
    - update `kernel.image` name in `hook-ubuntu.yaml` file reflecting the chosen kernel version (eg. platina/kernel-ubuntu:5.15.0-102.112)
    - ```shell
      cp hook-ubuntu.yaml hook.yaml
      ```
  - make it
    ```shell
    make dist
    ```
  - deploy out/sha-xxxxxxx/rel/hook_x86_64.tar.gz archive to platina.io

## configure Tinkerbell
  - update `OSIE_DOWNLOAD_URLS` variable in `/opt/platina/pcc/bare_metal/deploy/compose/.env` with full URL from platina.io (https://platina.io/public/hook_x86_64.tar.gz)
  - restart Tinkerbell containers using docker compose
    ```shell
    cd /opt/platina/pcc/bare_metal/deploy/compose
    sudo docker compose restart
    ```