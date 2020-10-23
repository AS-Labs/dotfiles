#!/bin/bash
# To install VFIO / QEMU / virtlibs
# This should be read manually.. make sure everything is understandable..

clear


echo "First we need to make sure we can access our machine if something wrong happens"

#echo "Install openssh-server: (yes/no)"
read -p "Install openssh-server? (yes/no) " yesno
#read $yesno
if [ "$yesno" = "yes" ] ; then
    echo "Installing openssh-server..";
    sudo apt install openssh-server;
else
    echo "Skipping install of openssh-server";
fi
sleep 2
clear
ipnum=`hostname -I |awk '{print $1}'`
username_local=`whoami`
echo "Make sure that you can ssh into your server"
echo "Your IP is: $ipnum "
echo "Try the following on a different machine in the local network, command: ssh $username_local@$ipnum"
read -p "Is ssh access working? (yes/no) " sshyesno
if [ "$sshyesno" = "yes" ] ; then
    echo "Great!";
    sleep 2
else
    echo "Please check your ssh configs and retry..";
    exit 1;
fi


echo "Checking if iommu groups exist. Taken from wendell from level1techs thanks! :)"
echo "Enter to continue"
read
for d in /sys/kernel/iommu_groups/*/devices/*; do
  n=${d#*/iommu_groups/*}; n=${n%%/*}
  printf 'IOMMU Group %s ' "$n"
  lspci -nns "${d##*/}"
done

read -p "Do you see your iommu groups? (yes/no) " iommuyesno
if [ "$iommuyesno" = "yes" ] ; then
    echo "Thanks wendell ;)";
    sleep 3
else
    echo "Please check your BIOS configs";
    exit 1;
fi

clear

read -p "Are you using systemd-boot? (yes/no) " bootyesno
if [ "$bootyesno" = "yes" ] ; then
    echo "Changing kernelstub settings..";
    amd_check=`sudo lscpu|grep "Vendor"|grep "AMD"|wc -l`
    intel_check=`sudo lscpu|grep "Vendor"|grep "Intel"|wc -l`
    if [ "$amd_check" = "1" ] ; then
        echo "AMD CPU detected";
        echo "Checking if kernelstub already added..";
        amd_kern_stub=`sudo grep amd_iommu /boot/efi/loader/entries/Pop_OS-current.conf|wc -l`
        if [ "$amd_kern_stub" = "1" ]; then
            echo "amd_iommu already exists in conf file";
        else
            echo "Adding amd_iommu=on and iommu=pt";
            sudo kernelstub -a amd_iommu=on;
            sudo kernalstub -a iommu=pt;
        fi

    elif [ "$intel_check" = "1" ] ; then
        echo "Intel CPU detected";
        echo "Checking if kernelstub already added..";
        intel_kern_stub=`sudo grep intel_iommu /boot/efi/loader/entries/Pop_OS-current.conf|wc -l`
        if [ "$intel_kern_stub" = "1" ] ; then
            echo "intel_iommu already exists in conf file";
        else
            echo "Adding intel_iommu=on and iommu=pt";
            sudo kernalstub -a intel_iommu=on;
            sudo kernalstub -a iommu=pt;
        fi
    else
        echo "No CPU detected!? nah, just a problem with the script most likely ;)"
        exit 1;
    fi

else
    echo "sorry.. grub support will be added later..";
    exit 1;

fi

sleep 5

echo "Installing virt-manager and ovmf"

sleep 5

sudo apt install virt-manager ovmf

# Now for the single gpu passthrough.. 
#TODO






















