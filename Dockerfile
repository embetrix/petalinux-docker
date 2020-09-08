FROM ubuntu:16.04

MAINTAINER Ayoub Zaki <ayoub.zaki@embexus.com> 

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y software-properties-common curl

# Required Packages for the Host Development System
RUN apt-get update && \
	apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib xz-utils debianutils iputils-ping libsdl1.2-dev && \
	apt-get install -y xutils-dev xterm build-essential chrpath socat cpio python python3 python3-pip python3-pexpect libssl-dev \
	apt-get install -y tofrodos iproute net-tools ncurses-dev tftpd zlib1g-dev zlib1g-dev:i386 flex bison ia32-libs lib32ncursesw5 lib32gomp1

# Add OpenSSH
RUN apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd

# Add Vim
RUN apt-get install -y vim

# Create a non-root user that will perform the actual build
RUN id build 2>/dev/null || useradd --uid 1000 --create-home build
RUN apt-get install -y sudo
RUN echo "build ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers

# Fix error "Please use a locale setting which supports utf-8."
RUN apt-get install -y locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# make /bin/sh symlink to bash instead of dash
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

USER build
RUN echo "build:build" | sudo chpasswd
RUN echo -e "\n\n\n" | ssh-keygen -t rsa

COPY gitconfig  /home/build/.gitconfig
COPY ssh_config /home/build/.ssh/config
RUN sudo chown -R build:build /home/build

WORKDIR /home/build
CMD ["/bin/bash"]

EXPOSE 22

# EOF
