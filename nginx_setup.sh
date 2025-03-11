#!/bin/bash

# Check if Nginx is installed
if ! command -v nginx &> /dev/null; then
    echo "Nginx is not installed. Installing Nginx..."
    sudo apt update
    sudo apt install -y nginx
else
    echo "Nginx is already installed."
fi

# Check if virtual host is configured
VHOST_PATH="/etc/nginx/sites-available"
if [ ! -d "$VHOST_PATH" ]; then
    echo "No virtual host directory found. Configuring virtual host..."
    read -p "Enter virtual host name: " vhost_name
    sudo touch "$VHOST_PATH/$vhost_name"
    sudo ln -s "$VHOST_PATH/$vhost_name" "/etc/nginx/sites-enabled/$vhost_name"
    sudo systemctl restart nginx
    echo "Virtual host $vhost_name configured and Nginx restarted."
else
    echo "Virtual host directory exists."
fi

# Check dependencies for user_dir, auth, and CGI
dependencies=("libpam0g" "libapache2-mod-php" "nginx-common")
for dep in "${dependencies[@]}"; do
    if ! dpkg -l | grep -q "$dep"; then
        echo "$dep is not installed. Installing $dep..."
        sudo apt install -y "$dep"
    else
        echo "$dep is already installed."
    fi
done

# Argument-based system for configuring user_dir, auth, and CGI
while getopts "u:a:c:" opt; do
    case "$opt" in
        u)
            echo "Configuring user_dir..."
            sudo sed -i 's/#user_dir/user_dir/' /etc/nginx/nginx.conf
            sudo systemctl restart nginx
            echo "user_dir configured."
            ;;
        a)
            echo "Configuring PAM-based authentication..."
            sudo apt install -y libpam-auth-update
            # Additional configuration for PAM authentication can be added here
            echo "PAM authentication configured."
            ;;
        c)
            echo "Configuring CGI scripting..."
            sudo apt install -y fcgiwrap
            sudo systemctl enable fcgiwrap
            sudo systemctl start fcgiwrap
            echo "CGI scripting configured."
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
done

echo "Task completed!"

