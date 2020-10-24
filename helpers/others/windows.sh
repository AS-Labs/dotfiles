#!/bin/bash

## Check if the script was executed as root
[[ "$EUID" -ne 0 ]] && echo "Please run as root" && exit 1

## Load the config file
source "${BASH_SOURCE%/*}/config"

## Check libvirtd
[[ $(systemctl status libvirtd | grep running) ]] || systemctl start libvirtd && sleep 1 && LIBVIRTD=STOPPED

## Memory lock limit
[[ $ULIMIT != $ULIMIT_TARGET ]] && ulimit -l $ULIMIT_TARGET

## Kill the Display Manager
systemctl stop gdm
sleep 1

## Kill the console
echo 0 > /sys/class/vtconsole/vtcon0/bind
#echo 0 > /sys/class/vtconsole/vtcon1/bind
#echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/unbind
#echo efi-framebuffer.0 | sudo tee /sys/bus/platform/drivers/efi-framebuffer/unbind

## Detach the GPU
virsh nodedev-detach $VIRSH_GPU > /dev/null 2>&1
virsh nodedev-detach $VIRSH_GPU_AUDIO > /dev/null 2>&1
virsh nodedev-detach $VIRSH_GPU_USB > /dev/null 2>&1
virsh nodedev-detach $VIRSH_GPU_SERIAL > /dev/null 2>&1

## Load vfio
modprobe vfio-pci

## QEMU (VM) command
qemu-system-x86_64 -runas $VM_USER -enable-kvm \
  -nographic -vga none -parallel none -serial none \
  -enable-kvm \
  -m $RAM \
  -cpu host,kvm=off,hv_relaxed,hv_spinlocks=0x1fff,hv_time,hv_vapic,hv_vendor_id=0xDEADBEEFFF \
  -rtc clock=host,base=localtime \
  -smp $CORES,sockets=1,cores=$(( $CORES / 2 )),threads=2 \
  -device vfio-pci,host=$IOMMU_GPU,multifunction=on,x-vga=on \
  -device vfio-pci,host=$IOMMU_GPU_AUDIO \
  -device virtio-net-pci,netdev=n1 \
  -netdev user,id=n1 \
  -drive if=pflash,format=raw,readonly,file=$OVMF \
  -drive media=cdrom,file=$WINDOWS_ISO,id=cd1,if=none \
  -device ide-cd,bus=ide.1,drive=cd1 \
  -drive media=cdrom,file=$VIRTIO,id=cd2,if=none \
  -device ide-cd,bus=ide.1,drive=cd2 \
  -device virtio-scsi-pci,id=scsi0 \
  -device scsi-hd,bus=scsi0.0,drive=rootfs \
  -drive id=rootfs,file=$WINDOWS_IMG,media=disk,format=qcow2,if=none >> $LOG 2>&1 &

## Wait for QEMU
wait

## Unload vfio
modprobe -r vfio-pci
modprobe -r vfio_iommu_type1
modprobe -r vfio

## Reattach the GPU
virsh nodedev-reattach $VIRSH_GPU_AUDIO > /dev/null 2>&1
virsh nodedev-reattach $VIRSH_GPU > /dev/null 2>&1
virsh nodedev-reattach $VIRSH_GPU_USB > /dev/null 2>&1
virsh nodedev-reattach $VIRSH_GPU_SERIAL > /dev/null 2>&1

## Reload the framebuffer and console
echo 1 > /sys/class/vtconsole/vtcon0/bind
nvidia-xconfig --query-gpu-info > /dev/null 2>&1
echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind

## Reload the Display Manager
systemctl start gdm

## If libvirtd was stopped then stop it
[[ $LIBVIRTD == "STOPPED" ]] && systemctl stop libvirtd

## Restore ulimit
ulimit -l $ULIMIT
