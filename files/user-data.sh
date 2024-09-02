#!/bin/bash
apt-get update -y
apt-get install git -y
apt-get install nodejs -y
apt-get install npm -y

npm install pm2 -g

git clone https://github.com/thetnaingtun3/terraform_nodejs_test.git app
cd app
npm install
pm2 start index.js
tail -f /var/log/cloud-init-output.log