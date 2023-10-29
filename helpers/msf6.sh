# msf6
# start postgresql service
sudo systemctl enable;start postgresql
sudo msfdb init
msfconsole

# To scan the range:

nmap -sn 192.168.0.0/24

# To check for open ports and generate xml report

nmap -sV -T4 -oX ipscan.xml 192.168.0.181

# Import xml to db

db_import ipscan.xml
