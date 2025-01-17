#!/bin/bash 
vm=gateway
sudo virsh shutdown $vm
sudo virsh undefine  gateway --nvram  --remove-all-storage


