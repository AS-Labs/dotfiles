#!/bin/bash
# To install VFIO / QEMU / virtlibs
# This should be read manually.. make sure everything is understandable..

clear


echo "First we need to make sure we can access our machine if something wrong happens"
echo "openssh server should be installed"

read -p "Install openssh-server? (yes/no) " yesno
if [ "$yesno" = "yes" ] ; then
    echo "Installing openssh-server..";
    sleep 2;
    sudo dnf install openssh-server;
    echo "Adding ssh service to firewall";
    sleep 2;
    sudo firewall-cmd --add-service=ssh --permanent;
    sudo firewall-cmd --reload;
    echo "Starting sshd and enabling it";
    sleep 2;
    sudo systemctl start sshd;
    sudo systemctl enable sshd;
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

echo "Now to enable iommu in software" 
sleep 5
echo "now we will open /etc/sysconfig/grub/ for editing"
echo "once open navigate to GRUB_CMDLINE_LINUX add the following for Intel or AMD respectivly: "
echo "intel_iommu=on"
echo "amd_iommu=on"
echo "[Return] To open /etc/sysconfig/grub"
read
sudo vi /etc/sysconfig/grub
echo "Checking if iommu is configured.."
amd_check=`sudo lscpu|grep "Vendor"|grep "AMD"|wc -l`
intel_check=`sudo lscpu|grep "Vendor"|grep "Intel"|wc -l`
sleep 3
if [ "$amd_check" = "1" ] ; then
    amd_iommu_check=`sudo grep "amd_iommu=on" /etc/sysconfig/grub |wc -l`
    intel_iommu_check=`sudo grep "intel_iommu=on" /etc/sysconfig/grub |wc -l`
    if [ "$amd_iommu_check" = "1" ]; then
        echo "amd_iommu has been added!"
        sleep 3
    elif [ "$intel_iommu_check" = "1" ] ; then
        echo "intel_iommu has been added!"
        sleep 3
    else
        echo "something went wrong with adding the flag to /etc/sysconfig/grub"
        exit 1
    fi
fi

echo "Installing @virtualization"

sleep 5

sudo dnf install @virtualization

# Now for the single gpu passthrough.. 
#TODO






















