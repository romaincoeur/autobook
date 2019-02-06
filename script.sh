#!/bin/sh

# usage :
# ./scritp.sh <email> <password> <time(12:30:00)>

# Print datetime
dt=$(date '+%d/%m/%Y %H:%M:%S');
echo "$dt"

# Get access token
token=`curl -s -c cookies.txt https://espacemembre.movidaclub.fr/AdelyaClientSpe/movida/home.jsp | grep token | cut -d' ' -f4 | sed -e 's/^"//' -e 's/";$//'`
echo "token : $token"

# Login
message=`curl -s -c cookies.txt -b cookies.txt -d "login=$1&password=$2&token=$token" -X POST 'https://espacemembre.movidaclub.fr/AdelyaClientSpe/movida/process/processConnect.jsp' | grep message | cut -d'"' -f8`
echo "message : $message"

# Ajouter message dans le fichier cookies.txt
tail -n 1 cookies.txt | sed -e 's/SERVERID/password/g' | sed -e "s/cwt/${message}/g" | sed -e "s/asp/${message}/g" | sed -e "s/asp2/${message}/g" >> cookies.txt

# Get new token
token=`curl -s -b cookies.txt 'https://espacemembre.movidaclub.fr/AdelyaClientSpe/movida/home.jsp' | grep token | cut -d' ' -f4 | sed -e 's/^"//' -e 's/";$//'`
echo "token : $token"

# fetch calendar events
events=`curl -s -b cookies.txt "https://espacemembre.movidaclub.fr/AdelyaClientSpe/movida/process/loadCalendarEvents.jsp?token=$token&id=14723627&idGroup=1257&category=Fitness" | jq -c '[.[] | {start:.dtstart, id:.id}]'`

# Make reservation
nextDate=$(date --date="+6 day" '+%Y-%m-%d')
nextDateTime="$nextDate $3"

echo $events | jq -c '.[]' | while read event; do
	dateTime=`echo $event | jq '.start' | sed -e 's/^"//' -e 's/"$//'`
	if [ "$dateTime" = "$nextDateTime" ]
	then
		id=`echo $event | jq '.id'`
		echo "reservation made onto $id"
		resa=`curl -s -b cookies.txt "https://espacemembre.movidaclub.fr/AdelyaClientSpe/movida/process/processResa.jsp?idEntry=$id&status=reserve&action=makeResa"`
		echo `echo $resa | jq '.code'`
	fi
done
