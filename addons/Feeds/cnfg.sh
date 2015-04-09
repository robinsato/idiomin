#!/bin/bash
# -*- ENCODING: UTF-8 -*-
source /usr/share/idiomind/ifs/c.conf
source $DS/ifs/mods/cmns.sh
wicon"$DS/images/logo.png"
DCP="$DM_tl/Feeds/.conf"
DSP="$DS_a/Feeds"
CNF=$(gettext "Configure")
sets=('update' 'sync' 'path')
[ -n "$(< "$DCP/0.cfg")" ] && cfg=1 || > "$DCP/0.cfg"

tpc='#!/bin/bash
source /usr/share/idiomind/ifs/c.conf
[ ! -f $DM_tl/Feeds/.conf/8.cfg ] \
&& echo "11" > $DM_tl/Feeds/.conf/8.cfg
echo "$tpc" > $DC_s/4.cfg
echo fd >> $DC_s/4.cfg
idiomind topic
exit 1'

if [ ! -d $DM_tl/Feeds ]; then

    mkdir "$DM_tl/Feeds"
    mkdir "$DM_tl/Feeds/.conf"
    mkdir "$DM_tl/Feeds/cache"
    cd "$DM_tl/Feeds/.conf/"
    touch "0.cfg" "1.cfg" "2.cfg" "3.cfg" "4.cfg" ".updt.lst"
    echo "$tpc" > "$DM_tl/Feeds/tpc.sh"
    chmod +x "$DM_tl/Feeds/tpc.sh"
    echo "14" > "$DM_tl/Feeds/.conf/8.cfg"
    "$DS/mngr.sh" mkmn
fi

[[ -e "$DT/cp.lock" ]] && exit || touch "$DT/cp.lock"
[ ! -f "$DCP/4.cfg" ] && touch "$DCP/4.cfg"
[ -f "$DCP/0.cfg" ] && st2=$(sed -n 1p "$DCP/0.cfg") || st2=FALSE

n=1; while read feed; do
    declare url"$n"="$feed"
    ((n=n+1))
done < "$DCP/4.cfg"

n=0
while [[ $n -lt 3 ]]; do

    if [ "$cfg" = 1 ]; then
        itn=$((n+1))
        get="${sets[$n]}"
        val=$(sed -n "$itn"p < "$DCP/0.cfg" \
        | grep -o "$get"=\"[^\"]* | grep -o '[^"]*$')
        declare "${sets[$n]}"="$val"
        
    else
        if [ $n -lt 2 ]; then
        val="FALSE"; else val="/uu"; fi
        echo -e "${sets[$n]}=\"$val\"" >> "$DCP/0.cfg"
    fi

    ((n=n+1))
done
    
apply() {
    
    printf "$CNFG" | sed 's/|/\n/g' | sed -n 7,16p | \
    sed 's/^ *//; s/ *$//g' > "$DT/feeds.tmp"

    n=1; while read feed; do
        declare mod"$n"="$feed"
        mod="mod$n"; url="url$n"
        if [ "${!url}" != "${!mod}" ]; then
            "$DSP/tls.sh" set_channel "${!mod}" $n & fi
        ((n=n+1))
    done < "$DT/feeds.tmp"

    feedstmp="$(cat "$DT/feeds.tmp")"
    if ([ -n "$feedstmp" ] && [ "$feedstmp" != "$(cat "$DCP/4.cfg")" ]); then
    mv -f "$DT/feeds.tmp" "$DCP/4.cfg"; else rm -f "$DT/feeds.tmp"; fi

    val1=$(cut -d "|" -f1 <<<"$CNFG")
    val2=$(cut -d "|" -f2 <<<"$CNFG")
    val3=$(cut -d "|" -f4 <<<"$CNFG" | sed 's|/|\\/|g')
    if [ ! -d "$val3" ] ||  [ -z "$val3" ]; then path=/uu; fi
    sed -i "s/update=.*/update=\"$val1\"/g" "$DCP/0.cfg"
    sed -i "s/sync=.*/sync=\"$val2\"/g" "$DCP/0.cfg"
    sed -i "s/path=.*/path=\"$val3\"/g" "$DCP/0.cfg"
    [ -f "$DT/cp.lock" ] && rm -f "$DT/cp.lock"
}

[ ! -d "$path" ] && path=/uu
if [ -f "$DM_tl/Feeds/.conf/feed.err" ]; then
e="$(head -n 10 < "$DM_tl/Feeds/.conf/feed.err" | tr '&' ' ')"
rm "$DM_tl/Feeds/.conf/feed.err"
(sleep 2 && msg "$(gettext "Errors found in log file") \n$e" info) &
fi

CNFG=$(yad --form --title="$(gettext "Feeds settings")" \
--name=Idiomind --class=Idiomind \
--always-print-result --print-all --separator="|" \
--window-icon="$wicon" --center --scroll --on-top \
--width=600 --height=460 --borders=15 \
--text="$(gettext "Configure feeds to learn with podcasts or news.")" \
--field="$(gettext "Update at startup")":CHK "$update" \
--field="$(gettext "Sync after update")":CHK "$sync" \
--field="$(gettext "Mountpoint or path where episodes should be synced.")":LBL " " \
--field="":DIR "$path" \
--field=" ":LBL " " \
--field="$(gettext "Feeds")":LBL " " \
--field="" "$url1" --field="" "$url2" --field="" "$url3" \
--field="" "$url4" --field="" "$url5" --field="" "$url6" \
--field="" "$url7" --field="" "$url8" --field="" "$url9" \
--field="" "$url10" \
--button="$(gettext "Cancel")":1 \
--button="$(gettext "Syncronize")":5 \
--button="gtk-apply":0)

ret=$?

if [ "$ret" -eq 0 ]; then

    apply;
    
elif [ "$ret" -eq 5 ]; then

    apply
    "$DSP/tls.sh" sync;

fi
[ -f "$DT/cp.lock" ] && rm -f "$DT/cp.lock"
exit
