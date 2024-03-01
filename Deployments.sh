#!/bin/sh oracle
date=$(date '+%Y-%m-%d')
STAGE=/u01/app/oracle/product/11.1.2.4/fmw_1/user_projects/domains/rec_domain/servers/Recaudador/stage
BACKUPDEP=/home/oracle/Respaldo_Artefactos

echo -e "\n \n "
echo -e "Borrando Registros Previos... \n"
rm -rf $BACKUPDEP/*

echo -e "Creando Archivo de Registro de copia... "
touch >> $BACKUPDEP/Resumen-$date.txt
ls $BACKUPDEP

echo -e "Obteniendo artefactos a Respaldar... "
echo "=== Despliegues Respaldados se enlistan a continuación: === "
echo "=== Despliegues Respaldados se enlistan a continuación: === " >> $BACKUPDEP/Resumen-$date.txt
echo $date >> $BACKUPDEP/Resumen-$date.txt
ls -ltr $STAGE >> $BACKUPDEP/Resumen-$date.txt 
echo -e "\n \n "
ls $STAGE

echo -e "\n"
echo -e Copiando Artefactos ...
echo -e "\n" >> $BACKUPDEP/Resumen-$date.txt
echo Copiando artefactos al DRP  >> $BACKUPDEP/Resumen-$date.txt
cp $STAGE/*/*.ear $BACKUPDEP
echo -e "Ears Copiados " >> $BACKUPDEP/Resumen-$date.txt
cp $STAGE/*/*.war $BACKUPDEP
echo -e "Wars Copiados \n" >> $BACKUPDEP/Resumen-$date.txt
ls $BACKUPDEP -1 | wc -l >> $BACKUPDEP/Resumen-$date.txt
echo -e "Artefactos copiados con éxito en /home/oracle/Respaldo_Artefactos... " >> $BACKUPDEP/Resumen-$date.txt
ls $BACKUPDEP -1 | wc -l
echo -e Copiando Artefactos a DRP...
scp -r /home/oracle/Respaldo_Artefactos/* oracle@172.16.241.121:/home/oracle/Respaldo_Artefactos



EARS
/u01/app/oracle/product/10.1.3/as_1.new/j2ee/Recaudador/applications

BACKUP LOCATION
/home/oracle/Respaldo_Artefactos

dur4Ng0¡3d0

scp -r /home/oracle/Respaldo_Artefactos oracle@172.16.241.123:/home/oracle/Respaldo_Artefactos