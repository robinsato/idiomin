#!/bin/bash

source /usr/share/idiomind/ifs/c.conf
source "$DS/ifs/mods/cmns.sh"

#if [ -z "$channel" ]; then
#channel="$(eyeD3 --no-color "media.$ex" \
#| grep -o -P '(?<=title:).*(?=artist:)' \
#| sed -e 's/^[ \t]*//g' | tr -s '\ \t' \
#| sed -e "s/[[:space:]]\+/ /g" | sed 's/\&/&amp;/g' \
#| sed 's/^ *//; s/ *$//; /^$/d' | tr -s ':')"; fi

play() {

    killall play
    DCP="$DM_tl/Feeds/.conf"
    [ -f "$DCP/0.cfg" ] && st3=$(sed -n 2p "$DCP/0.cfg") || st3=FALSE
    [ $st3 = FALSE ] && fs="" || fs='-fs'
    
    if [ -f "$DM_tl/Feeds/cache/$2.mp3" ]; then
        play "$DM_tl/Feeds/cache/$2.mp3" & exit
    elif [ -f "$DM_tl/Feeds/cache/$2.ogg" ]; then
        play "$DM_tl/Feeds/cache/$2.ogg" & exit
    elif [ -f "$DM_tl/Feeds/cache/$2.mp4" ]; then
        mplayer "$fs" "$DM_tl/Feeds/cache/$2.mp4" \
        >/dev/null 2>&1 & exit
    elif [ -f "$DM_tl/Feeds/cache/$2.m4v" ]; then
        mplayer "$fs" "$DM_tl/Feeds/cache/$2.m4v" \
        >/dev/null 2>&1 & exit
    elif [ -f "$DM_tl/Feeds/cache/$2.avi" ]; then
        mplayer "$fs" "$DM_tl/Feeds/cache/$2.avi" \
        >/dev/null 2>&1 & exit
    elif [ -f "$DM_tl/Feeds/cache/$2.flv" ]; then
        mplayer "$fs" "$DM_tl/Feeds/cache/$2.flv" \
        >/dev/null 2>&1 & exit
    elif [ -f "$DM_tl/Feeds/cache/$2.mov" ]; then
        mplayer "$fs" "$DM_tl/Feeds/cache/$2.mov" \
        >/dev/null 2>&1 & exit
    fi
}

set_channel() {
    
tmpl1="<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet version='1.0'
xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
xmlns:itunes='http://www.itunes.com/dtds/podcast-1.0.dtd'
xmlns:media='http://search.yahoo.com/mrss/'
xmlns:atom='http://www.w3.org/2005/Atom'>
<xsl:output method='text'/>
<xsl:template match='/'>
<xsl:for-each select='/rss/channel'>
<xsl:value-of select='title'/><xsl:text>-!-</xsl:text>
<xsl:value-of select='link'/><xsl:text>-!-</xsl:text>
<xsl:value-of select='image'/><xsl:text>-!-</xsl:text>
<xsl:value-of select='image/@url'/><xsl:text>-!-</xsl:text>
<xsl:value-of select='itunes:image[@type=\"image/jpeg\"]/@href'/><xsl:text>-!-</xsl:text>
</xsl:for-each>
</xsl:template>
</xsl:stylesheet>"

tmpl2="<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet version='1.0'
xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
xmlns:itunes='http://www.itunes.com/dtds/podcast-1.0.dtd'
xmlns:media='http://search.yahoo.com/mrss/'
xmlns:atom='http://www.w3.org/2005/Atom'>
<xsl:output method='text'/>
<xsl:template match='/'>
<xsl:for-each select='/rss/channel/item'>
<xsl:value-of select='enclosure/@url'/><xsl:text>-!-</xsl:text>
<xsl:value-of select='media:cache[@type=\"audio/mpeg\"]/@url'/><xsl:text>-!-</xsl:text>
<xsl:value-of select='title'/><xsl:text>-!-</xsl:text>
<xsl:value-of select='media:cache[@type=\"audio/mpeg\"]/@duration'/><xsl:text>-!-</xsl:text>
<xsl:value-of select='itunes:summary'/><xsl:text>-!-</xsl:text>
<xsl:value-of select='description'/><xsl:text>EOL</xsl:text>
</xsl:for-each>
</xsl:template>
</xsl:stylesheet>"

tmpl3="<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet version='1.0'
xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
xmlns:itunes='http://www.itunes.com/dtds/podcast-1.0.dtd'
xmlns:media='http://search.yahoo.com/mrss/'
xmlns:atom='http://www.w3.org/2005/Atom'>
<xsl:output method='text'/>
<xsl:template match='/'>
<xsl:for-each select='/rss/channel/item'>
<xsl:value-of select='enclosure/@url'/><xsl:text>-!-</xsl:text>
<xsl:value-of select='media:cache[@type=\"image/jpeg\"]/@url'/><xsl:text>-!-</xsl:text>
<xsl:value-of select='media:content[@type=\"image/jpeg\"]/@url'/><xsl:text>-!-</xsl:text>
<xsl:value-of select='title'/><xsl:text>-!-</xsl:text>
<xsl:value-of select='media:cache[@type=\"image/jpeg\"]/@duration'/><xsl:text>-!-</xsl:text>
<xsl:value-of select='itunes:summary'/><xsl:text>-!-</xsl:text>
<xsl:value-of select='description'/><xsl:text>EOL</xsl:text>
</xsl:for-each>
</xsl:template>
</xsl:stylesheet>"
    
    feed="$2"
    num="$3"
    DCP="$DM_tl/Feeds/.conf"
    
    xml="$(xsltproc - "$feed" <<< "$tmpl1" 2> /dev/null)"
    items1="$(echo "$xml" | tr '\n' ' ' | tr -s '[:space:]' \
    | sed 's/EOL/\n/g' | head -n 1 | sed -r 's|-\!-|\n|g')"

    xml="$(xsltproc - "$feed" <<< "$tmpl2" 2> /dev/null)"
    items2="$(echo "$xml" | tr '\n' ' ' | tr -s [:space:] \
    | sed 's/EOL/\n/g' | head -n 1 | sed -r 's|-\!-|\n|g')"
    
    xml="$(xsltproc - "$feed" <<< "$tmpl3" 2> /dev/null)"
    items3="$(echo "$xml" | tr '\n' ' ' | tr -s [:space:] \
    | sed 's/EOL/\n/g' | head -n 1  | sed -r 's|-\!-|\n|g')"

    fchannel() {
        
        n=1;
        while read -r find; do

            if [ $(wc -w <<< "${find}") -ge 1 ] && [ -z "$name" ]; then
                name="$find"
                n=2; fi
                
            if [ -n "$(grep 'http:/' <<< "${find}")" ] && [ -z "$link" ]; then
                link="$find"
                n=3; fi
                
            if [ -n "$(grep -E '.jpeg|.jpg|.png' <<< "${find}")" ] && [ -z "$logo" ]; then
                logo="$find"; fi
                
            let n++
        done <<< "$items1"
    }
   
    ftype1() {
        
        n=1
        while read -r find; do
            [[ $n = 3 || $n = 5 || $n = 6 ]] && continue
            if ([ -n "$(grep -o -E '\.mp3|\.mp4|\.ogg|\.avi|\.m4v|\.mov|\.flv' <<< "${find}")" ] && [ -z "$media" ]); then

            media="$n"; type=1; break; fi
            let n++
        done <<< "$items2"
        
        n=3
        while read -r find; do
            if ([ $(wc -w <<< "${find}") -ge 1 ] && [ $(wc -w <<< "${find}") -le 180 ] && [ -z "$title" ]); then
            title="$n"; break; fi
            let n++
        done <<< "$items2"

        n=5
        while read -r find; do
            if ([ $(wc -w <<< "${find}") -ge 1 ] && [ -z "$summ" ]); then
            summ="$n"; break; fi
            let n++
        done <<< "$items2"
    }
    
    ftype2() {

        n=1
        while read -r find; do
            if ([ -n "$(grep -o -E '\.jpg|\.jpeg|\.png' <<< "${find}")" ] && [ -z "$image" ]); then
            image="$n"; type=2; break ; fi
            let n++
        done <<< "$items3"
        
        n=4
        while read -r find; do
            if ([ $(wc -w <<< "${find}") -ge 1 ] && [ -z "$title" ]); then
            title="$n"; break ; fi
            let n++
        done <<< "$items3"
        
        n=6
        while read -r find; do
            if ([ $(wc -w <<< "${find}") -ge 1 ] && [ -z "$summ" ]); then
                summ="$n"; break ; fi
            let n++
        done <<< "$items3"
    }

    find_images() {

        n=1
        while read -r find; do
            if ([ -n "$(grep -E '\.jpg|\.jpeg|.png' <<< "${find}")" ] && [ -z "$image" ]); then
                type=2
                image="$n"; break; fi
            if ([ -n "$(grep -o 'media:thumbnail url="[^"]*' | grep -o '[^"]*$')" <<< "${find}" ] && [ -z "$image" ]); then
                image="$n"; break; fi
                type=2
            if ([ -n "$(grep -o 'img src="[^"]*' | grep -o '[^"]*$')" <<< "${find}" ] && [ -z "$image" ]); then
                type=2
                image="$n"; break; fi
            let n++
        done <<< "$items3"
    }
    
    find_summ() {

        n=1
        while read -r find; do
            if [ $(wc -w <<< "${find}") -ge 1 ]; then
                summ="$n"; break; fi
            let n++
        done <<< "$items3"
    }
    
    fchannel
    ftype1
    if [ -z "$type" ]; then
        ftype2
        if [ -z $image ]; then
        find_images
        fi
        if [ -z $summ ]; then
            find_summ
        fi
    fi

    if [[ -n "$title" && -n "$summ" && -z "$image" && -z "$media" ]]; then
        type=3
    fi
    
    if [ -n "$type" ]; then
        
cfg="channel=\"$name\"
link=\"$link\"
logo=\"$logo\"
ntype=\"$type\"
nmedia=\"$media\"
ntitle=\"$title\"
nsumm=\"$summ\"
nimage=\"$image\"
url=\"$feed\""

        echo -e "$cfg" > "$DCP/$num.rss" # --------------------

        exit 0
    else
        msg "$(gettext "Couldn't download the specified URL")\n" info
        rm -f "$DT/cpt.lock" & exit 1
    fi
}
    
check() {

    source $DS/ifs/mods/cmns.sh
    DCP="$DM_tl/Feeds/.conf"
    DSP="$DS_a/Feeds"
    [ -f "$DT/cpt.lock" ] && exit || touch "$DT/cpt.lock"

    internet
    
    source "$DCP/$2.rss"

    [ -z "$url" ] && exit 1
     
    [ ! -f "$DCP/$2.rss" ] && printf "$tpl" > "$DCP/$2.rss"
    
    cp "$DCP/$2.rss" "$DCP/$2.rss_"
    
    
    podcast_items="$(xsltproc - "$url" <<<"$tmpl2" 2>/dev/null)"
    podcast_items="$(echo "$podcast_items" | tr '\n' ' ' | tr -s [:space:] | sed 's/EOL/\n/g' | head -n 2)"
    item="$(echo "$podcast_items" | sed -n 1p)"
    
    if [ -z "$(echo $item | sed 's/^ *//; s/ *$//; /^$/d')" ]; then
    msg "$(gettext "Couldn't download the specified URL")\n" info
    rm -f "$DT/cpt.lock" & exit 1
    fi
    
    field="$(echo "$item" | sed -r 's|-\!-|\n|g')"

    yad --form --title="$ttl" \
    --name=Idiomind --class=Idiomind \
    --always-print-result --separator='\n' \
    --window-icon=$wicon --columns=2 --skip-taskbar --scroll --on-top \
    --width=800 --height=600 --borders=5 \
    --text="\t<small>$(gettext "In this table you can define fields according to their content,  most of the time the default values is right. ")</small>" \
    --field="":CB "$(sed -n 1p $DCP/$2.rss)!$mn" \
    --field="":CB "$(sed -n 2p $DCP/$2.rss)!$mn" \
    --field="":CB "$(sed -n 3p $DCP/$2.rss)!$mn" \
    --field="":CB "$(sed -n 4p $DCP/$2.rss)!$mn" \
    --field="":CB "$(sed -n 5p $DCP/$2.rss)!$mn" \
    --field="":CB "$(sed -n 6p $DCP/$2.rss)!$mn" \
    --field="":CB "$(sed -n 7p $DCP/$2.rss)!$mn" \
    --field="":TXT "$(echo "$field" | sed -n 1p)" \
    --field="":TXT "$(echo "$field" | sed -n 2p)" \
    --field="":TXT "$(echo "$field" | sed -n 3p | sed 's/\://g')" \
    --field="":TXT "$(echo "$field" | sed -n 4p | sed 's/\://g')" \
    --field="":TXT "$(echo "$field" | sed -n 5p)" \
    --field="\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t":TXT "$(echo "$field" | sed -n 6p)" \
    --field="":TXT "$(echo "$field" | sed -n 7p)" \
    --button=gtk-apply:0 | head -n 7 > $DT/f.tmp

    [ -n "$(cat "$DT/f.tmp")" ] && mv -f $DT/f.tmp "$DCP/$2.rss" || cp -f "$DCP/$2.rss_" "$DCP/$2.rss"
    [ -f "$DCP/$2.rss_" ] && rm "$DCP/$2.rss_"
    [ -f "$DT/cpt.lock" ] && rm -f "$DT/cpt.lock" & exit
}

sync() {
   
    DCP="$DM_tl/Feeds/.conf"
    cfg="$DM_tl/Feeds/.conf/0.cfg"
    path="$(sed -n 3p < "$cfg" | grep -o 'path="[^"]*' | grep -o '[^"]*$')"
    #source "$DCP/0.cfg"
    
    if  [ -f "$DT/l_sync" ] && [ "$2" != A ]; then

        msg_2 "$(gettext "A process is already running!")\n" info "OK" "gtk-stop" "Feeds"
        e=$(echo $?)
        
            if [ $e -eq 1 ]; then

                killall rsync
                [ -n "$(ps -A | pgrep -f "rsync")" ] && killall rsync
                [ -f "$DT/cp.lock" ] && rm -f "$DT/cp.lock"
                rm -f "$DT/l_sync"
                killall tls.sh
                exit 1
            fi
            
    elif  [ -f "$DT/l_sync" ] && [ "$2" = A ]; then
    
        exit 1

    elif [ ! -d "$path" ] && [ "$2" != A ]; then
        
        msg " $(gettext "The directory to synchronization does not exist \n Exiting.")" \
        dialog-warning & exit 1
    
    elif  [ ! -d "$path" ] && [ "$2" = A ]; then
            
        echo "Synchronization error. Missing path" >> "$DM_tl/Feeds/.conf/feed.err"
        exit 1
        
    elif [ -d "$path" ]; then
        
        #set -e
        #set u pipefail
        #IFS=$'\n\t'
        [ ! -d "$path" ] && exit 1
    
        [[ $2 != A ]] && (sleep 1 && notify-send -i idiomind \
        "$(gettext "Synchronizing...")" " ")
        touch "$DT/l_sync"; SYNCDIR="$path"
        st1="$(cd "$SYNCDIR"; ls *.mp3 | wc -l)"
        rsync -az -v --exclude="*.txt" --exclude="*.png" \
        --exclude="*.html" --omit-dir-times --ignore-errors "$DM_tl/Feeds/cache/" "$SYNCDIR"
        exit=$?
        
        if [ $exit = 0 ] ; then
            st2="$(cd "$SYNCDIR"; ls *.mp3 | wc -l)"
            re=$((st2-st1))
            notify-send -i idiomind "$(gettext "Complete synchronization")" "$re $(gettext "New episodes(s)")\n$st2 $(gettext "Total")" -t 8000
        else
            notify-send -i dialog-warning \
            "$(gettext "Error while syncing")" " " -t 8000
        fi
    fi
    [ -f "$DT/l_sync" ] && rm -f "$DT/l_sync"; exit
}

case "$1" in
    play)
    play "$@" ;;
    set_channel)
    set_channel "$@" ;;
    check)
    check "$@" ;;
    sync)
    sync "$@" ;;
esac
