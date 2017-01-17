#!/bin/bash

ansible cpanel -i ansible.hosts  -a "cat /usr/local/cpanel/version"

