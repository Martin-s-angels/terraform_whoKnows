#!/bin/bash
echo "============================================================================================"
echo "Update packages"
echo "============================================================================================"
sudo apt-get update && sudo apt-get install -y software-properties-common
echo "============================================================================================"
echo "Install Docker and give user permission"
echo "============================================================================================"
sudo apt install -y docker.io
sudo usermod -aG docker $(whoami)
sudo systemctl restart docker
sudo apt install -y docker-compose
sudo apt-get update -y && sudo apt-get upgrade -y

sudo apt-get install -y fail2ban

sudo systemctl enable fail2ban
sudo systemctl start fail2ban

sudo apt-get install -y ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp      
sudo ufw allow 8080/tcp    
sudo ufw enable

sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart sshd

cat <<EOF | sudo tee /etc/fail2ban/jail.d/ssh.conf
[sshd]
enabled = true
port = 22
logpath = %(sshd_log)s
maxretry = 5
EOF
sudo systemctl restart fail2ban
