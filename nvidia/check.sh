#!/bin/sh

failed() {
	printf "NVIDIA Kernel module test suite FAILED\n"
	dmesg | tail -n 40
	/sbin/poweroff -f
}

printf "NVIDIA kernel modules test for %s\n" "$(uname -r)"

# order reflects dependencies
modules='nvidia nvidia-modeset nvidia-drm nvidia-uvm nvidia-peermem'
for module in $modules; do
  modinfo "${module}.ko" || failed
done
printf "NVIDIA kernel modules formal check PASSED\n"

printf "trying insmod nvidia modules...\n"
for module in $modules; do
  insmod "${module}.ko"
done
dmesg | tail -n 40

/sbin/poweroff -f