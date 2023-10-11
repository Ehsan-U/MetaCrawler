

sudo mkdir -p /etc/docker/certs.d/192.168.0.30:443
sudo cp server.crt /etc/docker/certs.d/192.168.0.30:443/server.crt


sudo cp server.crt /usr/local/share/ca-certificates/server.crt
sudo update-ca-certificates
sudo systemctl restart containerd