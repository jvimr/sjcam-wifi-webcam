#!/bin/bash

DIRN="DCIM/PHOTO"

REMOTE="prcek:~/webcam.jesta.cz/webcam/"
FILE_NAME='/tmp/zahrada_big.jpg'

SLEEP_TIME=1m

function run_cmd() {
	url=$1
	cmdname=$2

	echo "running command for $cmdname"

	wget -O - $url
}


while true
do

#set photo mode
url="http://192.168.1.254/?custom=1&cmd=3001&par=0"
run_cmd $url "setting photo mode"


#shoot a photo
url="http://192.168.1.254/?custom=1&cmd=1001"
run_cmd $url 'shooting a picture'


#list photos
url="http://192.168.1.254/${DIRN}"
echo "listing pictures"
last_url_line=$(wget -O - -q http://192.168.1.254/DCIM/PHOTO |grep '[0-9] MB' |sed 's/^.*a href="\/\([^"]\+.JPG\)".*$/\1/' | tail -1)

PATH_TO_FILE=$(echo $last_url_line |sed 's/a href="\(^"\)"/\1/')


#read photo
url="http://192.168.1.254/${PATH_TO_FILE}"
wget -O $FILE_NAME $url

#delete photo
url="http://192.168.1.254/${PATH_TO_FILE}?del=1"
run_cmd $url "deleing the photo"

#upload photo

scp $FILE_NAME $REMOTE


sleep $SLEEP_TIME

done
