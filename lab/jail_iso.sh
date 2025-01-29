#!/usr/bin/env bash


vm_name='jail'
vm_memory='2048'
vm_cpus='2'
vm_disk='/var/lib/libvirt/images/jail.qcow2'
nat_mac='52:54:00:9b:5a:40'
ci_user_data='user-data'
ci_dataiso='/var/lib/libvirt/images/ci_jail.iso'


virt-install \
    --connect qemu:///system \
    --name "$vm_name" \
    --memory "$vm_memory" \
    --arch aarch64 \
    --vcpus "$vm_cpus" \
    --cpu host-passthrough \
    --import \
    --disk "$ci_dataiso",device=cdrom \
    --osinfo name=ubuntu22.04 \
    --disk "$vm_disk" \
    --network network=nat-net,model=virtio,mac=$nat_mac \
    --network network=malware-private,model=virtio \
    --virt-type kvm
