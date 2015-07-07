#!/bin/bash
# -*- ENCODING: UTF-8 -*-

function dlg_checklist_5() {
    
    cmd_edit_="$DS/ifs/mods/add_process/a_.sh 'item_for_edit'"
    cmd_newtopic="$DS/add.sh 'new_topic'"
    slt=$(mktemp "$DT/slt.XXXX.x")
    cat "${1}" | awk '{print "FALSE\n"$0}' | \
    yad --list --checklist --title="$2" \
    --text="<small>$info</small> " \
    --name=Idiomind --class=Idiomind \
    --dclick-action="$cmd_edit_" \
    --window-icon="$DS/images/icon.png" \
    --text-align=right --center --sticky \
    --width=600 --height=550 --borders=3 \
    --column="$(wc -l < "${1}")" \
    --column="$(gettext "Items")" \
    --button="$(gettext "Cancel")":1 \
    --button="$(gettext "New Topic")":"cmd_newtopic" \
    --button=gtk-add:0 > "$slt"
}

function dlg_text_info_5() {
    
    echo "${1}" | yad --text-info --title=" " \
    --name=Idiomind --class=Idiomind \
    --editable \
    --window-icon="$DS/images/icon.png" \
    --margins=5 --wrap \
    --center --sticky \
    --width=520 --height=150 --borders=5 \
    --button=Ok:0 > "$1.txt"
}

function dlg_text_info_4() {
    
    echo "${1}" | yad --text-info --title=Idiomind \
    --name=Idiomind --class=Idiomind \
    --window-icon="$DS/images/icon.png" \
    --text=" " \
    --margins=8 --wrap \
    --center --sticky \
    --width=600 --height=550 --borders=5 \
    --button=Ok:0
}

function audio_recog() {
    
    wget -q -U -T 101 -c "Mozilla/5.0" --post-file "${1}" \
    --header="Content-Type: audio/x-flac; rate=16000" \
    -O - "https://www.google.com/speech-api/v2/recognize?&lang=${2}-${3}&key=$4"
}

function dlg_file_1() {
    
    yad --file --title=" " \
    --name=Idiomind --class=Idiomind \
    --file-filter="*.mp3 *.tar *.zip *.tar.gz" \
    --window-icon="$DS/images/icon.png" \
    --skip-taskbar --on-top --center \
    --width=600 --height=450 --borders=0
}

function dlg_file_2() {
    
    yad --file --save --title="$(gettext "Save")" \
    --name=Idiomind --class=Idiomind \
    --filename="$(date +%m-%d-%Y)"_audio.tar.gz \
    --window-icon="$DS/images/icon.png" \
    --skip-taskbar --center --on-top \
    --width=600 --height=500 --borders=10 \
    --button=gtk-ok:0
}

if [[ ${conten^} = A ]]; then

    left=$((200 - $(wc -l < "${DC_tlt}/4.cfg")))
    key="$(sed -n 2p "$HOME/.config/idiomind/addons/gts.cfg" \
    | grep -o key=\"[^\"]* | grep -o '[^"]*$')"
    test="$DS/addons/Google translator/test.flac"
    LNK='https://console.developers.google.com'
    source "$DS/ifs/mods/cmns.sh"
    
    if [ -z "$key" ]; then
    msg "$(gettext "For this feature you need to provide a key. Please get one from the:")   <a href='$LNK'>console.developers.google.com</a>\n" dialog-warning
    cleanups "$lckpr" "$DT_r" & exit 1; fi
    
    cd "$HOME"; fl="$(dlg_file_1)"
    
    if [ -z "${fl}" ];then
    cleanups "$DT_r" "$lckpr" & exit 1
        
    else
        check_s "${tpe}"
        (
        echo "2"
        echo "# $(gettext "Processing... Wait.")";
        cd "$DT_r"
        
        if grep ".mp3" <<<"${fl: -4}"; then
        
            cp -f "${fl}" "$DT_r/rv.mp3"
            sox "$DT_r/rv.mp3" "$DT_r/c_rv.mp3" remix - highpass 100 norm \
            compand 0.05,0.2 6:-54,-90,-36,-36,-24,-24,0,-12 0 -90 0.1 \
            vad -T 0.6 -p 0.2 -t 5 fade 0.1 reverse \
            vad -T 0.6 -p 0.2 -t 5 fade 0.1 reverse norm -0.5
            rm -f "$DT_r/rv.mp3"
            sox "$DT_r/c_rv.mp3" s.mp3 \
            silence 1 0.5 1% 1 0.5 1% : newfile : restart

            c="$(ls "$DT_r"/s[0-9]*.mp3 | wc -l)"
            if [[ ${c} -ge 1 ]]; then
            (cd "$DT_r"; rename 's/^s0*//' *.mp3)
            elif [ $(du "$DT_r/c_rv.mp3" | cut -f1) -lt 400 ]; then
            mv -f "$DT_r/c_rv.mp3" "$DT_r/1.mp3"
            fi
            [ -f "$DT_r/c_rv.mp3" ] && rm -f "$DT_r/c_rv.mp3"
            
        elif grep ".tar" <<<"${fl: -4}"; then
        
            cp -f "$fl" "$DT_r/rv.tar"
            tar -xvf "$DT_r/rv.tar"
        
        elif grep ".tar.gz" <<<"${fl: -7}"; then
        
            cp -f "$fl" "$DT_r/rv.tar.gz"
            tar -xzvf "$DT_r/rv.tar.gz"
        
        elif grep ".zip" <<<"${fl: -4}"; then
        
            cp -f "$fl" "$DT_r/rv.zip"
            unzip "$DT_r/rv.zip"
        fi
        
        c="$(ls "$DT_r"/[0-9]*.mp3 | wc -l)"
        n=1; r=${c}
        while [[ ${n} -le ${c} ]]; do
        [ -f "$DT_r"/${n}.mp3 ] && \
        mv -f "$DT_r"/${n}.mp3 "$DT_r"/_${r}.mp3
        ((n=n+1))
        ((r=r-1))
        done
        (cd "$DT_r"; rename 's/^_*//' *.mp3)
        
        internet
        echo "3"
        echo "# $(gettext "Checking key")..."; sleep 1
        data="$(audio_recog "$test" $lgt $lgt $key)"
        if [ -z "${data}" ]; then
        key=$(sed -n 3p $DC_s/3.cfg)
        data="$(audio_recog "$test" $lgt $lgt $key)"; fi
        if [ -z "${data}" ]; then
        key=$(sed -n 4p $DC_s/3.cfg)
        data="$(audio_recog "$test" $lgt $lgt $key)"; fi
        if [ -z "${data}" ]; then
        msg "$(gettext "The key is invalid or has exceeded its quota of daily requests")" error
        cleanups "$DT_r" "$lckpr" & exit 1; fi
        
        echo "# $(gettext "Processing")..." ; sleep 0.2

        tpe=$(sed -n 2p "$DT/.n_s_pr")
        DM_tlt="$DM_tl/${tpe}"
        DC_tlt="$DM_tl/${tpe}/.conf"
        touch "$DT_r/wlog" "$DT_r/slog" "$DT_r/adds" "$DT_r/addw"

        if [ ! -d "${DM_tlt}" ]; then
        msg " $(gettext "An error occurred.")\n" dialog-warning
        cleanups "$DT_r" "$lckpr" "$slt" & exit 1; fi

        echo "1"
        echo "# $(gettext "Processing")...";
        internet
        if [ $lgt = ja -o $lgt = "zh-cn" -o $lgt = ru ];
        then c=c; else c=w; fi

        lns="$(ls "$DT_r"/[0-9]*.mp3 | wc -l | head -200)"
        n=1
        while [[ ${n} -le ${lns} ]]; do

            if [ -f "$DT_r"/${n}.mp3 ]; then
            
                sox "$DT_r"/${n}.mp3 "$DT_r/info.flac" rate 16k
                data="$(audio_recog "$DT_r/info.flac" $lgt $lgt $key)"
                
                if [ -z "${data}" ]; then
                msg "$(gettext "The key is invalid or has exceeded its quota of daily requests")\n" error
                "$DS/stop.sh" 5
                cleanups "$DT_r" "$lckpr" & break & exit 1; fi

                trgt="$(echo "${data}" | sed '1d' \
                | sed 's/.*transcript":"//' \
                | sed 's/"}],"final":true}],"result_index":0}//g' \
                | sed 's/.*transcript":"//g' \
                | sed 's/","confidence"://g' \
                | sed "s/[0-9].[0-9]//g" \
                | sed 's/}],"final":true}],"result_index":0}//g')"

                if [ ${#trgt} -ge 400 ]; then
                echo -e "\n\n#$n [$(gettext "Sentence too long")] $trgt" >> "$DT_r/slog"
                
                elif [ -z "$trgt" ]; then
                trgt="$n -------------------------------"
                id="$(set_name_file 2 "${trgt}" "" "" "" "" "")"
                index 2 "${tpe}" "${trgt}" "" "" "" "" "" "${id}"
                mv -f "$DT_r/${n}.mp3" "${DM_tlt}/$id.mp3"
                echo -e "\n\n#$n [$(gettext "Text missing")]" >> "$DT_r/slog"
                
                elif [[ $(wc -l < "${DC_tlt}/0.cfg") -ge 200 ]]; then
                echo -e "\n\n#$n [$(gettext "Maximum number of notes has been exceeded")] $trgt" >> "$DT_r/slog"
                
                else
                    trgt=$(clean_2 "${trgt}")
                    srce="$(translate "${trgt}" $lgt $lgs | sed ':a;N;$!ba;s/\n/ /g')"
                    srce="$(clean_2 "${srce}")"
                    
                    if [ $(wc -$c <<<"${trgt}") -eq 1 ]; then
                    
                        trgt="$(clean_1 "${trgt}")"
                        srce="$(clean_1 "${srce}")"
                        id="$(set_name_file 1 "${trgt}" "${srce}" "" "" "" "" "")"
                        audio="${trgt,,}"
                        mksure "${trgt}" "${srce}"
                        
                        if [ $? = 0 ]; then

                            index 1 "${tpe}" "${trgt}" "${srce}" "" "" "" "" "${id}"
                            mv -f "$DT_r/${n}.mp3" "${DM_tls}/$audio.mp3"
                            echo "${trgt}" >> "$DT_r/addw"
                            
                        else
                            echo -e "\n\n#$n $trgt" >> "$DT_r/wlog"
                        fi
                            
                    elif [ $(wc -$c <<<"$trgt") -ge 1 ]; then

                        (
                        sentence_p "$DT_r" 1
                        id="$(set_name_file 2 "${trgt}" "${srce}" "" "" "${wrds}" "${grmr}")"
                        mksure "${trgt}" "${srce}" "${wrds}" "${grmr}"
                        
                            if [ $? = 0 ]; then
                                
                                index 2 "${tpe}" "${trgt}" "${srce}" "" "" "${wrds}" "${grmr}" "${id}"
                                mv -f "$DT_r/${n}.mp3" "${DM_tlt}/$id.mp3"
                                echo "${trgt}" >> "$DT_r/adds"
                                fetch_audio "$aw" "$bw"
                                
                            else
                                echo -e "\n\n#$n $trgt" >> "$DT_r/slog"
                            fi
                        rm -f "$aw" "$bw"
                        )
                    fi
                fi
                rm -f "$DT_r/info.flac" "$DT_r/info.ret"
            else
                continue
            fi

            prg=$((100*n/lns-1))
            echo "$prg"
            echo "# ${trgt:0:35}..." ;
            
            let n++
        done 

        ) | dlg_progress_2
        
        if  [ $? != 0 ] && [ "$(ls "$DT_r"/[0-9]* | wc -l)" -ge 1 ]; then
            
            kill -9 $(pgrep -f "wget -q -U -T 101 -c")
            btn="--button="$(gettext "Save Audio")":0"
            dlg_text_info_3 "$(gettext "Some items could not be added to your list")" "$logs" "$btn" >/dev/null 2>&1

                if  [ $? -eq 0 ]; then
                    aud=`dlg_file_2`

                    if [ $? -eq 0 ]; then
                        mkdir "$DT_r/rest"
                        mv -f "$DT_r"/[0-9]*.mp3 "$DT_r/rest"/
                        cd "$DT_r/rest"
                        tar cvzf "$DT_r/audio.tar.gz" ./*
                        mv -f "$DT_r/audio.tar.gz" "${aud}"; fi
                fi
        fi
        
        wadds=" $(($(wc -l < "$DT_r/addw") - $(sed '/^$/d' "$DT_r/wlog" | wc -l)))"
        W=" $(gettext "words")"
        if [ $wadds = 1 ]; then
        W=" $(gettext "word")"; fi
        sadds=" $(($(wc -l < "$DT_r/adds") - $(sed '/^$/d' "$DT_r/swlog" | wc -l)))"
        S=" $(gettext "sentences")"
        if [ $sadds = 1 ]; then
        S=" $(gettext "sentence")"; fi
        logs=$(cat "$DT_r/slog" "$DT_r/wlog")
        adds=$(cat "$DT_r/adds" "$DT_r/addw" |sed '/^$/d' |wc -l)
        
        if [[ ${adds} -ge 1 ]]; then
        notify-send -i idiomind "$tpe" \
        "$(gettext "Have been added:")\n$sadds$S$wadds$W" -t 2000 &
        echo ".adi.$adds.adi." >> "$DC_s/log"; fi
        
        if [ -n "$logs" -o "$(ls "$DT_r"/[0-9]* | wc -l)" -ge 1 ]; then
        
            if [ "$(ls "$DT_r"/[0-9]* | wc -l)" -ge 1 ]; then
            btn="--button="$(gettext "Save Audio")":0"; fi

            dlg_text_info_3 "$(gettext "Some items could not be added to your list")" "$logs" "$btn" >/dev/null 2>&1

                if  [ $? -eq 0 ]; then
                    aud=`dlg_file_2`

                        if [ $? -eq 0 ]; then
                        mkdir "$DT_r/rest"
                        mv -f "$DT_r"/[0-9]*.mp3 "$DT_r/rest"/
                        cd "$DT_r/rest"
                        tar cvzf "$DT_r/audio.tar.gz" ./*
                        mv -f "$DT_r/audio.tar.gz" "${aud}"; fi
                fi
        fi
        
        cleanups "$DT_r" "$lckpr"
    fi
    exit
    
elif [ "$1" = item_for_edit ]; then

    DT_r=$(sed -n 1p "$DT/.n_s_pr"); cd "$DT_r"
    dlg_text_info_5 "$3"
    $? >/dev/null 2>&1
fi
