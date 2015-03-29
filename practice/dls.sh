#!/bin/bash
# -*- ENCODING: UTF-8 -*-

#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#
#  2015/02/27

drts="$DS/practice/"
strt="$drts/strt.sh"
cd "$DC_tlt/practice"
all=$(cat lsin | wc -l)
listen="Listen"
easy=0
hard=0
ling=0
f=0

function score() {

    if [ "$1" -ge "$all" ] ; then
        rm lsin ok.s
        echo "$(date "+%a %d %B")" > look_ls
        echo 21 > .iconls
        play $drts/all.mp3 & $strt 4 &
        killall dls.sh
        exit 1
        
    else
        [ -f l_s ] && echo "$(($(cat l_s)+$easy))" > l_s || echo $easy > l_s
        s=$(cat l_s)
        v=$((100*$s/$all))
        n=1; c=1
        while [ "$n" -le 21 ]; do
                if [ "$v" -le "$c" ]; then
                echo "$n" > .iconls; break; fi
                ((c=c+5))
            let n++
        done

        $strt 8 $easy $ling $hard & exit 1
    fi
}


function dialog1() {
    
    hint="$(iconv -c -f utf8 -t ascii <<<"$1" | tr -s "'" " ")"
    SE=$(yad --center --text-info --image="$IMAGE" "$info" --image-on-top \
    --fontname="Free Sans 15" --justify=fill --editable --wrap \
    --buttons-layout=end --borders=5 --title=" " --margins=8 \
    --text-align=left --height=420 --width=470 --name=Idiomind \
    --align=left --window-icon=idiomind --fore=4A4A4A --class=Idiomind \
    --button="$(gettext "Hint")":"/usr/share/idiomind/practice/hint.sh ${hint}" \
    --button="$listen":"play '$DM_tlt/$fname.mp3'" \
    --button=" $(gettext "OK") >> ":0)
    }
    
function dialog2() {
    
    hint="$(iconv -c -f utf8 -t ascii <<<"$1" | tr -s "'" " ")"
    SE=$(yad --center --text-info --fore=4A4A4A --skip-taskbar \
    --fontname="Free Sans 15" --justify=fill --editable --wrap \
    --buttons-layout=end --borders=5 --title=" " "$info" --margins=8 \
    --text-align=left --height=180 --width=470 --name=Idiomind \
    --align=left --window-icon=idiomind --image-on-top --class=Idiomind \
    --button="$(gettext "Hint")":"/usr/share/idiomind/practice/hint.sh ${hint}" \
    --button="$listen":"play '$DM_tlt/$fname.mp3'" \
    --button=" $(gettext "OK") >> ":0)
    }
    
function check() {
    
    yad --form --center --name=Idiomind --buttons-layout=end \
    --width=560 --height=300 --on-top --skip-taskbar --scroll \
    --class=Idiomind $aut --wrap --window-icon=idiomind \
    --borders=10 --selectable-labels \
    --title="" --button="$listen":"play '$DM_tlt/$fname.mp3'" \
    --button="$(gettext "Next sentence")":2 \
    --field="":lbl --text="<span font_desc='Free Sans 14'>$wes</span>\\n" \
    --field="<span font_desc='Free Sans 9'>$(echo $OK | sed 's/\,*$/\./g') $prc</span>\\n":lbl
    }
    
function get_image_text() {
    
    WEN=$(echo "$1" | sed 's/^ *//; s/ *$//')
    eyeD3 --write-images=$DT "$DM_tlt/$fname.mp3"
    echo "$WEN" | awk '{print tolower($0)}' > quote
    }

function result() {
    
    echo "$SE" | awk '{print tolower($0)}' \
    | sed 's/ /\n/g' | grep -v '^.$' \
    | sed s'/,//; s/\!//; s/\?//; s/¿//; s/\¡//; s/"//'g > ing
    cat quote | awk '{print tolower($0)}' \
    | sed 's/ /\n/g' | grep -v '^.$' \
    | sed s'/,//; s/\!//; s/\?//; s/¿//; s/\¡//; s/"//'g > all
    (
    ff="$(cat ing | sed 's/ /\n/g')"
    n=1
    while [ $n -le $(echo "$ff" | wc -l) ]; do
        line="$(echo "$ff" | sed -n "$n"p )"
        if cat all | grep -oFx "$line"; then
            sed -i "s/"$line"/<b>"$line"<\/b>/g" quote
            [ -n "$line" ] && echo \
            "<span color='#3A9000'><b>${line^}</b></span>,  " >> wrds
            [ -n "$line" ] && echo "$line" >> w.ok
        else
            [ -n "$line" ] && echo \
            "<span color='#7B4A44'><b>${line^}</b></span>,  " >> wrds
        fi
        let n++
    done
    )
    OK=$(cat wrds | tr '\n' ' ')
    cat quote | sed 's/ /\n/g' > all
    porc=$((100*$(cat w.ok | wc -l)/$(cat all | wc -l)))
    
    if [ $porc -ge 70 ]; then
        echo "$WEN" | tee -a ok.s $w9
        easy=$(($easy+1))
        clr=3AB452
    elif [ $porc -ge 50 ]; then
        ling=$(($ling+1))
        clr=E5801D
    else
        hard=$(($hard+1))
        clr=D11B5D
    fi
    
    prc="<span background='#$clr'><span color='#FFFFFF'> <b>$porc%</b> </span></span>"
    wes="$(cat quote)"
    
    rm allc quote
    }
    
    
n=1
while [ $n -le $(wc -l < lsin1) ]; do

    trgt="$(sed -n "$n"p lsin1)"
    fname="$(echo -n "$trgt" | md5sum | rev | cut -c 4- | rev)"
    
    if [ $n = 1 ]; then
    info="--text=<sup><tt> $(gettext "Try to write the phrase you're listening to")...</tt></sup>"
    else
    info=""; fi
    
    if [ -f "$DM_tlt/$fname".mp3 ]; then
        if [ -f "$DT/ILLUSTRATION".jpeg ]; then
            rm -f "$DT/ILLUSTRATION".jpeg; fi
        
        get_image_text "$trgt"

        if ( [ -f "$DT/ILLUSTRATION".jpeg ] && [ $n != 1 ] ); then
            IMAGE="$DT/ILLUSTRATION".jpeg
            (sleep 0.5 && play "$DM_tlt/$fname".mp3) &
            dialog1 "$trgt"
        else
            (sleep 0.5 && play "$DM_tlt/$fname".mp3) &
            dialog2 "$trgt"
        fi
        ret=$(echo "$?")
        
        if [ $ret -eq 0 ]; then
            killall play &
            result "$trgt"
        else
            killall play &
            $drts/cls s $easy $ling $hard $all &
            break &
            exit 0; fi
    
        check "$trgt"
        ret=$(echo "$?")
        
        if [ $ret -eq 2 ]; then
            killall play &
            rm -f w.ok wrds $DT/*.jpeg *.png &
        else
            killall play &
            rm -f w.ok all ing wrds $DT/*.jpeg *.png
            $drts/cls s $easy $ling $hard $all &
            break &
            exit 0; fi
    fi
    let n++
done

score $easy

