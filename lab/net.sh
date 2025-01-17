#!/bin/bash

sudo virsh net-define net/private-net.xml
sudo virsh net-start malware-private
sudo virsh net-autostart  malware-private

sudo virsh net-define net/nat-net.xml
sudo virsh net-start nat-net
sudo virsh net-autostart  nat-net
