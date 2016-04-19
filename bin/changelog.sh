#!/bin/bash
# Generates changelog day by day
NEXT=$(date +%F)
GIT_PAGER=cat git log --no-merges --format="%cd" --date=short | sort -u -r | while read DATE ; do
	echo
	echo [$DATE]
	DATE=$(date +%F --date="$DATE -1 day")
	GIT_PAGER=cat git log --no-merges --format=" * %s" --since=$DATE --until=$NEXT
	NEXT=$DATE
done | grep -vi "updated changelog" | tee ../CHANGELOG
