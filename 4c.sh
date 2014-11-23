#!/bin/bash
LOGFILE="mylog.txt"
DAY="2013-01-18"

RESUMEDATAFILE="resume.data"
VACANCYDATAFILE="vacancy.data"
USERDATAFILE="user.data"
#массив вида ("hour!response_time", ...) по каждой группе
resume=($(grep -E "^${DAY} .* /resume[\?/ ].*" $LOGFILE | cut -d' ' -f2,8 | sed -E 's/(.*):.*:.* (.*)ms/\1!\2/'))
vacancy=($(grep -E "^${DAY} .* /vacancy[\?/ ].*" $LOGFILE | cut -d' ' -f2,8 | sed -E 's/(.*):.*:.* (.*)ms/\1!\2/'))
user=($(grep -E "^${DAY} .* /user[\?/ ].*" $LOGFILE | cut -d' ' -f2,8 | sed -E 's/(.*):.*:.* (.*)ms/\1!\2/'))

#инициализация файлов для gnuplot
echo -e "Hour\t95% Quantile" > $RESUMEDATAFILE
echo -e "Hour\t95% Quantile" > $VACANCYDATAFILE
echo -e "Hour\t95% Quantile" > $USERDATAFILE

#расчет 95% квантиля за каждый час
function getQuantile(){
    h="${1}"
    declare -a data=("${!2}")
    fileName="${3}"
    dataByHour=($(printf -- '%s\n' "${data[@]}" | grep -E "^${h}!.*" | sed -E 's/^.* (.*)ms/\1/' | sort))
    if [ ${#dataByHour[@]} -gt 0 ]
    then    
        q95Index="$(echo "(-50 + 95 * ${#dataByHour[@]}) / 100" | bc)"
        #файл для gnuplot строка вида "hour respone_time"
        echo "${dataByHour[${q95Index}]}" | sed 's/!/ /' >> $fileName
    fi
}
for hour in $(seq -f "%02g" 0 23)
do
   getQuantile "${hour}" resume[@] $RESUMEDATAFILE
   getQuantile "${hour}" vacancy[@] $VACANCYDATAFILE
   getQuantile "${hour}" user[@] $USERDATAFILE
done

#charts
gnuplot charts.plg

if [[ "$OSTYPE" == "darwin"* ]]; # Mac OSX
then
    open "charts.png"
else
    echo "generated 'charts.png' in working directory"
fi

function finish {
  rm -f $RESUMEDATAFILE
  rm -f $VACANCYDATAFILE
  rm -f $USERDATAFILE
}
trap finish EXIT
