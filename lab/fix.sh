
disk_size=20G
out_img=jammy-server-cloudimg-arm64.qcow2
out_path="/var/lib/libvirt/images/$out_img"


qemu-img create -f qcow2 -b $out_path -F qcow2 /var/lib/libvirt/images/gateway.qcow2 $disk_size
qemu-img create -f qcow2 -b $out_path -F qcow2 /var/lib/libvirt/images/jail.qcow2 $disk_size


cd jail  && xorriso -as genisoimage -output ci_jail.iso -volid CIDATA -joliet -rock user-data meta-data network-config && cd ../
sudo mv jail/ci_jail.iso /var/lib/libvirt/images

cd gateway && xorriso -as genisoimage -output ci_gateway.iso -volid CIDATA -joliet -rock user-data meta-data network-config && cd ../
sudo mv gateway/ci_gateway.iso /var/lib/libvirt/images

