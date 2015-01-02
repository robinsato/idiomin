#!/bin/bash

source /usr/share/idiomind/ifs/c.conf

if [ ! -d "$HOME/.idiomind" ]; then
	$DS/ifs/1u && exit
	if [ ! -d "$HOME/.idiomind" ]; then
		killall idiomind & exit 1
	fi
fi

if [ -z "$1" ]; then
	if [ -f $DT/.upt ]; then
		rm -f $DT/.upt
	fi
	
	# check if program is active 
	ps -A | pgrep -f "$DS/default/nw.sh"
	PS="$?"
	if (($PS!=0)); then
	
		# write in /tmp
		if [ ! -d $DT ]; then
			mkdir $DT
		fi
		if [ $? -ne 0 ]; then
			$yad --name=idiomind \
			--image=error --button=gtk-ok:1\
			--text=" <b>Error al intentar escribir en /tmp</b>\\n No se encuentra o no posee permisos de usuario " \
			--image-on-top --sticky  \
			--width=320 --height=80 \
			--borders=2 --title=Idiomind \
			--skip-taskbar --center \
			--window-icon=idiomind & exit 1
		fi
		
		#check if there directories
		if [ -f $DC_tl/.in ]; then
			if [[ "$(cat $DC_tl/.in | wc -l)" -lt 1 ]]; then
				echo "$(cat $DC_tl/.in | wc -l)"
				touch "$DT/ntpc"
			fi
		fi
		
		if echo "$(cat $DC_s/topic_m)" | grep "Actualizando..."; then
			> $DC_s/topic_m
		fi
		
		$DS/default/nw.sh & 
		
		# init count for log (weekly report stats)
		echo "strt.1.strt" >> \
		$DC/addons/stats/.log &
		
		#check session
		d1="$(date +%d)"
		d2=$(cat $DC_s/.session)
		
			if [ "$d1" != "$d2" ] || [ ! -f $DC_s/.session ]; then
				echo "$(date +%d)" > $DC_s/.session
				echo "--new session"

				# set size screen 
				xrandr | grep '*' | awk '{ print $1 }' > $DC_s/.rd
				sed -i 's/x/\n/' $DC_s/.rd
				y=$(sed -n 2p $DC_s/.rd)
				
				(
				if [ $y -gt 1200 ]; then
					#play posicion 
					echo 1000 > $DC_s/.pst
					#topic tamaño 3 - 4 
					echo 450 >> $DC_s/.rd
					echo 520 >> $DC_s/.rd
					
					#trgt tamanño 5 - 6 
					echo 480 >> $DC_s/.rd
					echo 320 >> $DC_s/.rd
					
					#edit tamaño 7 - 8
					echo 260 >> $DC_s/.rd
					echo 190 >> $DC_s/.rd
					
					#play tamaño  9 - 10 - 11
					echo 125 >> $DC_s/.rd
					echo 380 >> $DC_s/.rd
					
					#new la posicion  12 - 13
					echo 450 >> $DC_s/.rd
					echo 100 >> $DC_s/.rd
					
					#practice tamaño 14 - 15
					echo 470 >> $DC_s/.rd
					echo 300 >> $DC_s/.rd
					exit
					
				elif [ $y -ge 1080 ]; then  # 1024 -  la mia
					#play posicion 
					echo 800 > $DC_s/.pst
					#topic tamaño 3 - 4 
					echo 450 >> $DC_s/.rd #FIXED!
					echo 520 >> $DC_s/.rd
					
					#trgt tamanño 5 - 6 
					echo 480 >> $DC_s/.rd
					echo 320 >> $DC_s/.rd
					
					#edit tamaño 7 - 8
					echo 260 >> $DC_s/.rd
					echo 190 >> $DC_s/.rd
					
					#play tamaño  9 - 10 - 
					echo 100 >> $DC_s/.rd
					echo 300 >> $DC_s/.rd
					
					#new la posicion  11 - 12
					echo 450 >> $DC_s/.rd
					echo 100 >> $DC_s/.rd
					
					#practice tamaño 13 - 14
					echo 470 >> $DC_s/.rd
					echo 300 >> $DC_s/.rd
					exit
					
				elif [ $y -ge 1024 ]; then # 1024
					#play posicion  1 
					echo 800 > $DC_s/.pst
					
					#topic tamaño 3 - 4 
					echo 430 >> $DC_s/.rd
					echo 490 >> $DC_s/.rd
					
					#trgt tamanño 5 - 6 
					echo 470 >> $DC_s/.rd
					echo 320 >> $DC_s/.rd
					
					#edit tamaño 7 - 8 
					echo 260 >> $DC_s/.rd
					echo 190 >> $DC_s/.rd
					
					#play tamaño  6 - 10 - 11
					echo 100 >> $DC_s/.rd
					echo 320 >> $DC_s/.rd
					
					#new la posicion  12 - 13
					echo 450 >> $DC_s/.rd
					echo 100 >> $DC_s/.rd
					
					#practice tamaño 14 - 15
					echo 470 >> $DC_s/.rd
					echo 300 >> $DC_s/.rd
					exit
					
				elif [ $y -gt 700 ]; then # 720 el del negocio
					#play posicion  1
					echo 520 > $DC_s/.pst
					
					#topic tamaño 2 -3
					echo 420 >> $DC_s/.rd
					echo 480 >> $DC_s/.rd
					
					#trgt tamaño 4 - 5 
					echo 460 >> $DC_s/.rd
					echo 320 >> $DC_s/.rd
					
					#edit tamaño  6 - 7 
					echo 230 >> $DC_s/.rd
					echo 170 >> $DC_s/.rd
					
					#play tamaño  8 - 9 
					echo 100 >> $DC_s/.rd
					echo 300 >> $DC_s/.rd
					
					#new posicion  10 - 11
					echo 200 >> $DC_s/.rd
					echo 50 >> $DC_s/.rd
					
					#practice tamaño  12 - 13
					echo 460 >> $DC_s/.rd
					echo 250 >> $DC_s/.rd
					exit
					
				elif [ $y -gt 599 ]; then # 600 · 	la de mama
					#play position 
					echo 520 > $DC_s/.pst
					
					#topic tamaño 
					echo 400 >> $DC_s/.rd
					echo 460 >> $DC_s/.rd
					
					#trgt tamaño 
					echo 450 >> $DC_s/.rd
					echo 300 >> $DC_s/.rd
					
					#edit tamaño 6 - 7
					echo 230 >> $DC_s/.rd
					echo 170 >> $DC_s/.rd
					
					#play tamaño 
					echo 100 >> $DC_s/.rd
					echo 250 >> $DC_s/.rd
					
					#new posicion 
					echo 200 >> $DC_s/.rd
					echo 50 >> $DC_s/.rd
					
					#practice tamaño 
					echo 460 >> $DC_s/.rd
					echo 250 >> $DC_s/.rd
					exit
					
				elif [ $y -gt 400 ]; then # 400   FALTAAAAA
					# play position 
					echo 420 > $DC_s/.pst
					#topic tamaño 
					echo 400 >> $DC_s/.rd
					echo 460 >> $DC_s/.rd
					#trgt tamaño 
					echo 400 >> $DC_s/.rd
					echo 280 >> $DC_s/.rd
					#edit tamaño 
					echo 500 >> $DC_s/.rd
					echo 320 >> $DC_s/.rd
					#play tamañño 
					echo 500 >> $DC_s/.rd
					echo 320 >> $DC_s/.rd
					#new posicion 
					echo 50 >> $DC_s/.rd
					echo 200 >> $DC_s/.rd
					#practice tamaño 
					echo 250 >> $DC_s/.rd
					echo 420 >> $DC_s/.rd
					exit
				fi
				)
				
				# set weekly report
				if ([ "$(date +%u)" = 7 ] && \
				[ "$(sed -n 1p $DC/addons/stats/cnf)" = "TRUE" ]); then
					$DS/addons/Stats/rprt A &
				fi
				
				# set feed update at starting
				if [ "$(sed -n 1p "$DC/addons/Learning with news/.cnf")" = "TRUE" ]; then
					(sleep 200
					$DS/addons/Learning_with_news/strt A
					) &
				fi
				
				# set baskup
				if ([ "$(date +%u)" = 6 ] && \
				[ "$(sed -n 1p $DC_s/SC)" = "TRUE" ]); then
					$DS/ifs/t_bd.sh C &
				fi
				
				#search updates
				/usr/share/idiomind/ifs/tls.sh srch &
				
				# update topics status
				n=1
				while [ $n -le "$(cat "$DC_tl/.in" | head -30 | wc -l )" ]; do
					tp=$(sed -n "$n"p "$DC_tl/.in")
					
					if [ -f "$DC_tl/$tp/.trw" ]; then
						dte=$(cat "$DC_tl/$tp/.trw")
						dts=$(cat "$DC_tl/$tp/.trw" | wc -l)
						if [ $dts = 1 ]; then
							dte=$(sed -n 1p "$DC_tl/$tp/.trw")
							TM=$(echo $(( ( $(date +%s) - $(date -d "$dte" +%s) ) /(24 * 60 * 60 ) )))
							RM=$((100*$TM/10))
						elif [ $dts = 2 ]; then
							dte=$(sed -n 2p "$DC_tl/$tp/.trw")
							TM=$(echo $(( ( $(date +%s) - $(date -d "$dte" +%s) ) /(24 * 60 * 60 ) )))
							RM=$((100*$TM/25))
						elif [ $dts = 3 ]; then
							dte=$(sed -n 3p "$DC_tl/$tp/.trw")
							TM=$(echo $(( ( $(date +%s) - $(date -d "$dte" +%s) ) /(24 * 60 * 60 ) )))
							RM=$((100*$TM/60))
						elif [ $dts = 4 ]; then
							dte=$(sed -n 4p "$DC_tl/$tp/.trw")
							TM=$(echo $(( ( $(date +%s) - $(date -d "$dte" +%s) ) /(24 * 60 * 60 ) )))
							RM=$((100*$TM/150))
						fi
						nstll=$(grep -Fxo "$tp" "$DC_tl/.nstll")
							if [ -n "$nstll" ]; then
								if [ "$RM" -ge 100 ]; then
									echo "9" > "$DC_tl/$tp/.stts"
								fi
								if [ "$RM" -ge 200 ]; then
									echo "10" > "$DC_tl/$tp/.stts"
								fi
							else
								if [ "$RM" -ge 100 ]; then
									echo "4" > "$DC_tl/$tp/.stts"
								fi
								if [ "$RM" -ge 200 ]; then
									echo "5" > "$DC_tl/$tp/.stts"
								fi
							fi
					fi
					let n++
				done
				$DS/mngr.sh mkmn & exit 1
		else
			echo "$(date +%d)" > $DC_s/.session & exit 1
		fi
		
	else
		idiomind topic
	fi
fi

if [[ $(echo "$1" | grep -o '.idmnd') = '.idmnd' ]]; then
	wth=$(sed -n 4p $DC_s/.rd)
	eht=$(sed -n 3p $DC_s/.rd)
	dte=$(date "+%d %B")
	c=$(echo $(($RANDOM%1000)))
	if [ ! -d $DT ]; then
		mkdir $DT
	fi
	mkdir $DT/idmimp_$c
	(cp -f $DS/default/p1.sh $DT/p1.$c
	cp -f $DS/default/p2.sh $DT/p2.$c
	sed -i 's/X015x/'$c'/g' $DT/*.$c) &
	cp "$1" $DT/import.tem
	cd $DT
	mv ./import.tem ./import.tar.gz
	cd ./idmimp_$c
	tar -xzvf ../import.tar.gz
	ls -t -d -N * > $DT/idmimp_$c/ls
	inme=$(sed -n 1p $DT/idmimp_$c/ls)
	tmp="$DT/idmimp_$c/$inme"
	lgtli=$(sed -n 2p "$tmp/.AL")
	lng=$(sed -n 3p "$tmp/.AL")
	lgsli=$(sed -n 4p "$tmp/.AL")
	cc=$(sed -n 1p "$tmp/.AL")
	cgy=$(sed -n 9p "$tmp/.AL")
	nt=$(sed -n 11p "$tmp/.AL")
	ICON=$DS/images/idm2.png
	
	if [ "$inme" != "$cc" ]; then
		cstn=$($yad --name=idiomind \
		--image=error --button=gtk-ok:1\
		--text=" <b>File bad</b>\\n" \
		--image-on-top  --sticky \
		--width=230 --height=80 \
		--borders=3 --title=Idiomind \
		--skip-taskbar --center \
		--window-icon=idiomind)
		rm -fr $DT/idmimp_$c $DT/*.$c \
		$DT/import.tar.gz
	else
		if [ $(echo "$inme" | wc -c) -gt 40 ]; then
			title="${inme:0:40}..."
		else
			title="$inme"
	    fi
		cd "$tmp"
		ws=$(cat ".winx" | wc -l)
		ss=$(cat ".sinx" | wc -l)
		itxt="<big> <b>$title</b></big><small><small><b>\\n   $lgsli  -  $lgtli \\n   Categoty:  $cgy.\\n   $ss  Sentences  -  $ws  Words</b></small></small>\\n"
		dlck="$DT/p1.$c"
		
		cat "$tmp/.t-inx" | awk '{print $0""}' | \
		$yad --list --name=Idiomind --title="Idiomind" \
		--ellipsize=END --print-all --image-on-top \
		--text="$itxt" --class=Idiomind  \
		--width="$wth" --height="$eht" --image-on-top \
		--window-icon=idiomind --column=Items --center \
		--dclick-action="$dlck" --image="$ICON" \
		--button="  Install  ":0 --button=Close:1
			ret=$?
			
			if [ "$ret" -eq 1 ]; then
				rm -f -r "$DT/idmimp_$c" $DT/*.$c \
				$DT/import.tar.gz & exit 1
			elif [ "$ret" -eq 0 ]; then
				if2=$(cat $DC/topics/$lgtli/.in | wc -l)
				snm=$(cat $DC/topics/$lgtli/.in | grep -Fo "$inme" | wc -l)
				
				if [ $if2 -ge 50 ]; then
					$yad  --name=idiomind --center \
					--image=info --class=idiomind \
					--text=" <b>Hás alcanzado la cantidad máxima de temas  </b>\\n Tienes la posibilidad de guardarlos en la web\\n o solo borrar algunos" \
					--image-on-top --sticky --skip-taskbar \
					--width=230 --height=80 \
					--borders=3 --title=Idiomind \
					--window-icon=idiomind \
					--button=gtk-ok:1
					rm -r -f $DT/idmimp_$c $DT/*.$c \
					$DT/import.tar.gz & exit 1
				fi
		
				if [ "$snm" -ge 1 ]; then
					inm="$inme $snm"
					$yad  --name=idiomind \
					--image=info --sticky \
					--text=" <b>Hay instalado un tema con el mismo nombre   </b>\\n Se renombrara a:  <b>$inm</b>   \\n" \
					--class=idiomind --center --skip-taskbar \
					--image-on-top --width=240 \
					--height=80 --borders=3 \
					--window-icon=idiomind \
					--title=Idiomind --button=Cancel:1 \
					--button=gtk-ok:0
						ret=$?
					if [ $ret != 0 ]; then
						rm -fr $DT/idmimp_$c $DT/*.$c \
						$DT/import.tar.gz & exit 1
					fi
				else
					inm="$inme"
				fi
				#installing

				if [ ! -d "$DM_t/$lgtli" ]; then
					mkdir "$DM_t/$lgtli"
					mkdir "$DM_t/$lgtli/.share"
					mkdir "$DC/topics/$lgtli"
					mkdir "$DC_a/Learning with news/$lgtli"
					mkdir "$DC_a/Learning with news/$lgtli/subscripts"
					"$DS/addons/Learning_with_news/examples/$lgtli"
					cp -f "$DS/addons/Learning_with_news/examples/$lgtli" \
					"$DC_a/Learning with news/$lgtli/subscripts/Example"
				fi
				mkdir "$DM/topics/$lgtli/$inm"
				mkdir "$DC/topics/$lgtli/$inm"
				drit="$DM/topics/$lgtli/$inm"
				dric="$DC/topics/$lgtli/$inm"
				mkdir "$dric/Practice"
				cp -f $DS/addons/Practice/default/.* \
				"$dric/Practice"
				cd "$tmp"
				cp -n ./.audio/*.mp3 "$DM_t/$lgtli/.share/"
				rm -fr./.audio
				cp -f -r .* "$drit/"
				cp -f .AL "$dric/.AL"
				echo "6" > "$dric/.stts"
				cp -f .t-inx "$dric/.t-inx"
				cp -f .t-inx "$dric/.tlng-inx"
				cp -f .winx "$dric/.winx"
				cp -f .sinx "$dric/.sinx"
				cp -f .ainx "$dric/.ainx"
				echo "$nt" > "$dric/nt"
				rm -r -f $DT/idmimp_$c $DT/*.$c
				cp -f $DS/default/tpc.sh "$dric/tpc.sh"
				chmod +x "$dric/tpc.sh"
				echo "$lng" > $DC_s/lang
				echo "$lgtli" >> $DC_s/lang
				cd "$dric"
				echo $dte > .impt
				echo "$inm" >> "$DC/topics/$lgtli/.nstll"
				sed -i 's/'"$inm"'//g' "$DC/topics/$lgtli/.in_s"
				sed '/^$/d' $DC/topics/$lgtli/.in_s > $DC/topics/$lgtli/.in_s.tmp
				mv -f $DC/topics/$lgtli/.in_s.tmp $DC/topics/$lgtli/.in_s
				cp -f $DS/$DS/images/flags/$lng.png $DT/tryidmd$DS/images
				chmod 777 $DT/tryidmd$DS/images
				$DS/mngr.sh mkmn &&
				"$dric/tpc.sh" &
				rm -r -f $DT/idmimp_$c $DT/*.$c \
				$DT/import.tar.gz & exit 1
			
			else
				rm -r -f $DT/idmimp_$c $DT/*.$c \
				$DT/import.tar.gz
			fi
		fi
	exit 1
fi

#--------------topic
if [ "$1" = topic ]; then
	eht=$(sed -n 3p $DC_s/.rd)
	wth=$(sed -n 4p $DC_s/.rd)
	mde=$(sed -n 2p $DC_s/topic.id)
	info=$(cat $DS/ifs/info1)
	STT=$(cat $DC_s/topic_m)
	title=$(sed -n 3p $DC_s/topic.id)
	ls0="$DC_tlt/.t-inx"
	ls1="$DC_tlt/.tlng-inx"
	ls2="$DC_tlt/.tok-inx"
	nt="$DC_tlt/nt"
	
	if [ $(echo "$tpc" | wc -c) -gt 50 ]; then
		ttl="${tpc:0:50}..."
	else
		ttl="$tpc"
	fi
	
	if [ -f $DT/l_.x ]; then
		exit 1
	fi
	> $DT/l_.x
	
	echo "tpcs.$tpc.tpcs" >> \
	$DC/addons/stats/.log &
	inx=$(cat "$ls0" | wc -l)
	tb1=$(cat "$ls1" | wc -l)
	tb2=$(cat "$ls2" | wc -l)

	#--------------topic own
	if echo "$mde" | grep "wn"; then
		ICON=$DS/images/wn.png
		cd "$DC_tlt"
		ws=$(cat .winx | wc -l)
		ss=$(cat .sinx | wc -l)
		itxt="\\n<big>  <b>$ttl</b> </big> <small><small><b>\\n    $ss Sentences     $ws Words</b></small></small>\\n"
		cd $DS
		c=$(echo $(($RANDOM%100000)))
		KEY=$c
		cnf1=$(mktemp $DT/cnf1.XXXX.x)
		cnf2=$(mktemp $DT/cnf2.XXXX.x)
		cnf3=$(mktemp $DT/cnf3.XXXX.x)
		
		# 1er vista - si el topic esta vacio 
		if [ "$inx" -lt 1 ]; then
			
			$yad --text-info --plug=$KEY --margins=14 \
			--wrap --editable --text="$itxt" \
			--tabnum=1 --fore=gray40 \
			--show-uri --fontname=vendana --print-column=1 \
			--column="" --filename="$nt" > "$cnf3" &
			$yad --notebook --name=idiomind --center \
			--class=idiomind --align=right --key=$KEY  \
			--tab-borders=0 --center --title="$tpc" \
			--tab="  Notes  " --window-icon=idiomind \
			--buttons-layout=edge --image-on-top --class=idiomind \
			--width="$wth" --height="$eht" --borders=0  \
			--button=Delete:"$DS/mngr.sh dlt" \
			--button=Close:2 --always-print-result
			ret=$?
					
				if [ $ret -eq 2 ]; then
					
					if [ -f "$cnf3" ]; then
						if [ "$cnf3" != "$nt" ]; then
							cat "$cnf3" > "$nt"
						fi
					fi
					rm -f "$cnf3" &
					
				else
					if [ -f "$cnf3" ]; then
						if [ "$cnf3" != "$nt" ]; then
							cat "$cnf3" > "$nt"
						fi
					fi
					rm -f $DT/*.x
				fi	
			
		# 2er vista - si el topic tiene contenido para aprender
		elif [ "$tb1" -ge 1 ]; then
			if [ -f "$DC_tlt/.trw" ] && [ -f "$DC_tlt/.lk" ]; then
				dts=$(cat "$DC_tlt/.trw" | wc -l)
				if [ $dts = 1 ]; then
					dte=$(sed -n 1p "$DC_tlt/.trw")
					adv="<b> Hace 15 dias que aprendiste este topic\\n Deseas reiniciarlo para repasar?</b>"
					TM=$(echo $(( ( $(date +%s) - $(date -d "$dte" +%s) ) /(24 * 60 * 60 ) )))
					RM=$((100*$TM/10))
				elif [ $dts = 2 ]; then
					dte=$(sed -n 2p "$DC_tlt/.trw")
					adv="<b> Hace 15 dias que aprendiste este topic\\n Deseas reiniciarlo para repasar?</b>"
					TM=$(echo $(( ( $(date +%s) - $(date -d "$dte" +%s) ) /(24 * 60 * 60 ) )))
					RM=$((100*$TM/25))
				elif [ $dts = 3 ]; then
					dte=$(sed -n 3p "$DC_tlt/.trw")
					adv="<b> Hace 15 dias que aprendiste este topic\\n Deseas reiniciarlo para repasar?</b>"
					TM=$(echo $(( ( $(date +%s) - $(date -d "$dte" +%s) ) /(24 * 60 * 60 ) )))
					RM=$((100*$TM/60))
				elif [ $dts = 4 ]; then
					dte=$(sed -n 4p "$DC_tlt/.trw")
					adv="<b> Hace 15 dias que aprendiste este topic\\n Deseas reiniciarlo para repasar?</b>"
					TM=$(echo $(( ( $(date +%s) - $(date -d "$dte" +%s) ) /(24 * 60 * 60 ) )))
					RM=$((100*$TM/150))
				fi
				# si el topic aprendido tiene mas de 30 dias ( 100%) entonces pone su nombre en la lista de repasar borra de la lista "ok" , actualiza la lista de topic (mngr.sh mkmn ) y muestra el cuadro con la pregunta de reiniciar para repasar o no .
				if [ "$RM" -ge 100 ]; then
					echo "4" > "$DC_tlt/.stts"
					$DS/mngr.sh mkmn &
					RM=100
					$yad --title="$tpc" --window-icon=idiomind \
					--borders=20 --buttons-layout=edge --name=idiomind \
					--image=$DS/$DS/images/qstn.png \
					--on-top --window-icon=idiomind \
					--buttons-layout=edge --center --class=idiomind \
					--button="       No       ":1 \
					--button="        Review        ":2 \
					--text="$adv" \
					--width=408 --height=80
					ret=$? # si se elige reiniciar entonces quita el nomre del topic de la lista " .ok" y la agrega a la lista ".ok_R" (lista repasando) copia la lista "$lso" ( indice total del topic) a la lista "$ls1" ( lista aprendiendo) por ultimo abre el topic
						if [ "$ret" -eq 2 ]; then
							rm -f $DT/*.x
							echo "3" > "$DC_tlt/.stts"
							$DS/mngr.sh mkmn
							rm -f "$ls2" 
							rm -f "$DC_tlt/.lk"
							cp -f "$ls0" "$ls1" && idiomind topic & exit 1
						fi 
				fi
				
				$yad --align=center --borders=80 \
				--text="<u><b>Learned</b></u>   * Sin embargo hay $tb1 items nuevos.\\nTime for Review:" \
				--bar="":NORM $RM \
				--multi-progress --plug=$KEY --tabnum=1 &
				cat "$ls2" | awk '{print $0"\n"}' | $yad \
				--no-headers --list --plug=$KEY --tabnum=2 \
				--expand-column=1 --ellipsize=END --print-all \
				--column=Name:TEXT --column=Review:CHK \
				--dclick-action='./vwr.sh v2' > "$cnf2" &
				$yad --text-info --plug=$KEY --margins=14 \
				--wrap --editable --text="$itxt" \
				--tabnum=3 --fore='gray40' \
				--show-uri --fontname=vendana --print-column=1 \
				--column="" --filename="$nt" > "$cnf3" &
				$yad --notebook --name=Idiomind --center \
				--class=Idiomind --align=right --key=$KEY \
				--tab-borders=0 --center --title="$tpc" \
				--tab=" Review " --window-icon=idiomind \
				--tab=" Learned ($tb2) " --tab=" Notes " \
				--ellipsize=END --image-on-top  \
				--width="$wth" --height="$eht" \
				--borders=0 --always-print-result \
				--button=Review:4 --button=Edit:3 --button=Close:2
			else
				cat "$ls1" | awk '{print $0"\n"}' | $yad \
				--no-headers --list --plug=$KEY --tabnum=1 \
				--dclick-action='./vwr.sh v1'\
				--expand-column=1 --ellipsize=END --print-all \
				--column=Name:TEXT --column=Learned:CHK > "$cnf1" &
				cat "$ls2" | awk '{print $0"\n"}' | $yad \
				--no-headers --list --plug=$KEY --tabnum=2 \
				--expand-column=1 --ellipsize=END --print-all \
				--column=Name:TEXT --column=Review:CHK \
				--dclick-action='./vwr.sh v2' > "$cnf2" &
				$yad --text-info --plug=$KEY --margins=14 \
				--text="$itxt" \
				--tabnum=3 --fore='gray40' --wrap --editable \
				--show-uri --fontname=vendana --print-column=1 \
				--column="" --filename="$nt" > "$cnf3" &
				$yad --notebook --name=Idiomind --center --key=$KEY \
				--class=Idiomind --align=right --window-icon=idiomind \
				--tab-borders=0 --center --title="$tpc" \
				--tab=" Learning ($tb1) " \
				--tab=" Learned ($tb2) " --tab=" Notes " \
				--ellipsize=END --image-on-top \
				--width="$wth" --height="$eht" --borders=0 \
				--button=Play:./play.sh --button=Practice:5 \
				--button=Edit:3 --button=Close:2 --always-print-result
			fi
				ret=$?
				
				if [ $ret -eq 3 ]; then
					./default/pnls.sh edt &
					
				elif [ $ret -eq 5 ]; then
					rm -f $DT/*.x
					$DS/addons/Practice/strt & killall topic.sh &
					
				elif [ $ret -eq 4 ]; then
					$yad --title="$tpc" --window-icon=idiomind \
					--borders=5 --name=idiomind \
					--image=dialog-question \
					--on-top --window-icon=idiomind \
					--center --class=idiomind \
					--button="News":3 \
					--button="All":2 \
					--text=" Repasar Todo o Solo los Nuevos" \
					--width=360 --height=120
						ret=$? 
						if [ "$ret" -eq 2 ]; then
							rm -f "$DC_tlt/.lk"
							rm -f $DT/*.x
							echo "4" > "$DC_tlt/.stts"
							$DS/mngr.sh mkmn
							rm -f "$ls2"
							cp -f "$ls0" "$ls1" && idiomind topic & exit 1
							
						elif [ "$ret" -eq 3 ]; then
							rm -f $DT/*.x
							echo "3" > "$DC_tlt/.stts"
							rm -f "$DC_tlt/.lk" && idiomind topic & exit 1
						fi
					
				elif [ $ret -eq 2 ]; then
					if [ -f "$cnf3" ]; then
						if [ "$cnf3" != "$nt" ]; then
							cat "$cnf3" > "$nt"
						fi
					fi
					if [ -n "$(cat "$cnf1" | grep -o TRUE)" ]; then
						grep -Rl "|FALSE|" "$cnf1" | while read tab1 ; do
							 sed '/|FALSE|/d' "$cnf1" > tmpf1
							 mv tmpf1 $tab1
						done
						sed -i 's/|TRUE|//g' "$cnf1"
						cat "$cnf1" >> "$ls2"
						cnt=$(cat "$cnf1" | wc -l)
						grep -F -x -v -f "$cnf1" "$ls1" > $DT/ls1.x
						mv -f $DT/ls1.x "$ls1"
						# se ocupa de sacar lineas repetidas del indice 
						if [ -n "$(cat "$ls1" | sort -n | uniq -dc)" ]; then
							cat "$ls1" | awk '!array_temp[$0]++' > $DT/ls1.x
							sed '/^$/d' $DT/ls1.x > "$ls1"
						fi
						echo "okim.$cnt.okim" >> \
						$DC/addons/stats/.log &	
					fi
					if [ -n "$(cat "$cnf2" | grep -o TRUE)" ]; then
						grep -Rl "|FALSE|" "$cnf2" | while read tab2 ; do
							 sed '/|FALSE|/d' "$cnf2" > tmpf2
							 mv tmpf2 $tab2
						done
						sed -i 's/|TRUE|//g' "$cnf2"
						cat "$cnf2" >> "$ls1"
						cnt=$(cat "$cnf2" | wc -l)
						grep -F -x -v -f "$cnf2" "$ls2" > $DT/ls2.x
						mv -f $DT/ls2.x "$ls2"
						# se ocupa de sacar lineas repetidas del indice 
						if [ -n "$(cat "$ls2" | sort -n | uniq -dc)" ]; then
							cat "$ls2" | awk '!array_temp[$0]++' > $DT/ls2.x
							sed '/^$/d' $DT/ls2.x > "$ls2"
						fi
						echo "reim.$cnt.reim" >> \
						$DC/addons/stats/.log &
					fi
				else
					if [ -f "$cnf3" ]; then
						if [ "$cnf3" != "$nt" ]; then
							cat "$cnf3" > "$nt"
						fi
					fi
					rm -f $DT/*.x
				fi
			
		# 3er vista - si el topic esta aprendido 
		elif [ "$tb1" -eq 0 ]; then
			# actualiza la lista de topic para que se actualizen los $DS/imagesos 
			if [ ! -f "$DC_tlt/.lk" ]; then
				> "$DC_tlt/.lk"
				echo "$(date +%m/%d/%Y)" > "$DC_tlt/.trw"
				echo "7" > "$DC_tlt/.stts"
				$DS/mngr.sh mkmn &
			fi
			
			dts=$(cat "$DC_tlt/.trw" | wc -l)
			if [ $dts = 1 ]; then
				dte=$(sed -n 1p "$DC_tlt/.trw")
				adv="<b> Hace 15 dias que aprendiste este topic\\n Deseas reiniciarlo para repasar?</b>"
				TM=$(echo $(( ( $(date +%s) - $(date -d "$dte" +%s) ) /(24 * 60 * 60 ) )))
				RM=$((100*$TM/10))
			elif [ $dts = 2 ]; then
				dte=$(sed -n 2p "$DC_tlt/.trw")
				adv="<b> Hace 15 dias que aprendiste este topic\\n Deseas reiniciarlo para repasar?</b>"
				TM=$(echo $(( ( $(date +%s) - $(date -d "$dte" +%s) ) /(24 * 60 * 60 ) )))
				RM=$((100*$TM/25))
			elif [ $dts = 3 ]; then
				dte=$(sed -n 3p "$DC_tlt/.trw")
				adv="<b> Hace 15 dias que aprendiste este topic\\n Deseas reiniciarlo para repasar?</b>"
				TM=$(echo $(( ( $(date +%s) - $(date -d "$dte" +%s) ) /(24 * 60 * 60 ) )))
				RM=$((100*$TM/60))
			elif [ $dts = 4 ]; then
				dte=$(sed -n 4p "$DC_tlt/.trw")
				adv="<b> Hace 15 dias que aprendiste este topic\\n Deseas reiniciarlo para repasar?</b>"
				TM=$(echo $(( ( $(date +%s) - $(date -d "$dte" +%s) ) /(24 * 60 * 60 ) )))
				RM=$((100*$TM/150))
			fi
				
			if [ "$RM" -ge 100 ]; then
				echo "4" > "$DC_tlt/.stts"
				$DS/mngr.sh mkmn &
				RM=100
				$yad --title="$tpc" --window-icon=idiomind \
				--borders=20 --buttons-layout=edge --name=idiomind \
				--image=$DS/$DS/images/qstn.png \
				--on-top --window-icon=idiomind \
				--buttons-layout=edge --center --class=idiomind \
				--button="       No       ":1 \
				--button="        Review        ":2 \
				--text="$adv" \
				--width=408 --height=80
				ret=$? # si se elige reiniciar entonces quita el nomre del topic de la lista " .ok" y la agrega a la lista ".ok_R" (lista repasando) copia la lista "$lso" ( indice total del topic) a la lista "$ls1" ( lista aprendiendo) por ultimo abre el topic
					if [ "$ret" -eq 2 ]; then
						rm -f "$DC_tlt/.lk"
						rm -f $DT/*.x
						echo "3" > "$DC_tlt/.stts"
						$DS/mngr.sh mkmn
						rm -f "$ls2" 
						cp -f "$ls0" "$ls1" && idiomind topic & exit 1
					fi 
			fi

			$yad --align=center --borders=80 \
			--text="<u><b>Learned</b></u>\\nTime for Review:" \
			--bar="":NORM $RM \
			--multi-progress --plug=$KEY --tabnum=1 &
			cat "$ls2" | awk '{print $0"\n"}' | $yad \
			--no-headers --list --plug=$KEY --tabnum=2 \
			--expand-column=1 --ellipsize=END --print-all \
			--column=Name:TEXT --column=Review:CHK \
			--dclick-action='./vwr.sh v2' > "$cnf2" &
			$yad --text-info --plug=$KEY --margins=14 \
			--wrap --editable --text="$itxt" \
			--tabnum=3 --fore='gray40' \
			--show-uri --fontname=vendana --print-column=1 \
			--column="" --filename="$nt" > "$cnf3" &
			$yad --notebook --name=Idiomind --center \
			--class=Idiomind --align=right --key=$KEY \
			--tab-borders=0 --center --title="$tpc" \
			--tab=" Review " --window-icon=idiomind \
			--tab=" Learned ($tb2) " --tab=" Notes " \
			--ellipsize=END --image-on-top  \
			--width="$wth" --height="$eht" --borders=0 \
			--button=Edit:3 --button=Close:2 --always-print-result
				ret=$?
				
				if [ $ret -eq 3 ]; then
					./default/pnls.sh edt &
					
				elif [ $ret -eq 5 ]; then
					$DS/addons/Practice/strt & killall topic.sh &
				
				elif [ $ret -eq 2 ]; then
					if [ -f "$cnf3" ]; then
						if [ "$cnf3" != "$nt" ]; then
							cat "$cnf3" > "$nt"
						fi
					fi
					if [ -n "$(cat "$cnf1" | grep -o TRUE)" ]; then
						grep -Rl "|FALSE|" "$cnf1" | while read tab1 ; do
							 sed '/|FALSE|/d' "$cnf1" > tmpf1
							 mv tmpf1 $tab1
						done
						sed -i 's/|TRUE|//g' "$cnf1"
						cat "$cnf1" >> "$ls2"
						cnt=$(cat "$cnf1" | wc -l)
						grep -F -x -v -f "$cnf1" "$ls1" > $DT/ls1.x
						mv -f $DT/ls1.x "$ls1"
						if [ -n "$(cat "$ls1" | sort -n | uniq -dc)" ]; then
							cat "$ls1" | awk '!array_temp[$0]++' > $DT/ls1.x
							sed '/^$/d' $DT/ls1.x > "$ls1" # se ocupa de sacar lineas repetidas del indice 
						fi
						echo "okim.$cnt.okim" >> \
						$DC/addons/stats/.log &
					fi
					if [ -n "$(cat "$cnf2" | grep -o TRUE)" ]; then
						grep -Rl "|FALSE|" "$cnf2" | while read tab2 ; do
							 sed '/|FALSE|/d' "$cnf2" > tmpf2
							 mv tmpf2 $tab2
						done
						sed -i 's/|TRUE|//g' "$cnf2"
						cat "$cnf2" >> "$ls1"
						cnt=$(cat "$cnf2" | wc -l)
						grep -F -x -v -f "$cnf2" "$ls2" > $DT/ls2.x
						mv -f $DT/ls2.x "$ls2"
						if [ -n "$(cat "$ls2" | sort -n | uniq -dc)" ]; then
							cat "$ls2" | awk '!array_temp[$0]++' > $DT/ls2.x
							sed '/^$/d' $DT/ls2.x > "$ls2" # se ocupa de sacar lineas repetidas del indice pricipal del topic
						fi
						echo "reim.$cnt.reim" >> \
						$DC/addons/stats/.log &
					fi
				else
					if [ -f "$cnf3" ]; then
						if [ "$cnf3" != "$nt" ]; then
							cat "$cnf3" > "$nt"
						fi
					fi
					rm -f $DT/*.x
				fi
				rm -f $DT/*.x
			fi
		
	##--------------topic nstll
	elif echo "$mde" | grep "istll"; then
		l1=$(sed -n 6p "$DC_tlt/.AL")
		l2=$(sed -n 7p "$DC_tlt/.AL")
		l3=$(sed -n 8p "$DC_tlt/.AL")
		l4=$(sed -n 9p "$DC_tlt/.AL")
		ICON=$DS/images/wn.png
		cd "$DC_tlt"
		ws=$(cat .winx | wc -l)
		ss=$(cat .sinx | wc -l)
		itxt="\\n<big>  <b>$ttl</b></big><small><small><b>\\n    $ss Sentences   $ws Words\\n    Category: $l4\\n    created by: $l1</b></small></small>\\n"
		cd $DS
		c=$(echo $(($RANDOM%100000)))
		KEY=$c
		cnf1=$(mktemp $DT/cnf1.XXXX.x)
		cnf2=$(mktemp $DT/cnf2.XXXX.x)
		cnf3=$(mktemp $DT/cnf3.XXXX.x)
		
		# 1er vista - topic con contenido para aprender
		if [ "$tb1" -ge 1 ]; then
		
			if [ -f "$DC_tlt/.trw" ] && [ -f "$DC_tlt/.lk" ]; then
				dts=$(cat "$DC_tlt/.trw" | wc -l)
				if [ $dts = 1 ]; then
					dte=$(sed -n 1p "$DC_tlt/.trw")
					adv="<b> Hace 15 dias que aprendiste este topic\\n Deseas reiniciarlo para repasar?</b>"
					TM=$(echo $(( ( $(date +%s) - $(date -d "$dte" +%s) ) /(24 * 60 * 60 ) )))
					RM=$((100*$TM/10))
				elif [ $dts = 2 ]; then
					dte=$(sed -n 2p "$DC_tlt/.trw")
					adv="<b> Hace 15 dias que aprendiste este topic\\n Deseas reiniciarlo para repasar?</b>"
					TM=$(echo $(( ( $(date +%s) - $(date -d "$dte" +%s) ) /(24 * 60 * 60 ) )))
					RM=$((100*$TM/25))
				elif [ $dts = 3 ]; then
					dte=$(sed -n 3p "$DC_tlt/.trw")
					adv="<b> Hace 15 dias que aprendiste este topic\\n Deseas reiniciarlo para repasar?</b>"
					TM=$(echo $(( ( $(date +%s) - $(date -d "$dte" +%s) ) /(24 * 60 * 60 ) )))
					RM=$((100*$TM/60))
				elif [ $dts = 4 ]; then
					dte=$(sed -n 4p "$DC_tlt/.trw")
					adv="<b> Hace 15 dias que aprendiste este topic\\n Deseas reiniciarlo para repasar?</b>"
					TM=$(echo $(( ( $(date +%s) - $(date -d "$dte" +%s) ) /(24 * 60 * 60 ) )))
					RM=$((100*$TM/150))
				fi
			 # si el topic aprendido tiene mas de 30 dias ( 100%) entonces pone su nombre en la lista de repasar borra de la lista "ok" , actualiza la lista de topic (mngr.sh mkmn ) y muestra el cuadro con la pregunta de reiniciar para repasar o no .
				if [ "$RM" -ge 100 ]; then
					echo "4" > "$DC_tlt/.stts"
					$DS/mngr.sh mkmn &
					RM=100
					$yad --title="$tpc" --window-icon=idiomind \
					--borders=20 --buttons-layout=edge --name=idiomind \
					--image=$DS/$DS/images/qstn.png \
					--on-top --window-icon=idiomind \
					--buttons-layout=edge --center --class=idiomind \
					--button="       No       ":1 \
					--button="        Review        ":2 \
					--text="$adv" \
					--width=408 --height=80
					ret=$? # si se elige reiniciar entonces quita el nomre del topic de la lista " .ok" y la agrega a la lista ".ok_R" (lista repasando) copia la lista "$lso" ( indice total del topic) a la lista "$ls1" ( lista aprendiendo) por ultimo abre el topic
						if [ "$ret" -eq 2 ]; then
							rm -f "$DC_tlt/.lk"
							rm -f $DT/*.x
							echo "3" > "$DC_tlt/.stts"
							$DS/mngr.sh mkmn
							rm -f "$ls2"
							cp -f "$ls0" "$ls1" && idiomind topic & exit 1
						fi 
					fi

				$yad --align=center --borders=80 \
				--text="<u><b>Learned</b></u>\\n   * Sin embargo hay $tb1 items nuevos.\\nTime for Review:" \
				--bar="":NORM $RM \
				--multi-progress --plug=$KEY --tabnum=1 &
				cat "$ls2" | awk '{print $0"\n"}' | $yad \
				--no-headers --list --plug=$KEY --tabnum=2 \
				--expand-column=1 --ellipsize=END --print-all \
				--column=Name:TEXT --column=Review:CHK \
				--dclick-action='./vwr.sh v2' > "$cnf2" &
				$yad --text-info --plug=$KEY --margins=14 \
				--wrap --editable --text="$itxt" \
				--tabnum=3 --fore='gray40' \
				--show-uri --fontname=vendana --print-column=1 \
				--column="" --filename="$nt" > "$cnf3" &
				$yad --notebook --name=Idiomind --center \
				--class=Idiomind --align=right --key=$KEY \
				--tab-borders=0 --center --title="$tpc" \
				--tab=" Review " --window-icon=idiomind \
				--tab=" Learned ($tb2) " --tab=" Notes " \
				--ellipsize=END --image-on-top  \
				--width="$wth" --height="$eht" \
				--borders=0 --always-print-result \
				--button=Review:4 --button=Edit:3 --button=Close:2 
			else
				cat "$ls1" | awk '{print $0"\n"}' | $yad \
				--no-headers --list --plug=$KEY --tabnum=1 $t \
				--expand-column=1 --ellipsize=END --print-all \
				--column=Name:TEXT --column=Learned:CHK \
				--dclick-action='./vwr.sh v1' > "$cnf1" &
				cat "$ls2" | awk '{print $0"\n"}' | $yad \
				--no-headers --list --plug=$KEY --tabnum=2 \
				--expand-column=1 --ellipsize=END --print-all \
				--column=Name:TEXT --column=Review:CHK \
				--dclick-action='./vwr.sh v2' > "$cnf2" &
				$yad --text-info --plug=$KEY --margins=14 \
				--editable --wrap --text="$itxt" \
				--tabnum=3 --fore='gray40' --column="" --filename="$nt" \
				--show-uri --fontname=vendana --print-column=1 > "$cnf3" &
				$yad --notebook --name=Idiomind --center  \
				--class=Idiomind --align=right --key=$KEY \
				--tab-borders=0 --center --title="$tpc" \
				--tab=" Learning ($tb1) " \
				--tab=" Learned ($tb2) " --tab=" Notes " \
				--ellipsize=END --image-on-top --window-icon=idiomind \
				--width="$wth" --height="$eht" --borders=0 \
				--button=Play:./play.sh --button=Practice:5 \
				--button=Edit:3 --button=Close:2 --always-print-result
			fi
				ret=$?
				
				if [ $ret -eq 3 ]; then
					./default/pnls.sh edt &
				
				elif [ $ret -eq 5 ]; then
					rm -f $DT/*.x
					$DS/addons/Practice/strt & killall topic.sh &
					
				elif [ $ret -eq 4 ]; then
					$yad --title="$tpc" --window-icon=idiomind \
					--borders=20 --name=idiomind \
					--image=dialog-question \
					--on-top --window-icon=idiomind \
					--center --class=idiomind \
					--button="News":3 \
					--button="All":2 \
					--text=" Repasar Todo o Solo los Nuevos" \
					--width=360 --height=120
						ret=$? 
						if [ "$ret" -eq 2 ]; then
							rm -f "$DC_tlt/.lk"
							rm -f $DT/*.x
							echo "9" > "$DC_tlt/.stts"
							$DS/mngr.sh mkmn
							rm -f "$ls2"
							cp -f "$ls0" "$ls1" && idiomind topic & exit 1
							
						elif [ "$ret" -eq 3 ]; then
							rm -f $DT/*.x
							echo "8" > "$DC_tlt/.stts"
							rm -f "$DC_tlt/.lk" && idiomind topic & exit 1
						fi
				
				elif [ $ret -eq 2 ]; then
					if [ -f "$cnf3" ]; then
						if [ "$cnf3" != "$nt" ]; then
							cat "$cnf3" > "$nt"
						fi
					fi
					if [ -n "$(cat "$cnf1" | grep -o TRUE)" ]; then
						grep -Rl "|FALSE|" "$cnf1" | while read tab1 ; do
							 sed '/|FALSE|/d' "$cnf1" > tmpf1
							 mv tmpf1 $tab1
						done
						sed -i 's/|TRUE|//g' "$cnf1"
						cat "$cnf1" >> "$ls2"
						cnt=$(cat "$cnf1" | wc -l)
						grep -F -x -v -f "$cnf1" "$ls1" > $DT/ls1.x
						mv -f $DT/ls1.x "$ls1"
						if [ -n "$(cat "$ls1" | sort -n | uniq -dc)" ]; then
							cat "$ls1" | awk '!array_temp[$0]++' > $DT/ls1.x
							sed '/^$/d' $DT/ls1.x > "$ls1"
						fi
						echo "okim.$cnt.okim" >> \
						$DC/addons/stats/.log &
					fi
					
					if [ -n "$(cat "$cnf2" | grep -o TRUE)" ]; then
						grep -Rl "|FALSE|" "$cnf2" | while read tab2 ; do
							 sed '/|FALSE|/d' "$cnf2" > tmpf2
							 mv tmpf2 $tab2
						done
						sed -i 's/|TRUE|//g' "$cnf2"
						cat "$cnf2" >> "$ls1"
						cnt=$(cat "$cnf2" | wc -l)
						grep -F -x -v -f "$cnf2" "$ls2" > $DT/ls2.x
						mv -f $DT/ls2.x "$ls2"
						# se ocupa de sacar lineas repetidas del indice pricipal del topic
						if [ -n "$(cat "$ls2" | sort -n | uniq -dc)" ]; then
							cat "$ls2" | awk '!array_temp[$0]++' > $DT/ls2.x
							sed '/^$/d' $DT/ls2.x > "$ls2"
						fi
						echo "reim.$cnt.reim" >> \
						$DC/addons/stats/.log &
					fi
				else
					if [ -f "$cnf3" ]; then
						if [ "$cnf3" != "$nt" ]; then
							cat "$cnf3" > "$nt"
						fi
					fi
					rm -f $DT/*.x
				fi
		
		# 3er vista - si el topic esta aprendido
		elif [ "$tb1" -eq 0 ]; then
			if [ ! -f "$DC_tlt/.lk" ]; then
				> "$DC_tlt/.lk"
				echo "$(date +%m/%d/%Y)" > "$DC_tlt/.trw"
				echo "7" > "$DC_tlt/.stts"
				$DS/mngr.sh mkmn &
			fi
			
			dts=$(cat "$DC_tlt/.trw" | wc -l)
			if [ $dts = 1 ]; then
				dte=$(sed -n 1p "$DC_tlt/.trw")
				adv="<b> Hace 15 dias que aprendiste este topic\\n Deseas reiniciarlo para repasar?</b>"
				TM=$(echo $(( ( $(date +%s) - $(date -d "$dte" +%s) ) /(24 * 60 * 60 ) )))
				RM=$((100*$TM/10))
			elif [ $dts = 2 ]; then
				dte=$(sed -n 2p "$DC_tlt/.trw")
				adv="<b> Hace 15 dias que aprendiste este topic\\n Deseas reiniciarlo para repasar?</b>"
				TM=$(echo $(( ( $(date +%s) - $(date -d "$dte" +%s) ) /(24 * 60 * 60 ) )))
				RM=$((100*$TM/25))
			elif [ $dts = 3 ]; then
				dte=$(sed -n 3p "$DC_tlt/.trw")
				adv="<b> Hace 15 dias que aprendiste este topic\\n Deseas reiniciarlo para repasar?</b>"
				TM=$(echo $(( ( $(date +%s) - $(date -d "$dte" +%s) ) /(24 * 60 * 60 ) )))
				RM=$((100*$TM/60))
			elif [ $dts = 4 ]; then
				dte=$(sed -n 4p "$DC_tlt/.trw")
				adv="<b> Hace 15 dias que aprendiste este topic\\n Deseas reiniciarlo para repasar?</b>"
				TM=$(echo $(( ( $(date +%s) - $(date -d "$dte" +%s) ) /(24 * 60 * 60 ) )))
				RM=$((100*$TM/150))
			fi
			
			if [ "$RM" -ge 100 ]; then
				echo "9" > "$DC_tlt/.stts"
				$DS/mngr.sh mkmn &
				RM=100
				
				$yad --title="$tpc" \
				--borders=20 --buttons-layout=edge --class=idiomind \
				--image=$DS/$DS/images/qstn.png --window-icon=idiomind \
				--on-top --window-icon=idiomind \
				--buttons-layout=edge --center --name=idiomind \
				--button="       No       ":1 \
				--button="        Review        ":2 \
				--text="$adv" \
				--width=408 --height=80
					ret=$?
					
					if [ "$ret" -eq 2 ]; then
						echo "8" > "$DC_tlt/.stts"
						rm -f "$DC_tlt/.lk"
						rm -f $DT/*.x
						$DS/mngr.sh mkmn &
						rm -f "$ls2"
						cp -f "$ls0" "$ls1" && idiomind topic & exit 1
					fi
			fi
			
			$yad --align=center --borders=80 \
			--text="<u><b>Learned</b></u>\\nTime for Review:" \
			--bar="":NORM $RM \
			--multi-progress --plug=$KEY --tabnum=1 &
			cat "$ls2" | awk '{print $0"\n"}' | $yad \
			--no-headers --list --plug=$KEY --tabnum=2 \
			--expand-column=1 --ellipsize=END --print-all \
			--column=Name:TEXT --column=Review:CHK \
			--dclick-action='./vwr.sh v2' > "$cnf2" &
			$yad --text-info --plug=$KEY --margins=14 \
			--editable --wrap --text="$itxt" \
			--tabnum=3 --fore='gray40' --column="" --filename="$nt" \
			--show-uri --fontname=vendana --print-column=1 > "$cnf3" &
			$yad --notebook --name=Idiomind --center  \
			--class=Idiomind --align=right --key=$KEY \
			--tab-borders=0 --center --title="$tpc" \
			--tab=" Review " --window-icon=idiomind \
			--tab=" Learned ($tb2) " --tab=" Notes " \
			--ellipsize=END --image-on-top \
			--width="$wth" --height="$eht" --borders=0 \
			--button=Edit:3 --button=Close:2 --always-print-result
				ret=$?
				
				if [ $ret -eq 3 ]; then
					./default/pnls.sh edt &
				
				elif [ $ret -eq 5 ]; then
					rm -f $DT/*.x
					$DS/addons/Practice/strt & killall topic.sh &
				
				elif [ $ret -eq 2 ]; then
					if [ -f "$cnf3" ]; then
						if [ "$cnf3" != "$nt" ]; then
							cat "$cnf3" > "$nt"
						fi
					fi
					if [ -n "$(cat "$cnf1" | grep -o TRUE)" ]; then
						grep -Rl "|FALSE|" "$cnf1" | while read tab1 ; do
							 sed '/|FALSE|/d' "$cnf1" > tmpf1
							 mv tmpf1 $tab1
						done
						sed -i 's/|TRUE|//g' "$cnf1"
						cat "$cnf1" >> "$ls2"
						cnt=$(cat "$cnf1" | wc -l)
						grep -F -x -v -f "$cnf1" "$ls1" > $DT/ls1.x
						mv -f $DT/ls1.x "$ls1"
						if [ -n "$(cat "$ls1" | sort -n | uniq -dc)" ]; then
							cat "$ls1" | awk '!array_temp[$0]++' > $DT/ls1.x
							sed '/^$/d' $DT/ls1.x > "$ls1"
						fi
					fi
					if [ -n "$(cat "$cnf2" | grep -o TRUE)" ]; then
						grep -Rl "|FALSE|" "$cnf2" | while read tab2 ; do
							 sed '/|FALSE|/d' "$cnf2" > tmpf2
							 mv tmpf2 $tab2
						done
						sed -i 's/|TRUE|//g' "$cnf2"
						cat "$cnf2" >> "$ls1"
						cnt=$(cat "$cnf2" | wc -l)
						grep -F -x -v -f "$cnf2" "$ls2" > $DT/ls2.x
						mv -f $DT/ls2.x "$ls2"
						# se ocupa de sacar lineas repetidas del indice pricipal del topic
						if [ -n "$(cat "$ls2" | sort -n | uniq -dc)" ]; then
							cat "$ls2" | awk '!array_temp[$0]++' > $DT/ls2.x
							sed '/^$/d' $DT/ls2.x > "$ls2"
						fi
						echo "reim.$cnt.reim" >> \
						$DC/addons/stats/.log &
					fi
				else
					if [ -f "$cnf3" ]; then
						if [ "$cnf3" != "$nt" ]; then
							cat "$cnf3" > "$nt"
						fi
					fi
					rm -f $DT/*.x
				fi
				rm -f $DT/*.x & exit 1	
			fi
	
	#--------------feeds
	elif echo "$mde" | grep "fd"; then
		dir1="$DM_tl/Feeds"
		dir2="$DC/addons/Learning with news"
		DF="$DS/addons/Learning_with_news"
		STT=$(cat $DC_s/topic_m)
		FEED=$(cat "$dir2/$lgtl/.rss")
		ICON=$DF/img/icon.png
		c=$(echo $(($RANDOM%100000)))
		KEY=$c
		
		if echo "$STT" | grep "Actualizando"; then
			info=$(echo "<i>Actualizando...</i>")
			FEED=$(cat "$DT/.rss")
		else
			info=$(cat $DC_tl/Feeds/.dt)
		fi
		
		cd "$dir1/conten"
		ls -t *.mp3 > "$DC_tl/Feeds/.lst"
		(sed -i 's/.mp3//g' "$DC_tl/Feeds/.lst")
		
		cd $DF
		cat "$DC_tl/Feeds/.lst" | $yad \
		--no-headers --list --listen --plug=$KEY --tabnum=1 \
		--text=" <small>$info</small>" \
		--expand-column=1 --ellipsize=END --print-all \
		--column=Name:TEXT --dclick-action='./vwr.sh V1' &
		cat "$DC_tl/Feeds/.t-inx" | awk '{print $0""}' \
		| $yad --no-headers --list --listen --plug=$KEY --tabnum=2 \
		--expand-column=1 --ellipsize=END --print-all \
		--column=Name:TEXT --dclick-action='./vwr.sh V2' &
		$yad --notebook --name=Idiomind --center \
		--class=Idiomind --align=right --key=$KEY \
		--text=" <big><b>Feeds </b></big>\\n <small>$FEED \\n</small>" \
		--image=$ICON --image-on-top  \
		--tab-borders=0 --center --title="$FEED" \
		--tab="  News  " --tab="   Saved Conten   " \
		--ellipsize=END --image-on-top --window-icon=idiomind \
		--width="$wth" --height="$eht" --borders=0 \
		--button=Play:$DS/play.sh \
		--button=Update:2 \
		--button=Edit:3 \
		--button=Close:1
			ret=$?
			
			if [ $ret -eq 0 ]; then
				rm -f $DT/*.x
				$DF/cnf & killall topic.sh & exit 1
			
			elif [ $ret -eq 3 ]; then
				rm -f $DT/*.x
				$DF/edt/edt & exit 1
			
			elif [ $ret -eq 2 ]; then
				rm -f $DT/*.x
				$DF/strt & exit 1
			else
				rm -f $DT/*.x & exit 1
			fi
			
	elif echo "$mde" | grep "wr"; then
		$DS/addons/Stats/rprt T & exit 1
	fi
	rm -f $DT/*.x
fi