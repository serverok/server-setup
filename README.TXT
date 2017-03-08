===============================================
Copying Files to New Server
===============================================

rsync -avz "-e ssh -p 22" --exclude=.git ~/www/server-setup/ root@NEW-SERVER-IP:/root/server-setup/

Or clone it on server

cd /root
git clone http://git.buyscripts.in:10080/buyscripts/server-setup.git
