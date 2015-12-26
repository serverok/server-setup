#!/bin/bash

sysctl --all | grep ptrace
# http://docs.cloudlinux.com/index.html?ptrace_block.html
echo "kernel.user_ptrace = 0" >> /etc/sysctl.conf
sysctl -p
sysctl --all | grep ptrace
echo "done..."
