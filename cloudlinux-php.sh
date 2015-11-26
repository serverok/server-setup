#!/bin/bash

yum install -y lvemanager
yum groupinstall -y alt-php
yum update -y cagefs lvemanager

