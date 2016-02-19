#!/bin/sh
#
# Vagrant provisioning script to start and configure Docker registry proxy
#
# Copyright(C) 2016 John Kinsella <jlkinsel@gmail.com>
#
###
sudo docker run -d --restart=always -p 5000:5000 --name v2-mirror \
    -v /vagrant/data:/var/lib/registry registry:2 /var/lib/registry/config.yml
