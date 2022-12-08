#!/bin/bash
wget "https://github.com/grafana/loki/releases/download/v2.4.1/promtail-linux-amd64.zip"
unzip promtail-linux-amd64.zip
chmod a+x promtail-linux-amd64
sudo mv promtail-linux-amd64 /usr/bin/promtail

echo " Creating config file "
sudo tee /usr/local/bin/config-promtail.yml <<EOF
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
- job_name: docker
  static_configs:
  - targets:
      - localhost
    labels:
      job: docker
      __path__: /var/lib/docker/containers/*/*log
EOF

sudo tee /etc/systemd/system/promtail.service <<EOF
[Unit]
Description=Promtail
After=network.target

[Service]
User=root
Group=root
Type=simple
ExecStart=/usr/bin/promtail -config.file /usr/local/bin/config-promtail.yml
[Install]
WantedBy=multi-user.target
EOF



sudo systemctl daemon-reload
sudo systemctl enable promtail
sudo systemctl start promtail
sudo systemctl status promtail
