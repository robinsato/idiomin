#!/bin/bash
source /usr/share/idiomind/ifs/c.conf

if [ -n "$1" ]; then

	ttl=$(sed -n 2p $DC_s/fnew.id)
	plg1=$(sed -n 1p $DC_s/cnfg3)
	cnfg1="$DC_s/cnfg1"
	ti=$(cat "$DC_tl/$tpc/.t-inx" | wc -l)
	ni="$DC_tl/$tpc/.tlng-inx"
	bi="$DC_tl/$tpc/.tok-inx"
	nstll=$(grep -Fxo "$tpc" "$DC_tl"/.nstll)
	eht=$(sed -n 7p $DC_s/.rd)
	wth=$(sed -n 8p $DC_s/.rd)

	if [ -n "$nstll" ]; then

		if [ "$ti" -ge 10 ]; then # para instalados el 1 con marcar como aprendido ( despues de tener 10 items)

			$yad --icons --sticky --center \
			--width=$wth --name=idiomind --class=idmnd \
			--height=$eht --title="Edit" --compact \
			--window-icon=idiomind \
			--single-click --buttons-layout=end --skip-taskbar \
			--borders=0 --button=Close:1 \
			--read-dir=$DS/default/edit/ic --item-width=65 & exit 1
		else
			$yad --icons --sticky --center \
			--width=$wth --name=idiomind --class=idmnd \
			--height=$eht --title="Edit" --compact \
			--window-icon=idiomind \
			--single-click --buttons-layout=end --skip-taskbar \
			--borders=0 --button=Close:1 \
			--read-dir=$DS/default/edit/in --item-width=65 & exit 1
		fi

	else

		if [ "$ti" -ge 10 ]; then
			$yad --icons --sticky --center \
			--width=$wth --name=idiomind --class=idmnd \
			--height=$eht --title="Edit" --compact \
			--window-icon=idiomind \
			--single-click --buttons-layout=end --skip-taskbar \
			--borders=0 --button=Close:1 \
			--read-dir=$DS/default/edit/oc --item-width=65 & exit 1
		else
			$yad --icons --sticky --center \
			--width=$wth --name=idiomind --class=idmnd \
			--height=$eht --title="Edit" --compact \
			--window-icon=idiomind \
			--single-click --buttons-layout=end --skip-taskbar \
			--borders=0 --button=Close:1 \
			--read-dir=$DS/default/edit/on --item-width=65 & exit 1
		fi
	fi
	exit 1
fi

if [ -d $HOME/.idiomind ]; then

TPC=$(sed -n 2p $DC_s/topic.id)
tpc_n_k=$(sed -n 3p $DC_s/fnew.id)
eht=$(sed -n 11p $DC_s/.rd)
wth=$(sed -n 12p $DC_s/.rd)
chk=$(cat  "$DC/topics/$lgtl/.in_s" | grep -Fxo "$tpc")
if [ -n "$chk" ]; then
if [ "$tpc" !=  "$tpe" ]; then
echo "$tpc" > $DC_s/fnew.id
fi

fi
cd $DM_tl

if [ $(ls * -d | wc -l) -lt 1 ]; then
$DS/chng.sh $DS/ifs/info1 2 & exit 1
fi

#E=$(sed -n 1p "$DC/s/topic_m")
#if [ -z "$E" ]; then
#exit 0
#fi

if [ -z "$tpe" ]; then
$DS/chng.sh $DS/ifs/info2 2 & exit 1
fi

if [ ! -d "$DC_tlt" ]; then
$DS/chng.sh $DS/ifs/info2 2 & exit 1
fi

$DS/default/nw.sh
rm "$DC_tlt"/lstntry &
exit 1
else
	$DS/ifs/1u &
exit 1
fi