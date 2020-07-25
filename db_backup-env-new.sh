#!/bin/bash

echo -e "\E[30m\033[32mCREATE MySQL BACKUP.\033[0m"

USER="root"
HOST="db"
PORT="3306"
OUTPUT="/home/$SSH_USER"
ARCHIVE="dump"
DATE="`date +%Y.%m.%d`"

echo -e "\E[30m\033[33mHost: $HOST\nPORT: $PORT\nCREDENTIALS: $USER:????\nPath to dump: $OUTPUT:\033[0m"

mkdir -p $OUTPUT/$DATE.backup/db \
	&& cd $OUTPUT \
	&& cp -r /opt/wordpress $DATE.backup/ \
	&& databases=`mysql --user=$USER --password=$MYSQL_ROOT_PASSWORD --port=$PORT --host=$HOST -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`

for db in $databases; do
    if [[ "$db" != "information_schema" ]] && [[ "$db" != _* ]]
    then
        echo -e "\E[30m\033[32mDumping database: $db\033[0m"
        mysqldump --force --opt --lock-tables=0 --user=$USER --password=$MYSQL_ROOT_PASSWORD --host=$HOST --port=$PORT --databases $db > $OUTPUT/$DATE.backup/$db.sql
    echo -e "\E[30m\033[32mBackuped $db\033[0m"
    fi
done

mv $DATE.backup/*.sql $DATE.backup/db \
	&& tar --remove-files -zcvf $ARCHIVE.tar.gz $DATE.backup/ \
	&& scp -o StrictHostKeyChecking=no -i "$OUTPUT/.ssh/$DOCKER_HOST_KEY" "$OUTPUT/$ARCHIVE.tar.gz" $HOST_USER@$D_HOST:~/

#slack message if archive exist
if [[ -e $OUTPUT/$ARCHIVE.tar.gz ]]; then
  slackcli -h "$SLACK_CHANNEL" -t "$SLACK_TOKEN" -u "$SLACK_USER" -m "$SLACK_MESSAGE"
elif [[ ! -e $OUTPUT/$ARCHIVE.tar.gz ]]; then
  echo -e "\E[30m\033[31m[ERROR] Sorry, but dump archive doesn't exist\033[0m"
else
  echo -e "\E[30m\033[31m[Unknown error]\033[0m"
fi

echo -e "\E[30m\033[32mDONE\033[0m"
