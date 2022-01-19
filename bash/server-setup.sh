#!/bin/bash
# Bash script for setting up .NET Core 6.0 with ASP.NET Core runtime, NGINX and Certbot

# TODO: Dynamically set .NET version
# TODO: Detect operating system and distribution

dotnet_version="6.0.1"

# Install dotnet 6

if dotnet --list-runtimes | grep -q "Microsoft.AspNetCore.App $dotnet_version"; then
    echo "ASP.NET Core $dotnet_version is already installed, skipping...";
else
    wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb

    # Install ASP.NET Core runtime
    sudo apt-get update; \
    sudo apt-get install -y apt-transport-https && \
    sudo apt-get update && \
    sudo apt-get install -y aspnetcore-runtime-6.0
fi

# Nginx
if dpkg -s nginx | grep -q "Status: install ok installed"; then
    echo "NGINX is already installed, skipping...";
else
    sudo apt-get install -y nginx
fi
# End of NGINX

# Certbot
if snap info certbot | grep -q "installed:"; then
    echo "Certbot already installed, skipping..."
else
    sudo snap install --classic certbot
fi