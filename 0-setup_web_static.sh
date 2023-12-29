#!/usr/bin/env bash
# sets up web servers for the deployment of web_static.

# Update package list and install Nginx
apt update -y
apt install nginx -y

# Allow HTTP traffic through the firewall for Nginx
ufw allow 'Nginx HTTP'

# Create directory structure for the web application
mkdir -p /data/web_static/releases/test/
mkdir -p /data/web_static/shared/

# Create a fake HTML file 
echo "<html>
  <head>
  </head>
  <body>
    Pasej5 you got this
  </body>
</html>" > /data/web_static/releases/test/index.html

# Create a symbolic link for the web application
ln -sf /data/web_static/releases/test/ /data/web_static/current

# Change ownership of the /data directory and its contents
chown -R ubuntu:ubuntu /data

# Modify Nginx configuration to serve static files from /data/web_static/current/ when /hbnb_static/ is requested

sed -i '/listen 80 default_server/a location /hbnb_static/ { alias /data/web_static/current/;}' /etc/nginx/sites-available/default

# Restart the Nginx service to apply the changes in the configuration
service nginx restart
