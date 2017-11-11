#!/bin/bash

dia=$(date | awk '{print $3 $2 $6}')
nomearq="BBC_noticias_"$dia".txt"

# Imprime cabeçalho do Arquivo de noticias com a data de hoje:
date > $nomearq
echo >> $nomearq

# Raspagem de dados sobre clima e condiçöes climáticas:
temperatura=$(hxnormalize -x https://www.climatempo.com.br/previsao-do-tempo/cidade/558/saopaulo-sp | hxselect -c p#momento-temperatura | sed 's/&.*//')

condicao=$(hxnormalize -x https://www.climatempo.com.br/previsao-do-tempo/cidade/558/saopaulo-sp | hxselect -c p#momento-condicao)

# Imprime dados no arquivo sobre o Clima:
echo "Temperatura em Sao Paulo:" $temperatura "ºC" >> $nomearq
echo >> $nomearq
echo "Clima: " $condicao >> $nomearq
echo >> $nomearq

# Raspagem de dados para noticias:
sites=(http://www.bbc.com/mundo/topics/31684f19-84d6-41f6-b033-7ae08098572a http://www.bbc.com/mundo/topics/0f469e6a-d4a6-46f2-b727-2bd039cb6b53 http://www.bbc.com/mundo/internacional)

noticias=(Tecnologia Ciencia Internacional)

for i in $(seq 0 2)
do
	h3=$(hxnormalize -x ${sites[$i]} | hxselect -s'|' -c h3 span | tr "\n" " " | sed 's/&quot;/"/g ; s/  //g')
	url=$(hxnormalize -x ${sites[$i]} | hxselect -s'|' a.title-link | tr "\n" " " | sed 's/  //g; s/|/\n/g' | cut -d'"' -f4 | sed 's-^-http://www.bbc.com-g' | tr "\n" ",")


	echo "**** Noticias:" ${noticias[$i]} "****" >> $nomearq
	echo >> $nomearq

	for x in $(seq 20)
	do
		echo $h3 | cut -d"|" -f$x >> $nomearq
		echo $url | cut -d"," -f$x >> $nomearq
		echo >> $nomearq
	done

	echo >> $nomearq
done

# Manipula arquivos para Dropbox e GitHub:
cp $nomearq ~/Dropbox		# Dropbox

# Copia para GitHub:
cp $nomearq ~/Documentos/noticias/README.md
cd ~/Documentos/noticias
git add .
git commit -m "Atualizado!"
git push -u origin master

# Abre navegador com a página atualizada:
chromium-browser https://github.com/HelioGiroto/noticias/blob/master/README.md

# Instalar dropbox via terminal: https://www.dropbox.com/install

# Autor: Helio Giroto - Licença MIT de copyright
