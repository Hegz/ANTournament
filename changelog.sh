#!/bin/bash
# Generates changelog day by day
NEXT=$(date +%F)
git log --no-merges --format="%cd" --date=short | sort -u -r | while read DATE ; do
    echo
    echo [$DATE]
    GIT_PAGER=cat git log --no-merges --format=" * %s" --since=$DATE --until=$NEXT
    NEXT=$DATE
done > CHANGELOG
