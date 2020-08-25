# Work dir is "/home/artem_s_shestakov/nginx"
# Install NGINX on Ubuntu
sudo apt-get update
sudo apt-get install nginx -y

# Stop service after installation
sudo systemctl stop nginx.service

# Generating DH parameters, 4096 bit long safe prime
openssl dhparam -out /home/artem_s_shestakov/nginx/dhparam/dhparam.pem 4096

# Copy config file to NGINX conf.d directory
cp default.conf /etc/nginx/conf.d/

# Test NGINX config
sudo nginx -t

# Enable and start service
sudo systemctl enable nginx.service
sudo systemctl start nginx.service
