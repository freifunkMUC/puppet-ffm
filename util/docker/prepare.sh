#!/bin/bash -xe

apt-get update
apt-get install -y postfix rsyslog sudo zip tar rsync openssh-client wget curl openssh-server unzip

locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8

# remove some pointless services
/usr/sbin/update-rc.d -f ondemand remove; \
  ( \
    cd /etc/init; \
    for f in \
      u*.conf \
      tty[2-9].conf \
      plymouth*.conf \
      hwclock*.conf \
    ; do \
      mv $f $f.orig; \
    done \
  ); \
  echo '' > /lib/init/fstab

# hack to get into runlevel 2
cat << EOF > /etc/init/rc-runlevel2.conf
start on filesystem
script
  telinit 2
end script
EOF
