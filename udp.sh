#!/bin/bash

# Setup UDP Custom
sudo su
sysctl -w net.core.rmem_max=16777216
sysctl -w net.core.wmem_max=16777216
iptables -I INPUT -m state --state NEW -m udp -p udp --dport $Port -j ACCEPT
iptables -t nat -I POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
echo 1 > /proc/sys/net/ipv4/ip_forward

# Instalasi UDP Custom
wget -q -O /usr/local/bin/udp-custom "https://raw.githubusercontent.com/FunyVPN/udp-custom/main/udp-custom-linux-amd64"
chmod +x /usr/local/bin/udp-custom

# Buat Service
cat <<EOF > /etc/systemd/system/udp-custom.service
[Unit]
Description=UDP Custom VPN
After=network.target

[Service]
User=root
ExecStart=/usr/local/bin/udp-custom -ip $IP -port $Port -password $Password
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Jalankan Service
systemctl daemon-reload
systemctl enable udp-custom
systemctl start udp-custom
