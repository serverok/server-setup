#!/usr/bin/python3
# Author: ServerOK
# Web: https://serverok.in
# Mail: admin@serverok.in
# Create web site in Nginx.

# usermod -aG super www-data
# systemctl reload nginx
# setfacl -R -x u:www-data /home/boby.serverok.in
# setfacl -R -m u:www-data:rX /home/boby.serverok.in
# apt-get install acl

import sys
import re
import pwd
import random
import os
import crypt
import requests
import argparse
import subprocess

def verify_php_version(php_version):
    php_socket = "/var/run/php/php" + php_version + "-fpm.sock"
    if not os.path.exists(php_socket):
        print(f"ERROR: PHP version {php_version} not found. Missing socket {php_socket}")
        sys.exit(1)
    else:
        return True

def update_password(password, char):
    replace_index = random.randrange(len(password)-1)
    if (replace_index == 0):
        replace_index = 3;
    return password[0:replace_index] + str(char) + password[replace_index+1:]

def generate_password():
    password_chars = "abcdefghjkmnpqrstuvwxyz234567890"
    my_password = ""
    have_number = False
    for i in range(20):
        next_index = random.randrange(len(password_chars))
        if (i < 2):
            next_index = random.randrange(10)
            my_char = password_chars[next_index].upper()
        elif (random.randrange(10) > 5):
            my_char = password_chars[next_index].upper()
        else:
            my_char = password_chars[next_index]
        if i == 17:
            if not have_number:
                my_char =  str(random.randrange(0,9))
        if my_char.isdigit():
            have_number = True;
        my_password = my_password + my_char
    return my_password

def verify_domain(domain_name):
    if not re.match("^([A-Za-z0-9-\.]+)$", domain_name):
        print("Invalid domain name:", domain_name)
        sys.exit(1)

def verify_password(password):
    if not re.match("^([A-Za-z0-9-\.]+)$", password):
        print("Invalid password:", password)
        sys.exit(1)

def verify_username(username):
    if len(username) > 32:
        print('Error: username must be less than 32 chars')
        sys.exit(1)
    if not re.match("^([A-Za-z0-9]+)$", username):
        print("Invalid user name %s" % username)
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

def create_phpfpm_config(username, php_version):
    content = get_url_content("https://raw.githubusercontent.com/serverok/server-setup/master/config/nginx/php-fpm-pool.txt")
    content = content.replace("POOL_NAME", username)
    content = content.replace("FPM_USER", username)
    file_location = "/etc/php/" + php_version + "/fpm/pool.d/" + username + ".conf"
    fpm_file = open(file_location,'w')
    fpm_file.write(content)
    fpm_file.close()

def create_nginx_config(domain_name, username, app_type):
    if app_type == "laravel":
        content = get_url_content("https://raw.githubusercontent.com/serverok/server-setup/master/config/nginx/vhosts/nginx-laravel-vhost-ssl.txt")
    else:
        content = get_url_content("https://raw.githubusercontent.com/serverok/server-setup/master/config/nginx/vhosts/nginx-vhost-ssl.txt")
    content = content.replace("POOL_NAME", username)
    content = content.replace("FQDN", domain_name)
    file_location = "/etc/nginx/sites-enabled/" + domain_name + ".conf"
    fpm_file = open(file_location,'w')
    fpm_file.write(content)
    fpm_file.close()

def create_apache_config(domain_name, username, app_type):
    content = get_url_content("https://raw.githubusercontent.com/serverok/server-setup/master/config/apache/vhost.conf")
    content = content.replace("POOL_NAME", username)
    content = content.replace("FQDN", domain_name)
    file_location = "/etc/apache2/sites-enabled/" + domain_name + ".conf"
    fpm_file = open(file_location,'w')
    fpm_file.write(content)
    fpm_file.close()

def detect_server():
    try:
        output = subprocess.check_output(['ss', '-nltp'])
    except subprocess.CalledProcessError as e:
        print(f"Error executing ss command: {e}")
        sys.exit(1)

    output_str = output.decode('utf-8').lower()

    if '*:80' in output_str or '0.0.0.0:80' in output_str:
        if 'apache2' in output_str:
            return "apache"
        if 'nginx' in output_str:
            return "nginx"
    
    print("Error: Neither Apache nor Nginx is listening on port 80 or 443.")
    sys.exit(1)

def find_ip():
    r = requests.get("http://checkip.amazonaws.com")
    if r.status_code == 200:
        ip = r.text
        ip = ip.strip()
        return ip
    else:
        print("Failed to find IP address")
        sys.exit(1)


text = 'ServerOK Nginx Manager.'

parser = argparse.ArgumentParser(description=text)
parser.add_argument("-d", "--domain", help="domain name for your web site")
parser.add_argument("-u", "--user", help="user name for your web site")
parser.add_argument("-p", "--password", help="sftp password for site")
parser.add_argument("--php", help="select PHP version. Example --php 8.3")
parser.add_argument("--app", help="select App. Eg --app laravel")

args = parser.parse_args()

if args.domain:
    domain_name = args.domain.strip()
else:
    domain_name = input("Enter domain name: ")
    domain_name = domain_name.strip()

if args.user:
    username = args.user
else:
    print(f"ERROR: Please specify username with -u option.")
    sys.exit(1)

if args.password:
    password = args.password
else:
    password = generate_password()

if args.php:
    php_version = args.php
else:
    print(f"ERROR: Please specify PHP version with --php option.")
    sys.exit(1)

if args.app:
    app_type = args.app.strip()
    if app_type != "laravel":
        app_type = "wp"
else:
    app_type = "wp"

server = detect_server()
print(f"Server = {server}")

verify_php_version(php_version)
verify_username(username)
verify_domain(domain_name)
verify_password(password)

if linux_user_exists(username):
    print(f"ERROR: User {username} already exists!")
    sys.exit(1)

password_mysql = generate_password()
ip_address = find_ip()

linux_add_user(domain_name, username, password)

create_phpfpm_config(username, php_version)

if server == "nginx":
    create_nginx_config(domain_name, username, app_type)
else:
    create_apache_config(domain_name, username, app_type)

doc_root = "/home/" + domain_name + "/html/"
os.system("mkdir " + doc_root)
os.system("chown -R " + username + ":" + username + " " + doc_root)
os.system("chmod -R 750 /home/" + domain_name)
os.system("usermod -aG " + username + " www-data")
os.system("openssl genrsa -out /etc/ssl/" + domain_name + ".key 2048")
os.system("openssl req -new -x509 -key /etc/ssl/{}.key -out /etc/ssl/{}.crt -days 3650 -subj /CN={}".format(domain_name, domain_name, domain_name))

if app_type == "laravel":
    doc_root = "/home/" + domain_name + "/html/public/"
    os.system("mkdir " + doc_root)
    os.system("chown -R " + username + ":" + username + " " + doc_root)

os.system("systemctl restart php" + php_version + "-fpm")

if server == "nginx":
    os.system("systemctl restart nginx")
else:
    os.system("systemctl restart apache2")

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

print("http://{}:7777".format(ip_address))
print("User = {}_db".format(username))
print("PW = {}".format(password_mysql))

print("\n")

if server == "nginx":
    print("certbot --authenticator webroot --webroot-path " + doc_root + " --installer nginx -m admin@serverok.in --agree-tos --no-eff-email -d " + domain_name + " -d www." + domain_name)
else:
    print("certbot --authenticator webroot --webroot-path " + doc_root + " --installer apache -m admin@serverok.in --agree-tos --no-eff-email -d " + domain_name + " -d www." + domain_name)

print("mysql")
print("CREATE DATABASE {}_db;".format(username))
print("CREATE USER '{}_db'@'localhost' IDENTIFIED BY '{}';".format(username, password_mysql))
print("GRANT ALL PRIVILEGES ON {}_db.* TO '{}_db'@'localhost';".format(username, username))
