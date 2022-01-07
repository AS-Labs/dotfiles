# Creating a helper file to ease the install of grafana and loki with promtail.


echo " Creating loki dir.. "

sudo mkdir /opt/loki && cd /opt/loki

echo " Downloading local config yaml file"
wget https://raw.githubusercontent.com/grafana/loki/master/cmd/loki/loki-local-config.yaml
wget https://raw.githubusercontent.com/grafana/loki/main/clients/cmd/promtail/promtail-local-config.yaml

echo " Downloading loki and promtail .. "
wget https://github.com/grafana/loki/releases/download/v2.2.1/loki-linux-amd64.zip
sudo unzip loki-linux-amd64.zip
wget https://github.com/grafana/loki/releases/download/v2.2.1/promtail-linux-amd64.zip
sudo unzip promtail-linux-amd64.zip

echo " Creating systemd configs "
sudo cat <<EOF >/etc/systemd/system/promtail.service
[Unit]
Description=Promtail service
After=network.target

[Service]
Type=simple
#User=promtail
ExecStart=/opt/loki/promtail-linux-amd64 -config.file /opt/loki/promtail-local-config.yaml
Restart=always

[Install]
WantedBy=multi-user.target
EOF
echo " Starting promtail service "
sudo systemctl start promtail.service
sudo systemctl enable promtail.service

sudo cat <<EOF >/etc/systemd/system/loki.service
[Unit]
Description=Loki service
After=network.target

[Service]
Type=simple
#User=loki
ExecStart=/opt/loki/loki-linux-amd64 -config.file /opt/loki/loki-local-config.yaml
Restart=always

[Install]
WantedBy=multi-user.target
EOF
echo " Starting loki service "
sudo systemctl start loki.service
sudo systemctl enable loki.service


sudo systemctl status promtail
sudo systemctl status loki

echo " Installing grafana "
sudo apt-get install -y apt-transport-https
sudo apt-get install -y software-properties-common wget$ wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -$ echo "deb https://packages.grafana.com/enterprise/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list$ sudo apt-get update
sudo apt-get install grafana$ sudo systemctl daemon-reload
sudo systemctl start grafana-server
sudo systemctl enable grafana-server


sudo systemctl status grafana-server


echo " log in to grafana using http://localhost:3000/login "
echo " default username and password are (admin) "
