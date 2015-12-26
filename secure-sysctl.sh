#!/bin/bash

sysctl --all | grep ptrace
echo "kernel.user_ptrace = 0" >> /etc/sysctl.conf
sysctl -p
sysctl --all | grep ptrace
echo "done..."
