#!/usr/bin/python

from fabric.api import run, env, execute

env.hosts = ['34.200.10.62']
env.user = 'root'

def uptime():
    run("uptime")

def basic():
    run("apt install -y wget")
    run("wget https://raw.githubusercontent.com/HostOnNet/server-setup/master/ubuntu/1-basic-tools.sh")
    run("sh ./1-basic-tools.sh")
    run("rm -f 1-basic-tools.sh")

def apache():
    run("apt-get -y install apache2")
    run("update-rc.d apache2 enable")
    run("a2enmod rewrite")
    run("apt-get -y install libapache2-mod-php")

def php():
    run("apt-get -y install php php-cli php-curl php-gd php-mysql")
    run("apt-get -y install php-imagick php-imap php-mcrypt php-json php-xml")
    run("apt-get -y install php-mbstring php-zip php-xmlrpc php-soap php-intl")
    run("phpenmod mcrypt")

def mysql():
    run("apt-get -y install mariadb-client mariadb-server")
    run("update-rc.d mysql enable")

