#!/bin/bash

function ask_yes_or_no() {
    read -p "$1 ([y]es or [N]o): "
    case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        y|yes) echo "yes" ;;
        *)     echo "no" ;;
    esac
}

FIX="false"


#getopts

while getopts 'm:f' flag; do
	case "${flag}" in
		m) MAILBOX="${OPTARG}" ;;
		f) FIX="true" ;;
		*) error "Unexpected option ${flag}";;
	esac
done

#WARN ON FIX
if [ "$FIX" = "true" ]; then
	if [[ "no" == $(ask_yes_or_no "This will make changes to the mySQL databse. Are you sure you want to") ]] ; then
      echo "No changes have been made."
      exit 0
	fi
fi

if [ $MAILBOX ] ; then
	#get account specified with -m
	mysql -N -e "select concat_ws(',', id, comment, item_id_checkpoint,group_id) from mailbox WHERE comment='$MAILBOX'" zimbra > /tmp/all_checkpoints.txt

else

#generate csv of accounts on mailstore
mysql -N -e "select concat_ws(',', id, comment, item_id_checkpoint,group_id) from mailbox" zimbra > /tmp/all_checkpoints.txt

fi

#Loop through csv line by line\
OLDIFS=$IFS
IFS=","

#read file line by line, assigning values from csv
while read MID ACCOUNT CHECKPOINT GROUP

do

BIGGESTID=`mysql -N -e "SELECT MAX(id) FROM mail_item WHERE mailbox_id=$MID" mboxgroup$GROUP`
    if [ $BIGGESTID -gt $CHECKPOINT ] ; then
    	echo "$ACCOUNT"
    	if [ "$FIX" = "true" ] ; then
    		NEWCHECKPOINT=`expr $BIGGESTID + 100`
    		mysql -e "UPDATE zimbra.mailbox SET item_id_checkpoint=$NEWCHECKPOINT WHERE id='$MID' AND comment='$ACCOUNT'"
    		echo "$ACCOUNT item_id_checkpoint updated. Old value: $CHECKPOINT | New value: $NEWCHECKPOINT"
		fi
	fi
done < /tmp/all_checkpoints.txt
echo "You must restart mailboxd for any changes to take effect. If you did not make any changes, you do not need to restart mailboxd."
    IFS=$OLDIFS

