#!/bin/bash
wget "https://github.com/grafana/loki/releases/download/v2.4.1/promtail-linux-amd64.zip"
unzip promtail-linux-amd64.zip
chmod a+x promtail-linux-amd64
sudo mv promtail-linux-amd64 /usr/bin/promtail
sudo useradd -rs /bin/false promtail

echo " Creating config file "
sudo tee -a /usr/local/bin/config-promtail.yml <<EOF
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://192.168.0.154:3100/loki/api/v1/push

scrape_configs:
- job_name: system
  static_configs:
  - targets:
      - localhost
    labels:
      job: varlogs
      __path__: /var/log/*/*log

EOF

sudo echo "[Unit]" >> /etc/systemd/system/promtail.service
sudo echo "Description=Promtail" >> /etc/systemd/system/promtail.service
sudo echo "After=network.target" >> /etc/systemd/system/promtail.service
sudo echo "" >> /etc/systemd/system/promtail.service
sudo echo "[Service]" >> /etc/systemd/system/promtail.service
sudo echo "User=promtail" >> /etc/systemd/system/promtail.service
sudo echo "Group=promtail" >> /etc/systemd/system/promtail.service
sudo echo "Type=simple" >> /etc/systemd/system/promtail.service
sudo echo "ExecStart=/usr/bin/promtail -config.file /usr/local/bin/config-promtail.yml
" >> /etc/systemd/system/promtail.service
sudo echo "" >> /etc/systemd/system/promtail.service
sudo echo "[Install]" >> /etc/systemd/system/promtail.service
sudo echo "WantedBy=multi-user.target" >> /etc/systemd/system/promtail.service



sudo systemctl daemon-reload
sudo systemctl enable promtail
sudo systemctl start promtail
sudo systemctl status promtail
