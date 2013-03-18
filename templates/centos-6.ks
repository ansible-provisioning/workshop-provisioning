text
skipx
install
url --url {{ packages_url }}/tree
repo --name=updates --baseurl {{ packages_url }}/centos

lang en_US.UTF-8
keyboard us
rootpw 123456
firewall --disabled
authconfig --enableshadow --passalgo=sha512
selinux --disabled
timezone Etc/UTC

bootloader --location=mbr
zerombr
clearpart --all --initlabel
part /boot --fstype ext4 --fsoptions="noatime" --size=200
part pv.1 --size 1 --grow
volgroup vg_{{ inventory_hostname }}_root --pesize=4096 pv.1
logvol / --fstype ext4 --fsoptions="noatime" --name=lv_root --vgname=vg_{{ inventory_hostname }}_root --size=8192
logvol swap --fstype swap --name=lv_swap --vgname=vg_{{ inventory_hostname }}_root --size 1024

network --bootproto=static --hostname={{ inventory_hostname }} --ip={{ ip }} --netmask=255.255.255.0 --gateway={{ host_ip }} --nameserver={{ host_ip }}

services --enabled=network,ntpd,ntpdate

poweroff

%packages --nobase
#epel-release
openssh-clients
openssh-server
yum
createrepo
acpid
vixie-cron
cronie-noanacron
crontabs
logrotate
ntp
ntpdate
rsync
which
wget
-postfix
-prelink
-selinux-policy-targeted
%end

%post
### Install the SSH key
mkdir /root/.ssh/
cat <<EOF >/root/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCa4iPbNVUYq7Ibkvj/9qI8CmSqRRCXQ/SAg9OA7Md/1UjSMELiMZsGu4A1LHpl4ER8nIet/w78p0amueIYgvX7oVY0+3fkXRqhJzqzoFVG8GzRZgpk9z8qX8aa3Dtq4rIGBH9st5hEcp3xkeap4+sv9xDd6X8Bd5gvYaCwvbU/vlgE6iYNpp45QNEaUOx50jHD3zPU6jShuJm/SnKmxW2HjXMY9DesYil5Dh2ixrYHoFjT1G/S1y+5plpTmylymd73oeu2cl04ImfT99Iufn7GAgjisSSDFC4o04jzm8bAzMKPf8/0iN1UrHmuR9rvmRqo3yWb7LTYdygSmqDOe5FB ansible@workshop
EOF
chmod 0700 /root/.ssh
chmod 0600 /root/.ssh/authorized_keys
restorecon -R /root/.ssh
