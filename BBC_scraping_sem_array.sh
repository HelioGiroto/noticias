#!/bin/bash


# A intençäo a principio era fazer duas listas de arrays:
# - Um array de h3
# - Um array de URLs respectivas
# Depois sobe para um arquivo.MD no Github

# Porém a lista de h3 teria espacos nas frases e teria que mudar o IFS depois 'des-'mudar, etc..

# Assim, achei mais simplificado fazer usando um laço para ler cada linha de cada arquivo parseado (H3 e URLs). Depois uso SED -n '1p' para isso!
 
# ----------------------------------

# array de urls (Como formar um array de uma lista de items que o hxselect devolve):

# links=($(hxnormalize -x http://www.bbc.com/mundo/topics/0f469e6a-d4a6-46f2-b727-2bd039cb6b53 | hxselect -s'|' a.title-link | tr "\n" " " | sed 's/  //g; s/|/\n/g' | cut -d'"' -f4 | sed 's-^-http://www.bbc.com-g' | xargs))


# -----------------------------------

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


# Imprime cabeçalho para noticias:
echo "	******** NOTICIAS *********" >> $nomearq
echo >> $nomearq


# Scraping das noticias com seus URLs respectivos:

# Tecnologia

echo "***** Notícias sobre Tecnologia *****" > h3.items
echo "-" > url.items

hxnormalize -x http://www.bbc.com/mundo/topics/31684f19-84d6-41f6-b033-7ae08098572a | hxselect -s'|' -c h3 span | tr "\n" " " | sed 's/&quot;/"/g ; s/  //g; s/|/\n/g' >> h3.items

hxnormalize -x http://www.bbc.com/mundo/topics/31684f19-84d6-41f6-b033-7ae08098572a | hxselect -s'|' a.title-link | tr "\n" " " | sed 's/  //g; s/|/\n/g' | cut -d'"' -f4 | sed 's-^-http://www.bbc.com-g' >> url.items

echo Tecnologia completado	# Imprime na Tela para usuário acompanhar execuçäo

# Ciencia

echo "***** Notícias sobre Ciência *****" >> h3.items	# essas 2 linhas säo neces. p/ impr. cabeçalho
echo "-" >> url.items

hxnormalize -x http://www.bbc.com/mundo/topics/0f469e6a-d4a6-46f2-b727-2bd039cb6b53 | hxselect -s'|' -c h3 span | tr "\n" " " | sed 's/&quot;/"/g ; s/  //g; s/|/\n\n/g' >> h3.items

hxnormalize -x http://www.bbc.com/mundo/topics/0f469e6a-d4a6-46f2-b727-2bd039cb6b53 | hxselect -s'|' a.title-link | tr "\n" " " | sed 's/  //g; s/|/\n/g' | cut -d'"' -f4 | sed 's-^-http://www.bbc.com-g' >> url.items

echo Ciência completado

# Internacional

echo "***** Notícias internacionais *****" >> h3.items
echo "-" >> url.items

hxnormalize -x http://www.bbc.com/mundo/internacional | hxselect -s'|' -c h3 span | tr "\n" " " | sed 's/&quot;/"/g ; s/  //g; s/|/\n\n/g' >> h3.items

hxnormalize -x http://www.bbc.com/mundo/internacional | hxselect -s'|' a.title-link | tr "\n" " " | sed 's/  //g; s/|/\n/g' | cut -d'"' -f4 | sed 's-^-http://www.bbc.com-g' >> url.items

echo Internacional completado

sed -i /^$/d h3.items url.items		# Apaga linhas em branco

# Laço para imprimir cada linha de cada arquivo de maneira respectiva para a saída final:

linhas=$(cat url.items | wc -l)

for n in $(seq $linhas)
do
	cat h3.items | sed -n $n'p' >> $nomearq		# SED com variáveis!!!
	cat url.items | sed -n $n'p' >> $nomearq	# SED com variáveis!!!
	echo >> $nomearq
done

# Manipulando arquivos ...

rm *.items			# Apaga arquivos dos items

cp $nomearq ~/Dropbox		# Copia para pasta pública de Dropbox

# Copia para GitHub:
cp $nomearq ~/Documentos/noticias/README.md
cd ~/Documentos/noticias
git add .
git commit -m "Atualizando..."
git push -u origin master

# Abre navegador com a página atualizada:
chromium-browser https://github.com/HelioGiroto/noticias/blob/master/README.md

# Instalar dropbox via terminal: https://www.dropbox.com/install

# Autor: Helio Giroto - Licença MIT de copyright
