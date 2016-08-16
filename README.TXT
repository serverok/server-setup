===============================================
Copying Files to New Server
===============================================

rsync -avz "-e ssh -p 22" ~/www/server-setup/ root@NEW-SERVER-IP:/root/server-setup/
