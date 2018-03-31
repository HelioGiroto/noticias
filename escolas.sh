#!/bin/bash

arq=EscolaSantos.txt
site=http://www.escolas.inf.br/sp/santos

touch $arq

for pag in $(seq 164)
do
	
	echo ${site}/${pag}
	echo ${site}/${pag} >> $arq
	lynx -dump -nolist ${site}/${pag} | grep -A4 -B2 'Ende' >> $arq
	echo "***" >> $arq

done


echo FINALIZADO


# http://www.escolas.inf.br/sp/sao-vicente

