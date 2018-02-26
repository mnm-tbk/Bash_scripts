#!/bin/bash
# Yevgen Ponomarenko 27.10.2017

ARG=$1
LINK=$2
STD=false
URL=false

if [ -z "$1" ]; then
	
	exit 1;
fi

if [[ "$1" = "-h" ]]; then
	echo "This script was created to find links to pdf files in HTML source code. Script can be run with two args:
	-i to find links in HTML file from stdin;
	-u followed by a URL, to find links on a page;
	"
	exit 0;
fi

if [[ "$ARG" = "-i" ]]; then
	STD=true


elif [[ "$ARG" = "-u" ]]; then
	URL=true

else

	exit 1;
fi

if [[ ("$STD" == true && "$LINK" == "-u") ]]; then
	
	exit 1;
fi


if [[ "$STD" == true ]]; then

	TEXT=`cat`

	

	echo $TEXT | tr '\n' ' ' | grep -oiE "<a\\s+[^>]*href\\s*=[[:space:]]*[\"']([^\"]+)\\.pdf['\"]" | grep -oiE "[^\"]*\.pdf"



	exit 0
fi

if [[ "$URL" == true ]]; then

	

	html=$(wget -qO- $LINK)

	if [[ $html -eq "" ]]; then
		exit 1;
	fi

	echo $html | tr '\n' ' ' | grep -oiE "<a\\s+[^>]*href\\s*=[[:space:]]*[\"']([^\"]+)\\.pdf['\"]" | grep -oiE "[^\"]*\.pdf"

	exit 0
fi



