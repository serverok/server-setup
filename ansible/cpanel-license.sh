#!/bin/bash

ansible cpanel -i ansible.hosts  -a "/usr/local/cpanel/cpkeyclt"

