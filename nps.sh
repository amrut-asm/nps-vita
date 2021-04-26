#!/bin/bash
echo ""
read -p "Enter name: " var
declare -a ia
declare -a ra
declare -a na
declare -a ua
declare -a za
i=0
while read -r line
do
	url=$(echo "$line" | grep -i "$var" | awk -F ',' '{ print $4 }')
      	id=$(echo "$line" | grep -i "$var" | awk -F ',' '{ print $1 }')
	name=$(echo "$line" | grep -i "$var" | awk -F ',' '{ print $3 }')
	region=$(echo "$line" | grep -i "$var" | awk -F ',' '{ print $2 }')
	zrif=$(echo "$line" | grep -i "$var" | awk -F ',' '{ print $5 }')
	if [ "$url" != "" ]
	then
		ia[i]="$id"
		ra[i]="$region"
		na[i]="$name"
		ua[i]="$url"
		za[i]="$zrif"
		((i++))
		#echo ""
		#echo "$id : $name : $url"
		#echo ""
	fi
done < psv_games.csv
size=$i

echo ""
echo "Search results"
echo "--------------"
echo ""

for ((c=0;c<$size;c++))
do
	echo "$c)" "[${ra[$c]}]" "${ia[$c]}"  "${na[$c]}"
done 

while [ 1 -eq 1 ]
do
read -p "Enter your choice: " choice
if [ $choice -ge 0 ] && [ $choice -lt $size ]
then
	wget -c ${ua[$choice]} -O "${na[$choice]}.pkg"
	echo ""
	echo "Downloaded successfully"
	echo ""
	./pkg2zip "${na[$choice]}.pkg" "${za[$choice]}"
	rm "${na[$choice]}.pkg"
	exit 0
else
	echo "Invalid choice... Choose again"
fi
done
