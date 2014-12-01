#!/bin/bash

#generate csv of accounts on mailstore

mysql -N -e "select concat_ws(',', id, comment, item_id_checkpoint,group_id) from mailbox" zimbra > /tmp/all_checkpoints.txt

#Loop through csv line by line\
OLDIFS=$IFS
IFS=","

#read file line by line, assigning values from csv
while read MID ACCOUNT CHECKPOINT GROUP

do

BIGGESTID=`mysql -N -e "SELECT id FROM mail_item WHERE mailbox_id="$MID" ORDER BY id DESC LIMIT 1" mboxgroup$GROUP`
    if [ $BIGGESTID -gt $CHECKPOINT ] ; then
    echo "$ACCOUNT"
    else
done < /tmp/all_checkpoints.txt
    IFS=$OLDIFS