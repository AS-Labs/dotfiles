#!/bin/sh
PREREQS=""
DEVS="0000:0a:00.0 0000:0a:00.1 0000:0a:00.2 0000:0a:00.3"
for DEV in $DEVS;
  do echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
done

modprobe -i vfio-pci
