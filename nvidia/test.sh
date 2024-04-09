#!/bin/sh
# SUMMARY: Test build and insertion of NVIDIA kernel modules
# LABELS:
# REPEAT:

set -e

NAME=nvkmod-test
IMAGE_NAME=nvkmod

clean_up() {
	docker rmi ${IMAGE_NAME} || true
	rm -rf ${NAME}-*
}
trap clean_up EXIT

# Build a package
docker build --no-cache -t ${IMAGE_NAME} .

# Build and run a LinuxKit image with kernel module (and test script)
linuxkit build --docker --format kernel+initrd --name "${NAME}" test.yml
RESULT="$(linuxkit run ${NAME})"
echo "${RESULT}" | grep -q "NVIDIA kernel modules formal check PASSED"

exit 0