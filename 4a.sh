#!/bin/bash
LOGFILE="log.txt"
TMPFILE=`mktemp /tmp/hhLogs.XXXXXX` || exit 1

grep -E " 12:.* /resume\?.* 2\d{2} " $LOGFILE | sed -E 's/^.* (.*)ms/\1/' | sort > $TMPFILE
count="$(wc -l < $TMPFILE)"

if [ $count -gt 0 ]
then
    totalTime="$(paste -sd+ - < $TMPFILE | bc -l)"
    echo "общее время успешных обращений: ${totalTime}ms"
    echo "среднее значение: "$(echo "${totalTime} / ${count}" | bc -l)"ms"

    q95Index=$(echo "(50 + 95 * ${count}) / 100" | bc) #не "*" на 0.95 чтобы не разбираться с округлением
    q99Index=$(echo "(50 + 99 * ${count}) / 100" | bc)
    echo "95% квантиль: "$(sed "${q95Index}q;d" $TMPFILE)"ms"
    echo "99% квантиль: "$(sed "${q99Index}q;d" $TMPFILE)"ms"
else
    echo "данных нет" 
fi
function finish {
  rm -f $TMPFILE
}
trap finish EXIT
