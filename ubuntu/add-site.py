#!/usr/bin/python3
# Author: ServerOK Software
# Web: https://serverok.in
# Mail: admin@serverok.in
# Create web site in Nginx.

import sys
import re
import pwd
import random
import os
import crypt
import requests

def update_password(password, char):
    replace_index = random.randrange(len(password)-1)
    if (replace_index == 0):
        replace_index = 3;
    return password[0:replace_index] + str(char) + password[replace_index+1:]

def generate_password():
    password_chars = "abcdefghjkmnpqrstuvwxyz234567890"
    my_password = ""
    have_number = False
    for i in range(12):
        next_index = random.randrange(len(password_chars))
        if (i < 2):
            next_index = random.randrange(10)
            my_char = password_chars[next_index].upper()
        elif (random.randrange(10) > 5):
            my_char = password_chars[next_index].upper()
        else:
            my_char = password_chars[next_index]
        if i == 12:
            if not have_number:
                my_char =  str(random.randrange(0,9))
        if my_char.isdigit():
            have_number = True;
        my_password = my_password + my_char
    return my_password

def verify_domain(domain_name):
    if not re.match("^([A-Za-z0-9\.]+)$", domain_name): 
        print("Invalid domain name:", domain_name)
        sys.exit(1)

def linux_user_exists(username):
    try:
        user_info = pwd.getpwnam(username)
        return True
    except KeyError:
        return False

def generate_username(domain_name):
    username = ""
    for character in domain_name:
        if character.isalnum():
            username += character
        if len(username) > 7 and not linux_user_exists(username):
            break
    return username

def linux_add_user(domain_name, username, password):
    encPass = crypt.crypt(password,"22")
    os.system("useradd -m -s /bin/bash -d /home/" + domain_name + "/ -p " + encPass + " " + username)

def get_url_content(url):
    f = requests.get(url)
    return f.text

def create_phpfpm_config(username):
    content = get_url_content("https://raw.githubusercontent.com/serverok/server-setup/master/data/debian/php-fpm-pool.txt")
    content = content.replace("POOL_NAME", username)
    content = content.replace("FPM_USER", username)
    file_location = "/etc/php/7.4/fpm/pool.d/" + username + ".conf"
    fpm_file = open(file_location,'w')
    fpm_file.write(content)
    fpm_file.close()

def create_nginx_config(domain_name, username):
    content = get_url_content("https://raw.githubusercontent.com/serverok/server-setup/master/data/debian/nginx-vhost-ssl.txt")
    content = content.replace("POOL_NAME", username)
    content = content.replace("FQDN", domain_name)
    file_location = "/etc/nginx/sites-enabled/" + domain_name + ".conf"
    fpm_file = open(file_location,'w')
    fpm_file.write(content)
    fpm_file.close()

def find_ip():
    r = requests.get("http://checkip.amazonaws.com")
    if r.status_code == 200:
        ip = r.text
        ip = ip.strip()
        return ip
    else:
        print("Failed to find IP address")
        os.exit(1)


domain_name = input("Enter domain name: ")
domain_name = domain_name.strip()

verify_domain(domain_name)
username = generate_username(domain_name)
password = generate_password()
password_mysql = generate_password()
ip_address = find_ip()

linux_add_user(domain_name, username, password)

create_phpfpm_config(username)
create_nginx_config(domain_name, username)

doc_root = "/home/" + domain_name + "/html/"
os.system("mkdir " + doc_root)
os.system("chown -R " + username + ":" + username + " " + doc_root)
os.system("chmod -R 755 /home/" + domain_name)
os.system("chmod -R 755 /home/" + domain_name)
os.system("openssl genrsa -out /etc/ssl/" + domain_name + ".key 2048")
os.system("openssl req -new -x509 -key /etc/ssl/{}.key -out /etc/ssl/{}.crt -days 3650 -subj /CN={}".format(domain_name, domain_name, domain_name))

os.system("systemctl restart php7.4-fpm")
os.system("systemctl restart nginx")


print("SFTP " + domain_name + "\n")
print("IP = {}".format(ip_address))
print("Port = 22")
print("User = " + username)
print("PW = " + password + "\n")

print("MySQL\n")

print("DB = {}_db".format(username))
print("User = {}_db".format(username))
print("PW = {}".format(password_mysql))

print("\n")
print("phpMyAdmin\n")

print("http://{}:8080".format(ip_address))
print("User = {}_db".format(username))
print("PW = {}".format(password_mysql))

print("\n")

print("certbot --authenticator webroot --webroot-path /home/" + domain_name + "/html/ --installer nginx -m admin@serverok.in --agree-tos --no-eff-email -d " + domain_name + " -d www." + domain_name)
print("mysql")
print("create database {}_db;".format(username))
print("grant all on {}_db.* to '{}_db'@'localhost' identified by '{}';".format(username, username, password_mysql))
