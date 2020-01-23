#!/bin/sh

# usage :
# ./scritp.sh <email> <password> <time(12:30)> <sportNum>
# TRX=49
# RPM=39

# Print datetime
now=$(date '+%d/%m/%Y %H:%M:%S');
echo "$now"

# Get auth cookie
curl -s -c cookies.txt -b cookies.txt -d "sp_mail=$1&sp_pwd=$2" -X POST 'https://resa-movida.deciplus.pro/sp_accueil.php' > /dev/null

# fetch calendar events
if [ "$(uname -s)" = "Darwin" ]
then
  nextDate=$(date -v+7d +'%d%%2F%m%%2F%Y')
else
  nextDate=$(date --date="+7 day" '+%d%%2F%m%%2F%Y')
fi
hours=$(echo "$3" | cut -d ":" -f 1)
minutes=$(echo "$3" | cut -d ":" -f 2)
timeslot=$((12*hours + minutes/5))
events=$(curl -s -b cookies.txt "https://resa-movida.deciplus.pro/sp_lecons_planning.php?idz=3&sport=$4&date=$nextDate" | grep "|cours|$timeslot")
if [ -z "$events" ]
then
  echo "**************ERROR**************"
  echo "*"
  echo "* Params"
  echo "* Email : $1"
  echo "* Password : $2"
  echo "* Time : $3"
  echo "* Sport : $4"
  echo "*"
  echo "* Call stack"
  echo "* nextDate : $nextDate"
  echo "* timeslot : $timeslot"
  curl -s -b cookies.txt "https://resa-movida.deciplus.pro/sp_lecons_planning.php?idz=3&sport=$4&date=$nextDate" | grep creneau\"\>1
  echo "*********************************"
else
  # Make reservation
  id=$(echo "$events" | cut -d ">" -f 2 | cut -d "|" -f 1)
  result=$(curl -s -b cookies.txt -d "idr=$id&sport=$4&act=new&etat_resa=init&islist=2&idz=3&invite=0&nbcascade=0&ipl" -X POST 'https://resa-movida.deciplus.pro/sp_reserver_lecon.php?&idz=3' -i | grep "HTTP/1.1" | cut -d " " -f 2)
  if [ "$result" = "200" ] && [ -n "$id" ]
  then
    echo "Reservation made for $1 at $3 with id $id"
  else
    echo "**************ERROR**************"
    echo "*"
    echo "* Params"
    echo "* Email : $1"
    echo "* Password : $2"
    echo "* Time : $3"
    echo "* Sport : $4"
    echo "*"
    echo "* Call stack"
    echo "* nextDate : $nextDate"
    echo "* timeslot : $timeslot"
    echo "* events : $events"
    echo "* id : $id"
    echo "*********************************"
  fi
fi
