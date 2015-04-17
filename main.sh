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
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston
#  MA 02110-1301, USA.
#
#  2015/02/27

IFS=$'\n\t'

if [ ! -d "$HOME/.idiomind" ]; then
    /usr/share/idiomind/ifs/1u.sh & exit
    if [ ! -d "$HOME/.idiomind" ]; then
        exit 1
    fi
fi

source /usr/share/idiomind/ifs/c.conf

if [ -f "$DT/ps_lk" ]; then
    sleep 15
    [ -f "$DT/ps_lk" ] && rm -f "$DT/ps_lk"
    exit 1
fi

function new_session() {

    #set -e
    echo "--new session"
    touch "$DT/ps_lk"
    echo "$(date +%d)" > "$DC_s/10.cfg"
    if [ -f "$DT/t_notify" ]; then rm -f "$DT/t_notify"; fi
    if [ -f "$DT/notify" ]; then rm -f "$DT/notify"; fi
    source "$DS/ifs/mods/cmns.sh"
    
    # write in /tmp
    if [ ! -d "$DT" ]; then mkdir "$DT"; fi
    if [ $? -ne 0 ]; then
    msg "$(gettext "Fail on try write in /tmp")\n" error & exit 1; fi
  
    # start addons
    addons="$(cd $DS/addons; ls -d *)"
    n=1; > "$DC_s/2.cfg"
    while [ $n -le $(echo "$addons" | wc -l ) ]; do
        set=$(echo "$addons" | sed -n "$n"p)
        if [ -f "/usr/share/idiomind/addons/$set/icon.png" ]; then 
            echo "/usr/share/idiomind/addons/$set/icon.png" >> "$DC_s/2.cfg"
        else
            echo "/usr/share/idiomind/images/thumb.png" >> "$DC_s/2.cfg"
        fi
        echo "$set" >> "$DC_s/2.cfg"
        let n++
    done
    
    for strt in "$DS/ifs/mods/start"/*; do
    (sleep 20 && "$strt"); done &

    # fix
    n=1; cd "$DM_tl"; cfg="$DM_tl/.2.cfg"
    while [ $n -le $(wc -l < "$cfg") ]; do
        chk=$(sed -n "$n"p "$cfg")
        dirs="$(find ./ -maxdepth 1 -type d \
        | sed 's|\./\.share||;s|\./||g')"
        if ! grep -Fxo "$chk" <<<"$dirs"; then
            grep -vxF "$chk" "$cfg" > "$DT/2.cfg.fix"
            sed '/^$/d' "$DT/2.cfg.fix" > "$cfg"
            rm -f "$DT/2.cfg.fix";fi
        let n++
    done; cd ~/

    # 
    s="$(xrandr | grep '*' | awk '{ print $1 }' \
    | sed 's/x/\n/')"
    echo "$(sed -n 1p <<<"$s")" >> "$DC_s/10.cfg"
    echo "$(sed -n 2p <<<"$s")" >> "$DC_s/10.cfg"
    echo "$DESKTOP_SESSION" >> "$DC_s/10.cfg"
    gconftool-2 --get /desktop/gnome/interface/font_name \
    | cut -d ' ' -f 2 >> "$DC_s/10.cfg"
    locale >/dev/null 2>&1
    [[ $? != 0 ]] && msg \
    "$(gettext "The system is not properly configured.\nE10")" \
    error Error && exit 1

    # log file
    if [ -f "$DC_s/8.cfg" ]; then
    if [ $(du -sb "$DC_s/8.cfg" | awk '{ print $1 }') -gt 100000 ]; then
    tail -n2000 < "$DC_s/8.cfg" > "$DT/8.cfg"
    mv -f "$DT/8.cfg" "$DC_s/8.cfg"; fi
    fi
    
    # check for updates
    "$DS/ifs/tls.sh" a_check_updates &
    
    # status update
    [ ! -f "$DM_tl/.1.cfg" ] && touch "$DM_tl/.1.cfg"
    info="$(gettext "Could be reviewed:")"
    n=1
    while [ $n -le "$(wc -l < "$DM_tl/.1.cfg" | head -50)" ]; do
        tp=$(sed -n "$n"p "$DM_tl/.1.cfg")
        stts=$(sed -n 1p "$DM_tl/$tp/.conf/8.cfg")

        if ([ "$stts" = 3 ] || [ "$stts" = 4 ] \
        || [ "$stts" = 7 ] || [ "$stts" = 8 ]) && \
        [ "$DM_tl/$tp/.conf/9.cfg" ]; then
        
            dts=$(sed '/^$/d' < "$DM_tl/$tp/.conf/9.cfg" | wc -l)
            if [ $dts = 1 ]; then
            dte=$(sed -n 1p "$DM_tl/$tp/.conf/9.cfg")
            TM="$(( ( $(date +%s) - $(date -d "$dte" +%s) ) /(24 * 60 * 60 ) ))"
            RM=$((100*$TM/6))
            elif [ $dts = 2 ]; then
            dte=$(sed -n 2p "$DM_tl/$tp/.conf/9.cfg")
            TM="$(( ( $(date +%s) - $(date -d "$dte" +%s) ) /(24 * 60 * 60 ) ))"
            RM=$((100*$TM/10))
            elif [ $dts = 3 ]; then
            dte=$(sed -n 3p "$DM_tl/$tp/.conf/9.cfg")
            TM="$(( ( $(date +%s) - $(date -d "$dte" +%s) ) /(24 * 60 * 60 ) ))"
            RM=$((100*$TM/15))
            elif [ $dts = 4 ]; then
            dte=$(sed -n 4p "$DM_tl/$tp/.conf/9.cfg")
            TM="$(( ( $(date +%s) - $(date -d "$dte" +%s) ) /(24 * 60 * 60 ) ))"
            RM=$((100*$TM/20))
            elif [ $dts = 5 ]; then
            dte=$(sed -n 5p "$DM_tl/$tp/.conf/9.cfg")
            TM="$(( ( $(date +%s) - $(date -d "$dte" +%s) ) /(24 * 60 * 60 ) ))"
            RM=$((100*$TM/30))
            elif [ $dts = 6 ]; then
            dte=$(sed -n 6p "$DM_tl/$tp/.conf/9.cfg")
            TM="$(( ( $(date +%s) - $(date -d "$dte" +%s) ) /(24 * 60 * 60 ) ))"
            RM=$((100*$TM/40))
            fi
            if [ $((stts%2)) = 0 ]; then
            if [ "$RM" -ge 150 ]; then
            echo "10" > "$DM_tl/$tp/.conf/8.cfg"
            printf "$tp" >> "$DT/t_notify"
            elif [ "$RM" -ge 100 ]; then
            echo "8" >> "$DM_tl/$tp/.conf/8.cfg"
            printf "$tp" >> "$DT/t_notify"; fi
            else
            if [ "$RM" -ge 150 ]; then
            echo "9" > "$DM_tl/$tp/.conf/8.cfg"
            printf "$tp" >> "$DT/t_notify"
            elif [ "$RM" -ge 100 ]; then
            echo "7" > "$DM_tl/$tp/.conf/8.cfg"
            printf "$tp" >> "$DT/t_notify"; fi
            fi
        fi
        let n++
    done

    if [ -f "$DT/t_notify" ]; then
    info2="$(< "$DT/t_notify")"
    printf "$info\n$info2" >> "$DT/notify"
    rm -f "$DT/t_notify"
    fi
    
    rm -f  "$DT/ps_lk"
    "$DS/mngr.sh" mkmn &
}


if [ $(echo "$1" | grep -o '.idmnd') ]; then

    dte=$(date "+%d %B")
    c=$(echo $(($RANDOM%1000)))
    source "$DS/ifs/mods/cmns.sh"
    [ ! -d "$DT" ] && mkdir "$DT"
    mkdir "$DT/dir$c"
    cp "$1" "$DT/import.tmp"
    mv "$DT/import.tmp" "$DT/import.tar.gz"
    cd "$DT/dir$c" #--exclude=./topics/attchs #TODO
    tar -xzvf ../import.tar.gz
    ls -tdN * > "$DT/dir$c/folder"
    tpi=$(sed -n 1p "$DT/dir$c/folder")
    tmp="$DT/dir$c/$tpi"
    "$DS/ifs/tls.sh" check_source_1 "$tmp" "$tpi" &&
    source "$DT/$tpi.cfg"
    lng="$(lnglss "$language_target")"
    infs="'$DS/ifs/tls.sh' 'details' '$tmp'"
    [ $level = 1 ] && level="$(gettext "Beginner")"
    [ $level = 2 ] && level="$(gettext "Intermediate")"
    [ $level = 3 ] && level="$(gettext "Advanced")"

    if [ "$tpi" != "$name" ]; then
    
        msg "$(gettext "File is corrupted.")\n " error;
        [ -d "$DT/dir$c" ] && rm -fr "$DT/dir$c" \
        "$DT/$tpi.cfg" "$DT/import.tar.gz" & exit 1
        
    else
        cd "$tmp"
        ws=$(wc -l < "3.cfg")
        ss=$(wc -l < "4.cfg")
        itxt="<big><big>$tpi</big></big><small>\\n ${language_source^} <b>></b> $language_target\\n $nwords $(gettext "Words") $nsentences $(gettext "Sentences") $nimages $(gettext "Images")\n $(gettext "Level:") $level \n</small>"
        dclk="'$DS/default/vwr_tmp.sh' '$c'"

        tac "$tmp/0.cfg" | awk '{print $0""}' | \
        yad --list --title="Idiomind" \
        --text="$itxt" \
        --name=Idiomind --class=Idiomind \
        --print-all --dclick-action="$dclk" \
        --window-icon="$DS/images/icon.png" --scroll \
        --no-headers --ellipsize=END --center \
        --width=650 --height=580 --borders=10 \
        --column=Items \
        --button="$(gettext "Info")":"$infs" \
        --button="$(gettext "Install")":0 \
        --button="$(gettext "Close")":1
        ret=$?
            
            if [ $ret -eq 1 ]; then
            
                [ -d "$DT/dir$c" ] && rm -fr "$DT/dir$c"
                rm -f "$DT/import.tar.gz" "$DT/$tpi.cfg" & exit
                
            elif [ $ret -eq 0 ]; then
            
                if2=$(wc -l < $DM_t/$language_target/.1.cfg)
                chck=$(grep -Fox "$tpi" < $DM_t/$language_target/.1.cfg | wc -l)
                
                if [ "$if2" -ge 80 ]; then
                
                    msg "$(gettext "Sorry, you have reached the maximum number of topics")\n" info
                    [ -d "$DT/dir$c" ] && rm -fr "$DT/dir$c"
                    rm -f "$DT/import.tar.gz" & exit
                fi
        
                if [ "$chck" -ge 1 ]; then
                
                    tpi="$tpi $chck"
                    msg_2 "$(gettext "Another topic with the same name already exist.")\n$(gettext "The new it was renamed to\:")\n<b>$tpi</b>\n" info "$(gettext "OK")" "$(gettext "Cancel")"
                    ret=$(echo $?)
                    
                    if [ $ret != 0 ]; then
                    [ -d "$DT/dir$c" ] && rm -fr "$DT/dir$c"
                    rm -f  "$DT/import.tar.gz" & exit 1; fi
                fi

                if [ ! -d "$DM_t/$language_target" ]; then
                mkdir "$DM_t/$language_target"
                mkdir "$DM_t/$language_target/.share"
                fi
                mkdir -p "$DM_t/$language_target/$tpi/.conf"
                DI_m="$DM_t/$language_target/$tpi"
                DI_c="$DM_t/$language_target/$tpi/.conf"
                cd "$tmp"
                cp -n ./audio/*.mp3 "$DM_t/$language_target/.share/"
                [ -d ./audio ] && rm -fr ./audio
                n=0
                while [ $n -le 13 ]; do
                if [ ! -f "$tmp/$n.cfg" ]; then
                touch "$DI_c/$n.cfg"
                else mv -f "$tmp/$n.cfg" "$DI_c/$n.cfg"; fi
                let n++
                done
                tee -a "$DI_c/.11.cfg" "$DI_c/1.cfg" < "$DI_c/0.cfg"
                echo "1" > "$DI_c/8.cfg"; rm "$DI_c/9.cfg" "$DI_c/ls"
                cp -fr ./.* "$DI_m/"
                echo "$language_target" > "$DC_s/6.cfg"
                echo "$lgsl" >> "$DC_s/6.cfg"
                echo "$dte" > "$DI_c/13.cfg"
                #echo "$tpi" >> "$DM_t/$language_target/.3.cfg"
                sed -i 's/'"$tpi"'//g' "$DM_t/$language_target/.2.cfg"
                sed '/^$/d' "$DM_t/$language_target/.2.cfg" \
                > "$DM_t/$language_target/.2.cfg.tmp"
                mv -f "$DM_t/$language_target/.2.cfg.tmp" \
                "$DM_t/$language_target/.2.cfg"
                "$DS/mngr.sh" mkmn; "$DS/default/tpc.sh" "$tpi" &
            fi
    fi
    [ -d "$DT/dir$c" ] && rm -fr "$DT/dir$c"
    rm -f "$DT/import.tar.gz" "$DT/$tpi.cfg" & exit
fi
    
function topic() {

    [ -z "$tpc" ] && exit 1
    mode=$(sed -n 2p $DC_s/4.cfg)
    source "$DS/ifs/mods/cmns.sh"
    source "$DS/ifs/mods/topic/items_list.sh"
    
    if [ "$mode" = 2 ]; then
    
        "$DS/ifs/mods/topic/$tpc.sh" & exit

    elif [ "$mode" = 0 ] || [ "$mode" = 1 ]; then
    
        n=0
        while [ $n -le 4 ]; do
        [ ! -f "$DC_tlt/$n.cfg" ] && touch "$DC_tlt/$n.cfg"
        declare ls$n="$DC_tlt/$n.cfg"
        declare inx$n=$(wc -l < "$DC_tlt/$n.cfg")
        let n++
        done

        nt="$DC_tlt/10.cfg"
        author="$(sed -n 4p < "$DC_tlt/12.cfg" \
        | grep -o 'author="[^"]*' | grep -o '[^"]*$')"
        c=$(echo $(($RANDOM%100000))); KEY=$c
        cnf1=$(mktemp $DT/cnf1.XXX.x)
        cnf3=$(mktemp $DT/cnf3.XXX.x)
        cnf4=$(mktemp $DT/cnf4.XXX.x)
        [ ! "$DC_tlt/5.cfg" ] && > "$DC_tlt/5.cfg"
        set1=$(< "$DC_tlt/5.cfg")
        
        cd "$DS"
        if [ -f "$DM_tlt/words/images/img.jpg" ]; then
        img="--image=$DM_tlt/words/images/img.jpg"
        sx=612; sy=570; else sx=640; sy=560; fi
        printf "tpcs.$tpc.tpcs\n" >> "$DC_s/8.cfg"

        label_info1="<big><big>$tpc </big></big><small>\\n$inx4 $(gettext "Sentences") $inx3 $(gettext "Words") \n$(gettext "Created by") $author</small>"

        apply() {

            note_mod="$(< $cnf3)"
            if [ "$note_mod" != "$(< $nt)" ]; then
            mv -f "$cnf3" "$DC_tlt/10.cfg"; fi
            
            ntpc=$(cut -d '|' -f 1 < "$cnf4")
            if [ "$tpc" != "$ntpc" ] && [ -n "$ntpc" ]; then
            if [ "$tpc" != "$(sed -n 1p "$HOME/.config/idiomind/s/4.cfg")" ]; then
            msg "$(gettext "Sorry, this topic is currently not active.")\n " info & exit; fi
            "$DS/mngr.sh" rename_topic "$ntpc" & exit; fi
            
            set1_=$(cut -d '|' -f 8 < "$cnf4")
            if [ "$set1" != "$set1_" ]; then
            echo  "$set1_" > "$DC_tlt/5.cfg"; fi

            if [ -n "$(grep -o TRUE < "$cnf1")" ]; then
                grep -Rl "|FALSE|" "$cnf1" | while read tab1 ; do
                     sed '/|FALSE|/d' "$cnf1" > tmpf1
                     mv tmpf1 "$tab1"
                done
                
                sed -i 's/|TRUE|//g' "$cnf1"
                cat "$cnf1" >> "$ls2"

                cnt=$(wc -l < "$cnf1")
                grep -Fxvf "$cnf1" "$ls1" > "$DT/ls1.x"
                mv -f "$DT/ls1.x" "$ls1"
                if [ -n "$(cat "$ls1" | sort -n | uniq -dc)" ]; then
                    cat "$ls1" | awk '!array_temp[$0]++' > "$DT/ls1.x"
                    sed '/^$/d' "$DT/ls1.x" > "$ls1"
                fi
                printf "okim.$cnt.okim\n" >> "$DC_s/8.cfg"
            fi
        }
    
    if [ "$inx0" -lt 1 ]; then 
        
        notebook_1
     
        ret=$(echo $?)
                
            if [ ! -f "$DT/ps_lk" ]; then
                
                    apply
            fi
            
            if [ $ret -eq 5 ]; then
                rm -f "$DT"/*.x
                "$DS/practice/strt.sh" &
            fi

        rm -f "$DT"/*.x

    elif [ "$inx1" -ge 1 ]; then
    
        if [ -f "$DC_tlt/9.cfg" ] && [ -f "$DC_tlt/7.cfg" ]; then
        
            calculate_review
            stts=$(sed -n 1p "$DC_tlt/8.cfg")

            if [ "$RM" -ge 100 ]; then
            
                if [ $((stts%2)) = 0 ]; then
                echo "8" > "$DC_tlt/8.cfg"; else
                echo "7" > "$DC_tlt/8.cfg"; fi
                
                "$DS/mngr.sh" mkmn &
                
                RM=100
                dialog_1
                ret=$(echo $?)
                
                    if [ $ret -eq 2 ]; then
                    
                        "$DS/mngr.sh" mark_to_learn "$tpc" 0
                        idiomind topic & exit 1
                    fi 
            fi

            pres="<u><b>$(gettext "Learned")</b></u>  $(gettext "* however you have new items") ($inx1).\\n$(gettext "Time set to review:") $tdays $(gettext "days")"

            notebook_2
            
        else
            notebook_1
            
        fi
            ret=$(echo $?)

            if [ $ret -eq 5 ]; then
            
                rm -f "$DT"/*.x
                "$DS/practice/strt.sh" &
                    
            else
                if [ ! -f "$DT/ps_lk" ]; then
                
                    apply
                fi
                
                rm -f $DT/*.x
            fi
    
    elif [ "$inx1" -eq 0 ]; then
    
        if [ ! -f "$DC_tlt/7.cfg" ] || [ ! -f "$DC_tlt/9.cfg" ]; then

            "$DS/mngr.sh" mark_as_learned "$tpc" 0
        fi
        
        calculate_review
            
        if [ "$RM" -ge 100 ]; then

            stts=$(sed -n 1p "$DC_tlt/8.cfg")
            if [[ $((stts%2)) = 0 ]]; then
            echo "8" > "$DC_tlt/8.cfg"; else
            echo "7" > "$DC_tlt/8.cfg"; fi
            
            "$DS/mngr.sh" mkmn &
            
            RM=100
            dialog_1
            ret=$(echo $?)
                
                if [ $ret -eq 2 ]; then

                    "$DS/mngr.sh" mark_to_learn "$tpc" 0
                    idiomind topic & exit 1
                fi 
        fi
        
        pres="<u><b>$(gettext "Learned")</b></u>\\n$(gettext "Time set to review:") $tdays $(gettext "days")"
        
        # learned
        notebook_2
      
        rm -f "$DT"/*.x & exit
    fi
    rm -f "$DT"/*.x
    
    else
        if [ "$(wc -l < $DM_tl/.1.cfg)" -ge 1 ]; then
            exit 1
        fi
    fi
}

panel() {

    printf "strt.1.strt\n" >> "$DC_s/8.cfg"
    if [ -n "$tpc" ] && ([ "$mode" = 0 ] || [ "$mode" = 1 ]); then
     echo "$tpc" > "$DT/tpe"; fi
    if [ ! -d "$DT" ]; then new_session & exit; fi
    
    [ -f "$DC_s/10.cfg" ] && date=$(sed -n 1p "$DC_s/10.cfg")
    if [ "$(date +%d)" != "$date" ] || [ ! -f "$DC_s/10.cfg" ]; then
    new_session; fi
    
    x=$(($(sed -n 2p "$DC_s/10.cfg")/2))
    y=$(($(sed -n 3p "$DC_s/10.cfg")/2))
    
    yad --title="Idiomind" \
    --name=Idiomind --class=Idiomind \
    --window-icon="$DS/images/icon.png" \
    --form --fixed --on-top --no-buttons --align=center \
    --width=150 --height=200 --borders=1 --geometry=150x200-$x-$y \
    --field=gtk-new:btn "$DS/add.sh 'new_items'" \
    --field=gtk-home:btn "idiomind 'topic'" \
    --field=gtk-index:btn "$DS/chng.sh" \
    --field=gtk-preferences:btn "$DS/cnfg.sh" &
    
    if [ -f "$DT/notify" ]; then
    info="$(< "$DT/notify")"
    (sleep 4 && notify-send -i idiomind "$(gettext "Information")" "$info") &
    rm -f "$DT/notify"
    fi

}

version() {
    echo "2.2-beta"
}

session() {
    
    new_session
    idiomind &
}

autostart() {

    sleep 50
    [ ! -f "$DT/ps_lk" ] && new_session auto
    exit 0
}

case "$1" in
    topic)
    topic ;;
    --version)
    version ;;
    -v)
    version;;
    -s)
    session;;
    autostart)
    autostart;;
    *)
    panel;;
esac