#!/bin/bash
LOGFILE="mylog.txt"
DAY="2013-01-18"
TMPFILE=`mktemp /tmp/hhLogs.XXXXXX` || exit 1

grep -E "^${DAY} .* /resume\?.*id=43" $LOGFILE | sed -E 's/^.* (.*)ms/\1/' | sort > $TMPFILE
count=$(wc -l < $TMPFILE)
if [ $count -gt 0 ]
then
    totalTime="$(paste -sd+ - < $TMPFILE | bc -l)"
    echo "среднее значение: "$(echo "${totalTime} / ${count}" | bc -l)"ms"

    medianIndex=$(echo "(${count} +1) / 2" | bc)
    echo "медиана: "$(sed "${medianIndex}q;d" $TMPFILE)"ms"
else
    echo "данных нет" 
fi
function finish {
  rm -f $TMPFILE
}
trap finish EXIT
