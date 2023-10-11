#!/bin/bash

# installing container-runtime (containerd)
sudo apt-get update
sudo apt full-upgrade -y
sudo apt-get install ca-certificates curl gnupg -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo rm /etc/apt/keyrings/docker.gpg
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install containerd.io -y
echo "Installed Succesfully"

# # # configuring containerd
sudo rm /etc/containerd/config.toml
sudo mkdir /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i "s/\bSystemdCgroup\s=\sfalse\b/SystemdCgroup = true/g" /etc/containerd/config.toml
sudo systemctl daemon-reload -q
sudo systemctl enable --now containerd
sudo systemctl restart containerd


# # # turn off swap
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

# # # sysctl params required by setup, params persist across reboots
sudo rm /etc/sysctl.d/k8s.conf
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# # Apply sysctl params without reboot
sudo sysctl --system

# # # enable br_netfilter
sudo mkdir /etc/modules-load.d
sudo rm /etc/modules-load.d/k8s.conf 
sudo touch /etc/modules-load.d/k8s.conf 
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter


# install kubelet kubeadm kubectl
sudo rm /etc/apt/keyrings/kubernetes-apt-keyring.gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

