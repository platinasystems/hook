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
    ```      
  - clone the hook repository
    ```shell
    git clone https://github.com/platinasystems/hook.git ; cd hook
    ```
## building the kernel
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

## building the NVIDIA driver
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

## building hook
  - update `kernel.image` name in `hook.yaml` file reflecting the output of `git ls-tree --full-tree HEAD | grep kernel | awk '{print $3}'`
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