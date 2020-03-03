#!/bin/bash
# Backup Web Site to remove server
# Author: admin@ServerOk.in
# Web: https://serverok.in

DAY_OF_WEEK=$(date +"%w")
DAY_OF_MONTH=$(date +"%d")
DATE_TODAY=$(date +"%Y-%m-%d")

if [ "${DAY_OF_WEEK}" == "0" ]; then
    BACKUP_TYPE="weekly"
elif [ "${DAY_OF_MONTH}" == "01" ]; then
    BACKUP_TYPE="monthly"
else
    BACKUP_TYPE="daily"
fi

mysql -e "show databases" | grep -v "+-" | grep -v "Database" | grep -v "information_schema" | grep -v "performance_schema" | grep -v "mysql" > /tmp/dbs_list.txt

for db in `cat /tmp/dbs_list.txt`
do
    /usr/bin/mysqldump $db > /home/your-domain.com/mysql/$db.sql
    if [ $? -ne 0 ]; then
        echo "Backup DB filed ${db}" | mail -s "Backup DB filed ${db}" you@yourdomain.com
    fi
done

echo "Last backup on ${DATE_TODAY}. Backup Type = ${BACKUP_TYPE}" >  /home/your-domain.com/backup.txt

rsync -avzP --delete "-e ssh -p 3333" --exclude /html/wp-content/cache/ /home/your-domain.com/ root@51.159.34.98:/backup/${BACKUP_TYPE}/
