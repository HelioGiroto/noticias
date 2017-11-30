#!/bin/bash


function cria_MarkDown {
	# cat pederastia_Roma.json | jq '.[] | .abstract, .url' - Isso extrairia os dois campos

	# Extrai somente titulos das buscas | Tira áspas | Remove pipes nos títulos
	cat pederastia_Roma.json | jq '.[] | .abstract' | sed 's/"//g; s/|/-/g' > titulos.not

	# Extrai uls das buscas | Tirando áspas
	cat pederastia_Roma.json | jq '.[] | .url' | sed 's/"//g' > urls.not

	# Junta os dois arquivos gerados acima com delimitador pipe | E coloca [colchetes] e (parentesis) para formato de arquivo .MD:
	paste -d"|" titulos.not urls.not | sed 's/|/](/g; s/^/[/g; s/$/)/g' > tit_url.not

	# Numera linhas do arquivo que foi fusionado e acrescenta uma linha em branco entre cada linha:
	cat tit_url.not | awk '{print NR ") " $0}' | sed 's/$/\n/g' > pederastia_Roma.md

	# Deleta residuos:
	rm *.not
}


function cria_JSON {

	# Muda delimitador padrao para vírgula:
	IFS=,

	# Cria Array de parametros (de sites de buscas) para serem usados pelo Googler:
	sites=('pederasta iglesia católica','escándalo pederastia católica site:sinembargo.mx','escándalo pederastia católica site:jornada.unam.mx','escándalo pederastia católica site:univision.com','escándalo pederastia católica site:vanguardia.com.mx','escándalo pederastia católica site:cnn.com','escándalo pederastia católica site:efe.com','escándalo pederastia católica site:yahoo.com -answers -groups','pederasta católica site:bbc.com','escándalo pederastia católica site:elmundo.es','escándalo pederastia católica site:elpais.com','escándalo pederastia católica site:huffingtonpost.com','escándalo pederastia católica site:milenio.com','escándalo pederastia católica site:abc.es','escándalo pederastia católica site:clarin.com','escándalo pederastia católica site:elcomercio.pe','escándalo pederastia católica site:lavanguardia.com','pederastia católica site:aristeguinoticias.com','escándalo pederastia católica site:reforma.com')

	# Laco para scraping de noticias:
	for site in ${sites[*]}
	do
		echo "Buscando no site:" $(echo $site | cut -d':' -f2)
		googler -n 1000 $site --json >> pederastia_Roma.json
	done

	
}

cria_JSON
cria_MarkDown

# Autor: Helio Giroto
