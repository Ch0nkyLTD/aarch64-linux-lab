#!/bin/bash 
vm=gateway

sudo virsh shutdown $vm
sudo virsh destroy $vm
sudo virsh undefine  gateway --nvram  --remove-all-storage

vm=jail
sudo virsh shutdown $vm
sudo virsh destroy $vm
sudo virsh undefine  jail --nvram  --remove-all-storage
