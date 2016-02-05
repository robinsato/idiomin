#!/bin/bash
# -*- ENCODING: UTF-8 -*-

source /usr/share/idiomind/default/c.conf
source "$DS/ifs/mods/cmns.sh"
source $DS/default/sets.cfg
lgt=${lang[$lgtl]}
lgs=${slang[$lgsl]}

function dwld() {
    err() {
        cleanups "$DT/download" &
        msg "$(gettext "A problem has occurred while fetching data, try again later.")\n" info
    }
    sleep 0.5
    msg "$(gettext "When the download completes the files will be added to topic directory.")" info "$(gettext "Downloading")"
    kill -9 $(pgrep -f "yad --form --columns=1")
    mkdir "$DT/download"; idcfg="$DM_tl/${2}/.conf/id.cfg"
    ilink=$(grep -o 'ilink="[^"]*' "${idcfg}" |grep -o '[^"]*$')
    md5id=$(grep -o 'md5id="[^"]*' "${idcfg}" |grep -o '[^"]*$')
    oname=$(grep -o 'oname="[^"]*' "${idcfg}" |grep -o '[^"]*$')
    langt=$(grep -o 'langt="[^"]*' "${idcfg}" |grep -o '[^"]*$')
    [ -z "${oname}" ] && oname="${tpc}"
    pre="$(sed 's/ /_/g' <<< "${oname:0:10}")"
    url1="$(curl http://idiomind.sourceforge.net/doc/SITE_TMP \
    |grep -o 'DOWNLOADS="[^"]*' |grep -o '[^"]*$')"
    url2="$(curl http://idiomind.sourceforge.net/doc/SITE_TMP \
    |grep -o 'DOWNLOADS2="[^"]*' |grep -o '[^"]*$')"
    url1="$url1/c/${langt,,}/${pre}${md5id}.tar.gz"
    url2="$url2/c/${langt,,}/${pre}${md5id}.tar.gz"
    if wget -S --spider "${url1}" 2>&1 |grep 'HTTP/1.1 200 OK'; then
        URL="${url1}"
    elif wget -S --spider "${url2}" 2>&1 |grep 'HTTP/1.1 200 OK'; then
        URL="${url2}"
    else err & exit
    fi
    wget -q -c -T 80 -O "$DT/download/${md5id}.tar.gz" "${URL}"
    [ $? != 0 ] && err && exit 1
    
    if [ -f "$DT/download/${md5id}.tar.gz" ]; then
        cd "$DT/download"/
        tar -xzvf "$DT/download/${md5id}.tar.gz"
        
        if [ -d "$DT/download/${oname}" ]; then
            ltotal="$(gettext "Total")"
            laudio="$(gettext "Audio files")"
            limage="$(gettext "Images")"
            lothers="$(gettext "Others")"
            tmp="$DT/download/${oname}"
            total=$(find "${tmp}" -maxdepth 5 -type f | wc -l)
            c_audio=$(find "${tmp}" -maxdepth 5 -name '*.mp3' | wc -l)
            c_images=$(find "${tmp}" -maxdepth 5 -name '*.jpg' | wc -l)
            hfiles="$(cd "${tmp}"; ls -d ./.[^.]* | less | wc -l)"
            exfiles="$(find "${tmp}" -maxdepth 5 -perm -111 -type f | wc -l)"
            others=$((wchfiles+wcexfiles))
            mv -f "${tmp}/conf/info" "${DC_tlt}/info"
            [ ! -d "$DM_t/$langt/.share/images" ] && mkdir -p "$DM_t/$langt/.share/images"
            [ ! -d "$DM_t/$langt/.share/audio" ] && mkdir -p "$DM_t/$langt/.share/audio"
            mv -n "${tmp}/share"/*.mp3 "$DM_t/$langt/.share/audio"/
            [ ! -f "${DM_tlt}/images" ] && mkdir "${DM_tlt}/images"
            [ -f "${tmp}"/images/img.jpg  ] && \
            mv "${tmp}"/images/img.jpg "${DM_tlt}"/images/img.jpg
            while read -r img; do
                if [ -f "${tmp}/images/${img,,}-0.jpg" ]; then
                if [ -f "$DM_t/$langt/.share/images/${img,,}-0.jpg" ]; then
                    n=`ls "${DM_tls}/images/${img,,}"-*.jpg |wc -l`
                    name_img="${DM_tls}/images/${img,,}"-${n}.jpg
                else name_img="${DM_tls}/images/${img,,}-0.jpg"; fi
                    mv -f "${tmp}/images/${img,,}-0.jpg" "${name_img}"; fi
            done < "${DC_tlt}/3.cfg"
            rm -fr "${tmp}/share" "${tmp}/conf" "${tmp}/images"
            mv -f "${tmp}"/*.mp3 "${DM_tlt}"/
            echo "${oname}" >> "$DM_tl/.share/3.cfg"
            echo -e "$ltotal $total\n$laudio $c_audio\n$limage $c_images\n$lothers $others" > "${DC_tlt}/download"
            "$DS/ifs/tls.sh" colorize
            rm -fr "$DT/download"
        else
            err & exit
        fi
    else
        err & exit
    fi
    exit
}

function upld() {
    if [ -d "$DT/upload" -o -d "$DT/download" ]; then
        [ -e "$DT/download" ] && t="$(gettext "Downloading")..." || t="$(gettext "Uploading")..."
        msg_2 "$(gettext "Wait until it finishes a previous process")\n" dialog-warning OK gtk-stop "$t"
        ret="$?"
        if [ $ret -eq 1 ]; then
            cleanups "$DT/upload" "$DT/download"
            "$DS/stop.sh" 5
        fi
        exit 1
    fi
    
    conditions_for_upload() {
        if [ -z "${usrid}" -o -z "${passw}" ]; then
            msg "$(gettext "Sorry, Authentication failed.")\n" info "$(gettext "Information")" & exit 1
        fi
        if [ -z "${ctgry}" ]; then
            msg "$(gettext "Please select a category.")\n " info
            "$DS/ifs/upld.sh" upld "${tpc}" & exit 1
        fi
        [ -d "$DT" ] && cd "$DT" || exit 1
        [ -d "$DT/upload" ] && rm -fr "$DT/upload"
        
        if [ "${tpc}" != "${1}" ]; then
            msg "$(gettext "Sorry, this topic is currently not active.")\n " info & exit 1
        fi
        internet
    }

    dlg_getuser() {
        yad --form --title="$(gettext "Share")" \
        --text="$text_upld" \
        --name=Idiomind --class=Idiomind \
        --always-print-result \
        --window-icon=idiomind --buttons-layout=end \
        --align=right --center --on-top \
        --width=480 --height=470 --borders=12 \
        --field="$(gettext "Category"):CB" "" \
        --field="$(gettext "Skill Level"):CB" "" \
        --field="\n$(gettext "Description/Notes"):TXT" "${note}" \
        --field="$(gettext "Author")" "$usrid" \
        --field="\t\t$(gettext "Password")" "$passw" \
        --field="<a href='$linkac'>$(gettext "Get account to share")</a> \n":LBL \
        --button="$(gettext "Export")":2 --button="$(gettext "Close")":4
    }
    
    dlg_upload() {
        yad --form --title="$(gettext "Share")" \
        --text="$text_upld" \
        --name=Idiomind --class=Idiomind \
        --always-print-result \
        --window-icon=idiomind --buttons-layout=end \
        --align=right --center --on-top \
        --width=480 --height=470 --borders=12 \
        --field="$(gettext "Category"):CBE" "$_categories" \
        --field="$(gettext "Skill Level"):CB" "$_levels" \
        --field="\n$(gettext "Description/Notes"):TXT" "${note}" \
        --field="$(gettext "Author")" "$usrid" \
        --field="\t\t$(gettext "Password")" "$passw" \
        --field=" ":LBL "" \
        --button="$(gettext "Export")":2 "$btn" --button="$(gettext "Close")":4
    }

    dlg_dwld_content() {
        c_audio="$(grep -o 'naudi="[^"]*' "${DC_tlt}/id.cfg" |grep -o '[^"]*$')"
        c_images="$(grep -o 'nimag="[^"]*' "${DC_tlt}/id.cfg" |grep -o '[^"]*$')"
        fsize="$(grep -o 'nsize="[^"]*' "${DC_tlt}/id.cfg" |grep -o '[^"]*$')"
        cmd_dwl="$DS/ifs/upld.sh 'dwld' "\"${tpc}\"""
        info="<b>$(gettext "Downloadable content available")</b>"
        info2="$(gettext "Audio files:") $c_audio\n$(gettext "Images:") $c_images\n$(gettext "Size:") $fsize"
        yad --form --columns=1 --title="$(gettext "Share")" \
        --name=Idiomind --class=Idiomind \
        --always-print-result \
        --image="info" \
        --window-icon=idiomind --buttons-layout=end \
        --align=left --center --on-top \
        --width=480 --height=150 --borders=10 \
        --text="$info" \
        --field="$info2:lbl" " " \
        --button="$(gettext "Export")":2 \
        --button="$(gettext "Download")":"${cmd_dwl}" \
        --button="$(gettext "Close")":4
    } 
    
    dlg_export() {
        yad --form --title="$(gettext "Share")" \
        --separator="|" \
        --name=Idiomind --class=Idiomind \
        --window-icon=idiomind --buttons-layout=end \
        --align=left --center --on-top \
        --width=480 --height=150 --borders=10 \
        --field="<b>$(gettext "Downloaded files")</b>:lbl" " " \
        --field="$(< "${DC_tlt}/download"):lbl" " " \
        --field=" :lbl" " " \
        --button="$(gettext "Export")":2 \
        --button="$(gettext "Close")":4
    }
    
    random_id() { tr -dc a-z < /dev/urandom |head -c 1; echo $((RANDOM%100)); }

    emrk='!'
    for val in "${CATEGORIES[@]}"; do
        declare clocal="$(gettext "${val^}")"
        list="${list}${emrk}${clocal}"
    done
    
    LANGUAGE_TO_LEARN="${lgtl}"
    linkc="http://community.idiomind.net/${lgtl,,}"
    linkac='http://community.idiomind.net/?q=user/register'
    ctgry="$(grep -o 'ctgry="[^"]*' "${DC_tlt}/id.cfg" |grep -o '[^"]*$')"
    text_upld="<span font_desc='Arial 12'>$(gettext "Share online with other ${LANGUAGE_TO_LEARN} learners!")</span>\n<a href='$linkc'>$(gettext "Topics shared")</a> Beta\n"
    _categories="${ctgry}${list}"
    _levels="!$(gettext "Beginner")!$(gettext "Intermediate")!$(gettext "Advanced")"
    note=$(< "${DC_tlt}/info")
    usrid="$(grep -o 'usrid="[^"]*' "$DC_s/3.cfg" |grep -o '[^"]*$')"
    passw="$(grep -o 'passw="[^"]*' "$DC_s/3.cfg" |grep -o '[^"]*$')"

    # dialogs
    if [ $((inx3+inx4)) -lt 5 ]; then exit 1; fi
    if [ $((inx3+inx4)) -ge 15 ]; then
    btn="--button="$(gettext "Upload")":0"; else
    btn="--center"; fi

    if [[ -e "${DC_tlt}/download" ]]; then
        if [[ ! -s "${DC_tlt}/download" ]]; then
            dlg="$(dlg_dwld_content)"; ret=$?
        else
            dlg="$(dlg_export)"; ret=$?
        fi
    else
        shopt -s extglob
        if [ -z "${usrid##+([[:space:]])}" -o -z "${passw##+([[:space:]])}" ]; then
            dlg="$(dlg_getuser)"; ret=$?
        elif [ -n "${usrid}" -o -n "${passw}" ]; then
            dlg="$(dlg_upload)"; ret=$?
            
        fi
        [ $ret = 1 ] && exit 1
        dlg="$(echo "${dlg}" |tail -n1)"
        ctgry=$(echo "${dlg}" | cut -d "|" -f1)
        level=$(echo "${dlg}" | cut -d "|" -f2)
        notes_m=$(echo "${dlg}" | cut -d "|" -f3)
        usrid_m=$(echo "${dlg}" | cut -d "|" -f4)
        passw_m=$(echo "${dlg}" | cut -d "|" -f5)
        # get data
        for val in "${CATEGORIES[@]}"; do
            [ "$ctgry" = "$(gettext "${val^}")" ] && ctgry=$val
        done
        [ "$level" = $(gettext "Beginner") ] && level=0
        [ "$level" = $(gettext "Intermediate") ] && level=1
        [ "$level" = $(gettext "Advanced") ] && level=2

        # save data
        if [ "${usrid}" != "${usrid_m}" -o "${passw}" != "${passw_m}" ]; then
            echo -e "usrid=\"$usrid_m\"\npassw=\"$passw_m\"" > "$DC_s/3.cfg"
        fi
        if [ "${note}" != "${notes_m}"  ]; then
            echo -e "${notes_m}" > "${DC_tlt}/info"
        fi
    fi
    # actions
    if [ $ret = 2 ]; then
        if [ -d "$DT/export" ]; then
            msg_2 "$(gettext "Wait until it finishes a previous process").\n" info OK gtk-stop "$(gettext "Information")"
            ret=$?
            if [ $ret -eq 1 ]; then
                [ -d "$DT/export" ] && rm -fr "$DT/export"
            fi
            exit 1
        else
            "$DS/ifs/upld.sh" _export "${tpc}" & exit 1
        fi
    elif [ $ret = 0 ]; then
        conditions_for_upload "${2}"
        "$DS/ifs/tls.sh" check_index "${tpc}" 1
        notify-send -i info "$(gettext "Upload in progress")" \
        "$(gettext "This can take some time please wait")" -t 6000
        mkdir -p "$DT/upload/${tpc}/conf"
        DT_u="$DT/upload/"
        oname="$(grep -o 'oname="[^"]*' "${DC_tlt}/id.cfg" |grep -o '[^"]*$')"
        [ -z "${oname}" ] && oname="${tpc}"
        pre="$(sed 's/ /_/g' <<< "${oname:0:10}")"
        datec="$(grep -o 'datec="[^"]*' "${DC_tlt}/id.cfg" |grep -o '[^"]*$')"
        datei="$(grep -o 'datei="[^"]*' "${DC_tlt}/id.cfg" |grep -o '[^"]*$')"
        dateu=$(date +%F)
        tpcid=`random_id`
        c_words=${inx3}
        c_sntncs=${inx4}
        sum=`md5sum "${DC_tlt}/0.cfg" | cut -d' ' -f1`

        # copying files
        cd "${DM_tlt}"/
        cp -r ./* "$DT_u/${tpc}/"
        mkdir "$DT_u/${tpc}/share"
        [ ! -d "$DT_u/${tpc}/images" ] && mkdir "$DT_u/${tpc}/images"

        auds="$(uniq < "${DC_tlt}/4.cfg" \
        | sed 's/\n/ /g' | sed 's/ /\n/g' \
        | grep -v '^.$' | grep -v '^..$' \
        | sed 's/&//; s/,//; s/\?//; s/\¿//; s/;//'g \
        |  sed 's/\!//; s/\¡//; s/\]//; s/\[//; s/\.//; s/  / /'g \
        | tr -d ')' | tr -d '(' | tr '[:upper:]' '[:lower:]')"
        while read -r audio; do
            if [ -f "$DM_tl/.share/audio/$audio.mp3" ]; then
                cp -f "$DM_tl/.share/audio/$audio.mp3" \
                "$DT_u/${tpc}/share/$audio.mp3"
            fi
        done <<<"$auds"
        while read -r audio; do
            if [ -f "$DM_tl/.share/audio/${audio,,}.mp3" ]; then
                cp -f "$DM_tl/.share/audio/${audio,,}.mp3" \
                "$DT_u/${tpc}/share/${audio,,}.mp3"
            fi
        done < "${DC_tlt}/3.cfg"
        while read -r img; do
            if [ -f "$DM_tl/.share/images/${img,,}-0.jpg" ]; then
                cp -f "$DM_tl/.share/images/${img,,}-0.jpg" \
                "$DT_u/${tpc}/images/${img,,}-0.jpg"
            fi
        done < "${DC_tlt}/3.cfg"
        c_audio=$(find "$DT_u/${tpc}" -maxdepth 5 -name '*.mp3' |wc -l)
        c_images=$(cd "$DT_u/${tpc}/images"/; ls *.jpg |wc -l)
        cp "${DC_tlt}/6.cfg" "$DT_u/${tpc}/conf/6.cfg"
        cp "${DC_tlt}/info" "$DT_u/${tpc}/conf/info"

        # create tar
        cd "$DT/upload"/
        find "$DT_u"/ -type f -exec chmod 644 {} \;
        tar czpvf - ./"${tpc}" |split -d -b 2500k - ./"${pre}${sum}"
        rm -fr ./"${tpc}"; rename 's/(.*)/$1.tar.gz/' *
        
        # create id
        f_size=$(du -h . |cut -f1)
        eval c="$(< "$DS/default/topic.cfg")"
        echo -n "${c}" > "${DC_tlt}/id.cfg"
        cp -f "${DC_tlt}/0.cfg" "$DT_u/$tpcid.${tpc}.$lgt"
        tr '\n' '&' < "${DC_tlt}/id.cfg" >> "$DT_u/$tpcid.${tpc}.$lgt"
        echo -n "&idiomind-`idiomind -v`" >> "$DT_u/$tpcid.${tpc}.$lgt"
        echo -en "\nidiomind-`idiomind -v`" >> "${DC_tlt}/id.cfg"
        url="$(curl http://idiomind.sourceforge.net/doc/SITE_TMP \
        | grep -o 'UPLOADS="[^"]*' | grep -o '[^"]*$')"
        direc="$DT_u"
        log="$DT_u/log"
        body="<hr><br><a href='/${lgtl,}/${ctgry,}/$tpcid.$oname.idmnd'>Download</a>"
        export tpc direc url log usrid_m passw_m body

        python << END
import os, sys, requests, time, xmlrpclib
reload(sys)
sys.setdefaultencoding("utf-8")
usrid = os.environ['usrid_m']
passw = os.environ['passw_m']
tpc = os.environ['tpc']
body = os.environ['body']
try:
    server = xmlrpclib.Server('http://community.idiomind.net/xmlrpc.php')
    nid = server.metaWeblog.newPost('blog', usrid, passw, 
    {'title': tpc, 'description': body}, True)
except:
    sys.exit(3)
url = os.environ['url']
direc = os.environ['direc']
log = os.environ['log']
volumes = [i for i in os.listdir(direc)]
for f in volumes:
    file = {'file': open(f, 'rb')}
    r = requests.post(url, files=file)
    p = open(log, "w")
    p.write("x")
    p.close()
    time.sleep(5)
END
        u=$?
        if [ $u = 0 ]; then
            info="\"$tpc\"\n<b>$(gettext "Uploaded correctly")</b>\n"
            image=gtk-ok
        elif [ $u = 3 ]; then
            info="$(gettext "Authentication error.")\n"
            image=error
        else
            sleep 5
            info="$(gettext "A problem has occurred with the file upload, try again later.")\n"
            image=error
        fi
        msg "$info" $image

        cleanups "${DT_u}"
        exit 0
    fi
    
} >/dev/null 2>&1

fdlg() {
    tpcs="$(cd "$DS/ifs/mods/export"; ls \
    |sed 's/\.sh//g'|tr "\\n" '!' |sed 's/\!*$//g')"
    key=$((RANDOM%100000)); cd "$HOME"
    yad --file --save --filename="$HOME/$tpc" --tabnum=1 --plug="$key" &
    yad --form --tabnum=2 --plug="$key" \
    --separator="" --align=right \
    --field="\t\t\t\t$(gettext "Export to"):CB" "$tpcs" &
    yad --paned --key="$key" --title="$(gettext "Export")" \
    --name=Idiomind --class=Idiomind \
    --window-icon=idiomind --center --on-top \
    --width=600 --height=500 --borders=8 --splitter=370 \
    --button="$(gettext "Cancel")":1 \
    --button="$(gettext "Save")":0
}

_export() {
    dlg="$(fdlg)"
    ret=$?
    if [ $ret -eq 0 ]; then
        "$DS/ifs/mods/export/$(head -n 1 <<<"$dlg").sh" \
        "$(tail -n 1 <<<"$dlg")" "${tpc}" & exit 0
    fi
} >/dev/null 2>&1

case "$1" in
    vsd)
    vsd "$@" ;;
    infsd)
    infsd "$@" ;;
    dwld)
    dwld "$@" ;;
    upld)
    upld "$@" ;;
    _export)
    _export "$@" ;;
    share)
    download "$@" ;;
esac
