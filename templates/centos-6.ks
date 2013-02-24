text
skipx
install
url --url http://mirror.myip.be/pub/centos/6/os/x86_64/
repo --name=epel --baseurl=http://download.fedoraproject.org/pub/epel/6/x86_64/
repo --name=updates --baseurl=http://mirror.myip.be/pub/centos/6/updates/x86_64/

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
logvol / --fstype ext4 --fsoptions="noatime" --name=lv_root --vgname=vg_{{ inventory_hostname }}_root --size=4096
logvol swap --fstype swap --name=lv_swap --vgname=vg_{{ inventory_hostname }}_root --size 1024

network --bootproto=dhcp --hostname={{ inventory_hostname }}

services --enabled=network,ntpd,ntpdate

poweroff

%packages --nobase
epel-release
openssh-clients
openssh-server
yum
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
