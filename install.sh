#!/bin/bash
#POSTGRES
sudo apt-get update
sudo apt-get install postgresql postgresql-contrib
sudo -u postgres psql -c "CREATE DATABASE mattermostdb;"
sudo -u postgres psql -c "CREATE USER matteruser WITH PASSWORD 'matterpassword';"
sudo -u postgres psql -c "grant all privileges on database mattermostdb to matteruser;"
#MATTERMOST
sudo useradd -m -s /bin/bash -p matter matter
sudo wget "http://releases.mattermost.com/3.4.0/mattermost-3.4.0-linux-amd64.tar.gz" -P /home/matter/ --user-agent="Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:26.0) Gecko/20100101 Firefox/26.0"
cd /home/matter/ && tar -xzvf mattermost-3.4.0-linux-amd64.tar.gz
mkdir /home/matter/mattermost/data
sudo rm /home/matter/mattermost/config/config.json
sudo cp /TP3BASH/config.json /home/matter/mattermost/config/config.json
sudo cp /TP3BASH/mattermost.service /etc/systemd/system/mattermost.service
chown -R matter:matter /home/matter/
systemctl daemon-reload
systemctl start mattermost
apt install net-tools
netstat -plntu
#NGINX
sudo apt-get install nginx
mkdir /etc/nginx/ssl/ && cd /etc/nginx/ssl/ 
openssl req -new -x509 -days 365 -nodes -out /etc/nginx/ssl/mattermost.crt -keyout /etc/nginx/ssl/mattermost.key
chmod 400 /etc/nginx/ssl/mattermost.key
sudo cp /TP3BASH/mattermost /etc/nginx/sites-available/mattermost
ln -s /etc/nginx/sites-available/mattermost /etc/nginx/sites-enabled/
systemctl restart nginx