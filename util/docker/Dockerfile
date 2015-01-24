FROM ubuntu:trusty

MAINTAINER Franz Pletz <fpletz@fnordicwalking.de>

WORKDIR /root

ENV DEBIAN_FRONTEND=noninteractive

ADD fastestmirror.list /etc/apt/sources.list

ADD prepare.sh puppet.sh vagrant.sh /root/

RUN ./prepare.sh
RUN ./puppet.sh
RUN ./vagrant.sh

# re-enable init
RUN rm /usr/sbin/policy-rc.d; rm /sbin/initctl; dpkg-divert --rename --remove /sbin/initctl

RUN rm -v /root/*.sh
RUN apt-get clean

CMD ["/sbin/init"]
