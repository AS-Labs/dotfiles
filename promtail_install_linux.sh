#!/bin/bash
wget "https://github.com/grafana/loki/releases/download/v2.4.1/promtail-linux-amd64.zip"
unzip promtail-linux-amd64.zip
chmod a+x promtail-linux-amd64
sudo mv promtail-linux-amd64 /usr/bin/promtail
sudo useradd -rs /bin/false promtail

sudo echo "[Unit]" >> /etc/systemd/system/promtail.service
sudo echo "Description=Promtail" >> /etc/systemd/system/promtail.service
sudo echo "After=network.target" >> /etc/systemd/system/promtail.service
sudo echo "" >> /etc/systemd/system/promtail.service
sudo echo "[Service]" >> /etc/systemd/system/promtail.service
sudo echo "User=promtail" >> /etc/systemd/system/promtail.service
sudo echo "Group=promtail" >> /etc/systemd/system/promtail.service
sudo echo "Type=simple" >> /etc/systemd/system/promtail.service
sudo echo "ExecStart=/usr/bin/promtail" >> /etc/systemd/system/promtail.service
sudo echo "" >> /etc/systemd/system/promtail.service
sudo echo "[Install]" >> /etc/systemd/system/promtail.service
sudo echo "WantedBy=multi-user.target" >> /etc/systemd/system/promtail.service



sudo systemctl daemon-reload
sudo systemctl enable promtail
sudo systemctl start promtail
sudo systemctl status promtail
