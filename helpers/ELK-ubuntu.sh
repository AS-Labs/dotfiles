echo "Installing ELK.."

echo " Adding GPG signing key .."
sleep 2

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

sudo apt-get update && sudo apt-get install apt-transport-https

echo " Adding repo.."

echo "deb https://artifacts.elastic.co/packages/oss-7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update && sudo apt-get install elasticsearch

echo "Starting elasticsearch.."
sleep 3
echo "change network.host in /etc/elasticsearch/elasticsearch.yml"
read -p "Enter to continue.."
sudo systemd start elasticsearch
echo "Checking if elasticsearch is up"
sleep 3
curl http://localhost:9200
echo ""
sleep 3
echo "Installing java"
sudo apt-get install default-jre
echo "java version check"
java -version
echo "installing logstash"
sleep 3
sudo apt-get install logstash
sleep 3
echo "installing kibana"
sudo apt-get install kibana

echo ""
echo "Change kibana config to http://localhost:9200"
echo "location /etc/kibana/kibana.yml"
read -p "Enter to continue.."
sudo systemctl start kibana

echo "Install some agents (metricbeat)"

sleep 3
sudo apt-get install metricbeat
sudo systemctl start metricbeat


echo "Start logstash.."
sleep 3
sudo systemctl start logstash
