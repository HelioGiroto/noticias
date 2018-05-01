#!/bin/bash

if [[ $1 = "" ]]
then
	echo "Googleas por?: "
	read palavra
else
	palavra=$(echo $*)
fi

palavra=$(echo $palavra | sed 's/ /+/g')	# Troca espaços em branco no termo da busca para o sinal de +
: > ${palavra}-google.txt			# Cria um arq. vazio para resultados

for pag in $(seq 0 10 90)
do
	echo $pag
	# Baixa a pág. do Google com a busca escolhida 
	curl -s -A Mozilla "http://www.google.com/search?q=${palavra}&start=${pag}" | iconv -f iso8859-1 -t utf-8 > temp.html		
	
	# Acrescenta nova linha ao fim de cada TAG: 
	sed -i 's/|/-/g; s/>/>\n/g' temp.html

	# Extrai html somente do que há entre <body>...:
	sed -n '/<body /,/<\/body>/p' temp.html > temp2.html

	for item in $(seq 1 10)
	do	
		# Variável recebe os links:
		link=$(hxnormalize -x -i0 -l1000 temp2.html | hxselect -s'\n' -c "div.g:nth-child(${item})" | hxselect -c 'h3.r' | hxunent | grep -o 'http.*"' | sed 's/&sa.*//')
	
		# Variável recebe a descrição dos links:
		descri=$(hxnormalize -x -i0 -l10000 temp2.html | hxselect -s'%%' -c "div.g:nth-child(${item})" | hxselect -c 'span.st' | hxunent | sed -z 's/<[/br]*>//g; s/\n//g; s/%%/\n/g')

		echo "${link} | ${descri}" >> ${palavra}-google.txt	# Forma a linha para o arq com os resultados.
	done
done

sed -i '/^ /d' ${palavra}-google.txt	# Apaga alguns item vazios - exclua essa linha e veja a diferença 
rm temp*

