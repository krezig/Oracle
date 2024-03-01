#!/bin/sh oracle
date=$(date '+%Y-%m-%d')
STAGE=/u01/app/oracle/product/11.1.2.4/fmw_1/user_projects/domains/rec_domain_01/servers/Recaudador/stage
BACKUP=/home/oracle/Respaldo_Ears

echo -e "Borrando Registros Previos... \n \n"
rm -rf $BACKUP/*

echo -e "Creando Archivo de Registro de copia... \n"
touch >> $BACKUP/Resumen-$date.txt
ls $BACKUP

echo -e "Obteniendo artefactos a Respaldar... "
echo "===  Los Despliegues Respaldados se enlistan a continuación: ===" >> /home/oracle/Respaldo_Ears/Resumen-$date.txt
echo $date >> $BACKUP/Resumen-$date.txt
ls -ltr $STAGE >> $BACKUP/Resumen-$date.txt 
echo -e "\n \n "
ls $STAGE

echo -e "\n"
echo -e Copiando Artefactos ...
cp $STAGE/*/*.ear $BACKUP
echo -e "Ears Copiados "
cp $STAGE/*/*.war $BACKUP
echo -e "Wars Copiados \n"
echo -e "Archivos copiados con éxito ... \n \n"
