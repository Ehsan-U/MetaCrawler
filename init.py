import sh
import os
from loguru import logger
import sys
import time


def run_terraform():
    logger.info("Running Terraform")
    os.chdir('./DevOps/IAC')
    sh.terraform("destroy", "-auto-approve", _out=sys.stdout, _err=sys.stderr)
    time.sleep(10)
    sh.terraform("apply", "-auto-approve", _out=sys.stdout, _err=sys.stderr)
    sh.python3("update_inventory.py", _out=sys.stdout, _err=sys.stderr)
    os.chdir("../../")    
    logger.info("Terraform run complete")
    time.sleep(30)


def run_ansible():
    logger.info("Running Ansible")
    os.chdir('./DevOps/Management')
    print(os.getcwd())
    sh.sed("-i", "s/remote_user=.*/remote_user=root/", "ansible.cfg")
    sh.ansible_playbook("bootstrap.yml", "--become-password-file", "sudo_password.txt", _out=sys.stdout, _err=sys.stderr)
    sh.sed("-i", "s/remote_user=.*/remote_user=simone/", "ansible.cfg", _out=sys.stdout, _err=sys.stderr)
    sh.ansible_playbook("init_k8s.yml", _out=sys.stdout, _err=sys.stderr)
    with open("kubeadm_init_stdout.txt", 'r') as f:
        join_string = f.read().split("each as root:")[-1].strip()
    with open("../Bash/join_k8s.sh", 'w') as f:
        f.write(join_string)
    sh.ansible_playbook("join_k8s.yml", _out=sys.stdout, _err=sys.stderr)


run_terraform()
run_ansible()