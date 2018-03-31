#!/bin/bash

# Para descubrir quantas páginas deverá scrapear:
# hxwls http://www.escolas.inf.br/sp/sao-vicente

# As próx 2 linhas devem ser modificadas conforme a cidade:
arq=EscolasSantos.txt
site=http://www.escolas.inf.br/sp/santos

# http://www.escolas.inf.br/sp/praia-grande		 # 74
# http://www.escolas.inf.br/sp/sao-vicente		 # 132
# http://www.escolas.inf.br/sp/santos			 # 164

touch $arq

for pag in $(seq 164)
do
	
	echo ${site}/${pag}
	echo ${site}/${pag} >> $arq
	lynx -dump -nolist ${site}/${pag} | grep -A4 -B2 'Ende' >> $arq
	echo "***" >> $arq

done


echo FINALIZADO
