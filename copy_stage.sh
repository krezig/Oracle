#!/bin/bash
#Author: David Portillo
echo "Introduce la ruta de stage del managed server"
cd /
read -e -p "Ruta:" srch
src="/$srch"
echo "Introduce la ruta destino"
cd /
read -e -p "Ruta:" srch
trgt="/$srch"
for i in $(find ${src} -name "*.*"); do
	echo "${i#"${src}"} => /home/oracle/copy/stage"
	cp "$i" ${trgt}
done
