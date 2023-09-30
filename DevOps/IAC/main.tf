






##################### Proxmo #######################



# resource "proxmox_vm_qemu" "cloudinit-VM" {
#     count = length(var.nodes)
#     name = var.nodes[count.index]

#     target_node = "pve"
#     pool = "pool0"
#     clone = "Base-Template"
#     agent = 1
#     os_type = "cloud-init"
#     cores = 2
#     sockets = 1
#     vcpus = 0
#     cpu = "host"
#     memory = "3072"
#     scsihw = "virtio-scsi-single"

#     disk {
#         size = "32G"
#         type = "scsi"
#         storage = "thpl"
#         iothread = 1
#         ssd = 1
#         discard = "on"
#     }

#     network {
#         model = "virtio"
#         bridge = "vmbr0"
#     }

#     ciuser = "ubuntu"
#     cipassword = "toor"
#     ipconfig0 = "ip=192.168.0.${count.index + 25}/24,gw=192.168.0.1"
#     sshkeys = <<EOF
#         ${var.ssh_public_key}
#     EOF
    
#     cloudinit_cdrom_storage = "thpl"

# }

# output "instance_public_ips" {
#   value = { for ins in proxmox_vm_qemu.cloudinit-VM: ins.name => ins.ipconfig0 }
#   description = "The public IPs of the instances"
# }




##################### GCP #######################




# resource "google_compute_firewall" "default" {
#     name = "kubernetesfirewall"
#     network = "default"

#     allow {
#       protocol = "tcp"
#       ports = ["6443", "2379-2380", "10250", "10259", "10257", "30000-32767", "80"]
#     }

#     source_ranges = ["0.0.0.0/0"]
# }


# resource "google_compute_instance" "default" {
#     count = length(var.nodes) 
#     name = var.nodes[count.index]

#     machine_type = "e2-standard-2"
#     zone = "us-central1-a"

#     boot_disk {
#       initialize_params {
#         size = 50
#         image = "ubuntu-os-cloud/ubuntu-2204-lts"
#       }
#     }

#     network_interface {
#         network = "default"
#         access_config {
#           // Ephemeral IP
#         }
#     }

#     metadata = {
#       ssh-keys = "ubuntu:${var.ssh_public_key}"
#     }
# }

# output "instance_public_ips" {
#   value = { for ins in google_compute_instance.default: ins.name => ins.network_interface[0].access_config[0].nat_ip }
#   description = "The public IPs of the instances"
# }



##################### DigitalOcean #######################


resource "digitalocean_ssh_key" "default" {
  name       = "sshansiblekey"
  public_key = file("/home/hp/.ssh/ansible.pub")
}

resource "digitalocean_droplet" "cluster" {
  image  = "ubuntu-22-04-x64"
  count = length(var.nodes)
  name   = var.nodes[count.index]
  region = "blr1"
  size   = "s-2vcpu-2gb"
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
}
