#!/bin/bash
# Author: ServerOk
# Web: https://serverok.in
# Description: Secure php.ini on Cpanel Server.

sed -i 's/enable_dl = On/enable_dl = Off/g' /opt/alt/php44/etc/php.ini
sed -i 's/enable_dl = On/enable_dl = Off/g' /opt/alt/php51/etc/php.ini
sed -i 's/enable_dl = On/enable_dl = Off/g' /opt/alt/php52/etc/php.ini
sed -i 's/enable_dl = On/enable_dl = Off/g' /opt/alt/php53/etc/php.ini
sed -i 's/enable_dl = On/enable_dl = Off/g' /opt/alt/php54/etc/php.ini
sed -i 's/enable_dl = On/enable_dl = Off/g' /opt/alt/php55/etc/php.ini
sed -i 's/enable_dl = On/enable_dl = Off/g' /opt/alt/php56/etc/php.ini
sed -i 's/enable_dl = On/enable_dl = Off/g' /opt/alt/php70/etc/php.ini
sed -i 's/enable_dl = On/enable_dl = Off/g' /opt/alt/php71/etc/php.ini
sed -i 's/enable_dl = On/enable_dl = Off/g' /opt/alt/php72/etc/php.ini
sed -i 's/enable_dl = On/enable_dl = Off/g' /opt/alt/php73/etc/php.ini
sed -i 's/enable_dl = On/enable_dl = Off/g' /opt/alt/php74-imunify/etc/php.ini
sed -i 's/enable_dl = On/enable_dl = Off/g' /opt/alt/php74/etc/php.ini
sed -i 's/enable_dl = On/enable_dl = Off/g' /opt/cpanel/ea-php74/root/etc/php.ini

sed -i 's/^disable_functions =.*/disable_functions = show_source, system, shell_exec, passthru, exec, popen, proc_open/g' /opt/alt/php44/etc/php.ini
sed -i 's/^disable_functions =.*/disable_functions = show_source, system, shell_exec, passthru, exec, popen, proc_open/g' /opt/alt/php51/etc/php.ini
sed -i 's/^disable_functions =.*/disable_functions = show_source, system, shell_exec, passthru, exec, popen, proc_open/g' /opt/alt/php52/etc/php.ini
sed -i 's/^disable_functions =.*/disable_functions = show_source, system, shell_exec, passthru, exec, popen, proc_open/g' /opt/alt/php53/etc/php.ini
sed -i 's/^disable_functions =.*/disable_functions = show_source, system, shell_exec, passthru, exec, popen, proc_open/g' /opt/alt/php54/etc/php.ini
sed -i 's/^disable_functions =.*/disable_functions = show_source, system, shell_exec, passthru, exec, popen, proc_open/g' /opt/alt/php55/etc/php.ini
sed -i 's/^disable_functions =.*/disable_functions = show_source, system, shell_exec, passthru, exec, popen, proc_open/g' /opt/alt/php56/etc/php.ini
sed -i 's/^disable_functions =.*/disable_functions = show_source, system, shell_exec, passthru, exec, popen, proc_open/g' /opt/alt/php70/etc/php.ini
sed -i 's/^disable_functions =.*/disable_functions = show_source, system, shell_exec, passthru, exec, popen, proc_open/g' /opt/alt/php71/etc/php.ini
sed -i 's/^disable_functions =.*/disable_functions = show_source, system, shell_exec, passthru, exec, popen, proc_open/g' /opt/alt/php72/etc/php.ini
sed -i 's/^disable_functions =.*/disable_functions = show_source, system, shell_exec, passthru, exec, popen, proc_open/g' /opt/alt/php73/etc/php.ini
sed -i 's/^disable_functions =.*/disable_functions = show_source, system, shell_exec, passthru, exec, popen, proc_open/g' /opt/alt/php74-imunify/etc/php.ini
sed -i 's/^disable_functions =.*/disable_functions = show_source, system, shell_exec, passthru, exec, popen, proc_open/g' /opt/alt/php74/etc/php.ini
sed -i 's/^disable_functions =.*/disable_functions = show_source, system, shell_exec, passthru, exec, popen, proc_open/g' /opt/cpanel/ea-php74/root/etc/php.ini

