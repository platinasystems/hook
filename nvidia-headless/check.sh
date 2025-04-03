#!/bin/sh

failed() {
	printf "NVIDIA/IPMI/Mellanox Kernel module test suite FAILED\n"
	dmesg | tail -n 40
	/sbin/poweroff -f
}

printf "NVIDIA/IPMI/Mellanox kernel modules test for %s\n" "$(uname -r)"

# order reflects dependencies
modules='nvidia nvidia-modeset nvidia-drm nvidia-uvm mlx_compat ib_core ib_uverbs nvidia-peermem ipmi_devintf'
for module in $modules; do
  modinfo "${module}.ko" || failed
done
printf "NVIDIA/IPMI kernel modules formal check PASSED\n"

# order reflects dependencies
mlx_modules='ib_cm ib_ipoib iw_cm rdma_cm ib_iser ib_isert ib_srp ib_umad irdma knem mlxfw mlxdevm mlx5_core mlx5-vfio-pci mlx5_ib mlx5_vdpa mst_pci mst_pciconf rdma_ucm scsi_transport_srp'
for module in mlx_modules; do
  modinfo "${module}.ko" || failed
done
printf "Mellanox kernel modules formal check PASSED\n"

printf "trying insmod nvidia/ipmi modules...\n"
for module in $modules; do
  insmod "${module}.ko"
done

#printf "trying insmod mellanox modules...\n"
#for module in mlx_modules; do
#  insmod "${module}.ko"
#done
dmesg | tail -n 40

/sbin/poweroff -f