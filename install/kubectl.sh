#!/bin/bash
# Author: admin@serverOk.in
# Web: https://www.serverok.in
# Install kubectl on linux

curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
