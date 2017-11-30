#!/bin/bash

rm ~/Documentos/noticias/README.md		# Sem isso as vezes dá conflito - Deleta o antigo da pasta!

dia=$(date | awk '{print $3 $2 $6}')
nomearq="BBC_noticias_"$dia".txt"

# Imprime cabeçalho do Arquivo de noticias com a data de hoje:
date | awk '{print $1 " " $3 "/" $2 "/" $6 " " $4}' > $nomearq
echo >> $nomearq

# Raspagem de dados sobre clima e condiçöes climáticas:
temperatura=$(hxnormalize -x https://www.climatempo.com.br/previsao-do-tempo/cidade/558/saopaulo-sp | hxselect -c p#momento-temperatura | hxunent)

condicao=$(hxnormalize -x https://www.climatempo.com.br/previsao-do-tempo/cidade/558/saopaulo-sp | hxselect -c p#momento-condicao)

# Imprime dados no arquivo sobre o Clima:
echo "Temperatura em Sao Paulo:" $temperatura "C" >> $nomearq
echo >> $nomearq
echo "Clima: " $condicao >> $nomearq
echo >> $nomearq

# Raspagem de dados para noticias:
sites=(http://www.bbc.com/mundo/topics/31684f19-84d6-41f6-b033-7ae08098572a http://www.bbc.com/mundo/topics/0f469e6a-d4a6-46f2-b727-2bd039cb6b53 http://www.bbc.com/mundo/internacional)

noticias=(Tecnologia Ciencia Internacional)

for i in $(seq 0 2)
do

	h3=$(hxnormalize -x -i0 -l1000 ${sites[$i]} | hxselect -s'|' -c h3 span | hxunent)
	url=$(hxnormalize -x -i0 -l1000 ${sites[$i]} | hxselect a.title-link | hxwls | tr "\n" ",")

	echo "### Noticias:" ${noticias[$i]} "###" >> $nomearq
	echo >> $nomearq

	for x in $(seq 20)
	do
		titulo=$(echo $h3 | cut -d"|" -f$x)	# Este script tb nao usa arrays, mas-
		link=$(echo $url | cut -d"," -f$x)	# ...-corta o texto (slice).
		printf "%s\n\n" "[$titulo](http://www.bbc.com$link)" >> $nomearq  # Formato MarkDown
	done

	echo >> $nomearq
done

# Copia para GitHub:
cp $nomearq ~/Documentos/noticias/README.md
cd ~/Documentos/noticias
git pull
git add .
git commit -m "Atualizado!"
git push -u origin master

# Retira formato de MarkDown para salvar em disco e no Dropbox:
cd -		# Volta ao diretório que estava antes de ir ao diretorio de GitHub
sed -i 's/](/\n/g; s/\[//g; s/)//g' $nomearq

# Salva para Dropbox:
cp $nomearq ~/Dropbox

# Abre navegador com a página atualizada:
chromium-browser https://github.com/HelioGiroto/noticias/blob/master/README.md

# Autor: Helio Giroto - Licença MIT de copyright
