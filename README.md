# Quick start
sudo bash setup.sh
sudo bash \*_iso.sh
ansible-playbook playbook.yml -i inventory.ini

# Please see directions in obsidian Vault
https://github.com/Ch0nkyLTD/linux-malware-course-public/tree/main/ObsidianVault/Lab/   




## Testing setup 
Linux spr-2025-test 6.6.51+rpt-rpi-v8 #1 SMP PREEMPT Debian 1:6.6.51-1+rpt3 (2024-10-08) aarch64 GNU/Linux


user@spr-2025-test:~ $ sudo virsh list --all
 Id   Name   State
--------------------

user@spr-2025-test:~ $ systemctl status libvirt
libvirtd-admin.socket   libvirtd-ro.socket      libvirtd.service        libvirtd.socket         libvirtd-tcp.socket     libvirtd-tls.socket     libvirt-guests.service  
user@spr-2025-test:~ $ systemctl status libvirtd.service 
● libvirtd.service - Virtualization daemon
     Loaded: loaded (/lib/systemd/system/libvirtd.service; enabled; preset: enabled)
     Active: active (running) since Thu 2025-03-13 11:18:59 EDT; 15s ago
TriggeredBy: ● libvirtd-ro.socket
             ● libvirtd.socket
             ● libvirtd-admin.socket
       Docs: man:libvirtd(8)
             https://libvirt.org
   Main PID: 21972 (libvirtd)
      Tasks: 19 (limit: 32768)
        CPU: 282ms
     CGroup: /system.slice/libvirtd.service
             └─21972 /usr/sbin/libvirtd --timeout 120

Mar 13 11:18:59 spr-2025-test systemd[1]: Starting libvirtd.service - Virtualization daemon...
Mar 13 11:18:59 spr-2025-test systemd[1]: Started libvirtd.service - Virtualization daemon.
user@spr-2025-test:~ $ 



sudo bash net.sh
## run setup.sh 
ssh-keygen -t ed25519
Generating public/private ed25519 key pair.
Enter file in which to save the key (/home/user/.ssh/id_ed25519): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/user/.ssh/id_ed25519
Your public key has been saved in /home/user/.ssh/id_ed25519.pub
The key fingerprint is:
SHA256:R5Px5Eoa1hzWMBGosHaPVnEanJElS22nPJU84lgrqP8 user@spr-2025-test
The key's randomart image is:
+--[ED25519 256]--+
|       .+BX*..   |
|    .  .B**OB    |
|     o o+@B*o.   |
|    o +.==*o     |
|   . o +S.o.     |
|    . o ..       |
|     o           |
|      .          |
|       .E        |
+----[SHA256]-----+
user@spr-2025-test:~/aarch64-linux-lab/lab $ cat ~/.ssh/
authorized_keys  id_ed25519       id_ed25519.pub   known_hosts      
user@spr-2025-test:~/aarch64-linux-lab/lab $ cat ~/.ssh/id_ed25519.pub 
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC0ndqKfLN3PZ2zDTBQlt1YbT2RwYkCe9MgitCguNOAh user@spr-2025-test


sudo ls /var/lib/libvirt/images
ci_gateway.iso	ci_jail.iso  gateway.qcow2  jail.qcow2	jammy-server-cloudimg-arm64.qcow2



user@spr-2025-test:~/aarch64-linux-lab/lab $ ./change_key.sh  jail "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC0ndqKfLN3PZ2zDTBQlt1YbT2RwYkCe9MgitCguNOAh user@spr-2025-test"
Successfully replaced key in files within jail
user@spr-2025-test:~/aarch64-linux-lab/lab $ ./change_key.sh  gateway  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC0ndqKfLN3PZ2zDTBQlt1YbT2RwYkCe9MgitCguNOAh user@spr-2025-test"
Successfully replaced key in files within gateway
user@spr-2025-test:~/aarch64-linux-lab/lab $ cat jail/
meta-data       network-config  user-data       
user@spr-2025-test:~/aarch64-linux-lab/lab $ cat jail/user-data 
#cloud-config
users:
  - name: user
    groups: wheel
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh_authorized_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC0ndqKfLN3PZ2zDTBQlt1YbT2RwYkCe9MgitCguNOAh user@spr-2025-test



# Known issues 
soemtimes virt-install freezes on initial start. read oops.sh and cleanup frozen vm . if it gets stuck for greater than 30 seconds without seeing any large amounts of logging, its probably stuck 
this only seems to happen when you try running both installs at the same time.  I  have not been abelt to deterministiacally recreate the issue. 
