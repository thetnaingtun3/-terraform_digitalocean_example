#!/bin/bash

# Log all output to /var/log/my-app-setup.log for debugging
exec > >(tee /var/log/my-app-setup.log | logger -t user-data) 2>&1

# Update package lists
apt-get update -y

# Install dependencies for adding Node.js PPA
apt-get install -y curl
apt-get install -y nginx
systemctl start nginx
systemctl enable nginx


# Add Node.js 20.x repository
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -

# Install Node.js 20
apt-get install -y nodejs

# Install Git
apt-get install git -y

# Install PM2 globally
npm install pm2 -g

# Clone the app from GitHub

git clone https://github.com/thetnaingtun3/terraform_nodejs_test.git /app

# Change directory to app
cd /app

# Install npm dependencies
npm install
npm run build

# Start the app using PM2
pm2 start npm --name "app" -- start

cd /etc/nginx/sites-available

touch nextjs

echo '
 server {

  server_name thetnainghtun.me;

  location / {
    proxy_pass http://localhost:3000;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_cache_bypass $http_upgrade;
  }


}
server {
    if ($host = thetnainghtun.me) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    if ($host = wasotech.com.mm) {
        return 301 https://$host$request_uri;
    } # managed by Certbot



  listen 80;

  server_name thetnainghtun.me;
    return 404; # managed by Certbot




}' > nextjs

sudo ln -s /etc/nginx/sites-available/nextjs /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx.service 

