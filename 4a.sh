#!/bin/bash
LOGFILE="log.txt"
TMPFILE=`mktemp /tmp/hhLogs.XXXXXX` || exit 1

grep " 12:.* /resume[?/ ].* 200 " $LOGFILE | sed -E 's/^.* (.*)ms/\1/' | sort >> $TMPFILE

totalTime="$(cat $TMPFILE | paste -sd+ - | bc -l)"
echo "общее время успешных обращений: ${totalTime}ms"

count="$(cat $TMPFILE | wc -l)"
echo "среднее значение: "$(echo "${totalTime} / ${count}" | bc -l)"ms"

q95Index=$(echo "${count} - 5 * ${count} / 100" | bc) #не "*0.05" чтобы не разбираться с округлением
q99Index=$(echo "${count} - ${count} / 100"| bc)
echo "95% квантиль: "$(sed "${q95Index}q;d" $TMPFILE)"ms"
echo "99% квантиль: "$(sed "${q99Index}q;d" $TMPFILE)"ms"

rm -f $TMPFILE
