#!/bin/bash
# note this delates all the vms!
vm=gateway

sudo virsh shutdown $vm
sudo virsh destroy $vm
sudo virsh undefine $vm --nvram --remove-all-storage

vm=jail
sudo virsh shutdown $vm
sudo virsh destroy $vm
sudo virsh undefine $vm --nvram --remove-all-storage
