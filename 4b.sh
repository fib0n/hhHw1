#!/bin/bash
LOGFILE="log.txt"
DAY="2013-01-18"
TMPFILE=`mktemp /tmp/hhLogs.XXXXXX` || exit 1

grep -E "^${DAY} .* /resume\?.*id=43" $LOGFILE | sed -E 's/^.* (.*)ms/\1/' | sort > $TMPFILE
count="$(cat $TMPFILE | wc -l)"
if [ $count -gt 0 ]
then
    totalTime="$(cat $TMPFILE | paste -sd+ - | bc -l)"
    echo "среднее значение: "$(echo "${totalTime} / ${count}" | bc -l)"ms"

    medianaIndex=$(echo "${count} / 2 + 1" | bc)
    echo "медиана: "$(sed "${medianaIndex}q;d" $TMPFILE)"ms"
else
    echo "данных нет" 
fi
rm -f $TMPFILE