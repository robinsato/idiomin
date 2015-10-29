#!/bin/bash
# -*- ENCODING: UTF-8 -*-

function Dictionary() {
    cmd_play="$DS/play.sh play_list"
    cdb="$DM_tls/Dictionary/${lgtl}.db"
    table="T`date +%m%y`"
    limit=0
    list() {
        exec 3< <(sqlite3 "$cdb" "select Word FROM  ${table}" |tac)
        exec 4< <(sqlite3 "$cdb" "select ${lgsl} FROM ${table}"|tac)
        while :; do
            read word <&3
            read tran <&4
            if [ -n "$word" -a -n "$tran" ]; then
                echo "<span font_desc='Arial Bold 15'>$word</span>"
                echo "<span font_desc='Arial 15'>$tran</span>"
            fi
            [ ${limit} -gt 200 ] && break
            let limit++
        done
    }
    list | yad --list --title="$(gettext "New Words")" \
    --dclick-action="$DS/play.sh play_word" \
    --search-column=1 --hide-column=3 --regex-search \
    --column="$(gettext "$lgtl")                                                                          ":TEXT \
    --column="$(gettext "$lgsl")":TEXT \
    --name=Idiomind --class=Idiomind  \
    --center --align=right --ellipsize=END --image-on-top \
    --window-icon=idiomind --center \
    --width=620 --height=580 --borders=10 \
    --button="gtk-close":1
    
} >/dev/null 2>&1

Dictionary