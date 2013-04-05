network --bootproto=static --hostname={{ inventory_hostname }} --ip={{ ip }} --netmask=255.255.255.0 --gateway={{ host_ip }} --nameserver={{ host_ip }}
url --url {{ packages_url }}/minimal
repo --name=workshop --baseurl {{ packages_url }}/workshop

services --enabled=network,postfix,rsyslog --disabled=iptables,iptables-ipv6,rawdevices

install
text
skipx
poweroff

lang en_US.UTF-8
keyboard us
timezone Etc/UTC
rootpw root
firewall --disabled
authconfig --enableshadow --passalgo=sha512
selinux --disabled

zerombr
bootloader --location=mbr
clearpart --all --initlabel
part /boot  --fstype=ext4 --size=200 --fsoption=noatime
part pv.1 --size 1 --grow
volgroup vg_{{ inventory_hostname }}_root --pesize=4096 pv.1
logvol /    --fstype=ext4 --name=lv_root --vgname=vg_{{ inventory_hostname }}_root --size=2048 --fsoptions=noatime
logvol swap --fstype=swap --name=lv_swap --vgname=vg_{{ inventory_hostname }}_root --size=512

%packages --nobase
-b43-openfwwf
-bridge-utils
-device-mapper-multipath
-iptables-ipv6
-iscsi-initiator-utils
-prelink
-selinux-policy
-selinux-policy-targeted
-system-config-firewall-base
createrepo
crontabs
logrotate
man
man-pages
openssh-clients
openssh-server
postfix
vixie-cron
which
yum
%end

%post
### Install the SSH key
mkdir -m0700 /root/.ssh/
cat <<EOF >/root/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCa4iPbNVUYq7Ibkvj/9qI8CmSqRRCXQ/SAg9OA7Md/1UjSMELiMZsGu4A1LHpl4ER8nIet/w78p0amueIYgvX7oVY0+3fkXRqhJzqzoFVG8GzRZgpk9z8qX8aa3Dtq4rIGBH9st5hEcp3xkeap4+sv9xDd6X8Bd5gvYaCwvbU/vlgE6iYNpp45QNEaUOx50jHD3zPU6jShuJm/SnKmxW2HjXMY9DesYil5Dh2ixrYHoFjT1G/S1y+5plpTmylymd73oeu2cl04ImfT99Iufn7GAgjisSSDFC4o04jzm8bAzMKPf8/0iN1UrHmuR9rvmRqo3yWb7LTYdygSmqDOe5FB ansible@workshop
EOF
chmod 0600 /root/.ssh/authorized_keys
restorecon -R /root/.ssh/
