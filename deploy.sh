#!/bin/bash
#Creado por: David Portillo
case "$1" in
	'deployone')
		echo "Selecciona un Middleware Home"
                select mw in $(find /u01/app/oracle/product/ -maxdepth 2 -mindepth 2 | grep fmw_*); do
                        echo "$mw seleccionado"
                        sleep 1
                        break
                done
		test -e ${mw}/wlserver_10.3/server/bin/setWLSEnv.sh && a=`echo "Found"`|| a=`echo "Not Found"`
		case "$a" in
			'Found')
			. ${mw}/wlserver_10.3/server/bin/setWLSEnv.sh
			;;
			'Not Found')
			. ${mw}/wlserver/server/bin/setWLSEnv.sh
			;;
			*)
			echo "Ocurrió un error al validar la ruta de setWLSEnv.sh"
			;;
		esac
#Se obtienen los parámetros para weblogic Deployer
		conn="false"
		while [ "$conn" = "false" ]; do
			echo "Introduce el Admin Port"
			read port
			echo "Introduce el password de weblogic"
			read -s pass
			echo "Probando conexión con servidor..."
			conn_stat=$(java weblogic.Deployer -adminurl t3://localhost:${port} -username weblogic -password ${pass} -listtask)
			bad_conn="Unable to connect to server"
			if echo "$conn_stat" | grep -q "$bad_conn"; then
				echo "Puerto o Contraseña inválidos";
			else
				echo "Conexión exitosa";
				conn="true"
			fi
		done
		sleep 1
		echo "Introduce el nombre de la aplicación"
		read app
		echo "Introduce el nombre del target (Servidor)"
		read target
		echo "Busca el artefacto a desplegar"
		cd /
        read -e -p "Artefacto:/" srch
        path="/$srch"
#Se realiza undeploy de la aplicación
		java weblogic.Deployer -adminurl t3://localhost:${port} -username weblogic -password ${pass} -undeploy -name ${app} -targets ${target}

#Se realiza deploy de la aplicación
		java weblogic.Deployer -adminurl t3://localhost:${port} -username weblogic -password ${pass} -deploy -name ${app} -targets ${target} -source ${path}
	;;
	'deployall')
		echo "Selecciona un Middleware Home"
		select mw in $(find /u01/app/oracle/product/ -maxdepth 2 -mindepth 2 | grep fmw_*); do
			echo "$mw seleccionado"
			sleep 1
			break
		done
                test -e ${mw}/wlserver_10.3/server/bin/setWLSEnv.sh && a=`echo "Found"`|| a=`echo "Not Found"`
                case "$a" in
                        'Found')
                        . ${mw}/wlserver_10.3/server/bin/setWLSEnv.sh
                        ;;
                        'Not Found')
                        . ${mw}/wlserver/server/bin/setWLSEnv.sh
                        ;;
                        *)
                        echo "Ocurrió un error al validar la ruta de setWLSEnv.sh"
                       ;; 
                esac
#Se obtienen los parámetros para weblogic Deployer
                conn="false"
                while [ "$conn" = "false" ]; do
                        echo "Introduce el Admin Port"
                        read port
                        echo "Introduce el password de weblogic"
                        read -s pass
			echo "Probando conexión con servidor..."
                        conn_stat=$(java weblogic.Deployer -adminurl t3://localhost:${port} -username weblogic -password ${pass} -listtask)
                        bad_conn="Unable to connect to server"
                        if echo "$conn_stat" | grep -q "$bad_conn"; then
                                echo "Puerto o Contraseña inválidos";
                        else
                                echo "Conexión exitosa";
                                conn="true"
                        fi
                done
		sleep 1
		echo "Introduce el nombre del target (Servidor)"
                read target
                echo "Introduce la ruta que contiene los artefactos a desplegar"
		cd /
		read -e -p "Ruta:/" srch
		path="/$srch" 
#Se indican los sufijos que se removerán del nombre del archivo para obtener el nombre que tendrá cada aplicación en weblogic
		suffix_ear=.ear		
		suffix_war=.war		
		echo "Se realizará despliegue de las siguientes aplicaciones:"
		sleep 1
#Se corre un ciclo que obtiene el nombre de los archivos dentro del path
		for i in $(ls ${path}); do
#Se remueven los sufijos del nombre del archivo para enlistarlos
			if [[ $i == *.ear ]]
			then
				app=${i%$suffix_ear}
			else
				app=${i%$suffix_war}
			fi
			echo "${app}"
		done
		echo "¿Continuar con el despliegue? (y/n)"
		read ans
		case "${ans}" in
			'y')
				echo "Se comienza con el despliegue"
				for i in $(ls ${path}); do
#Se remueven los sufijos del nombre del archivo para mandar el nombre como parámetro a weblogic Deployer
                       			 if [[ $i == *.ear ]]
                       			 then
                               			 app=${i%$suffix_ear}
                       			 else
                               			 app=${i%$suffix_war}
                       			 fi
#Se realiza undeploy de cada aplicación listada
					 	java weblogic.Deployer -adminurl t3://localhost:${port} -username weblogic -password ${pass} -undeploy -name ${app} -targets ${target}
               				 done
				for i in $(ls ${path}); do
                                         if [[ $i == *.ear ]]
                                         then
                                                 app=${i%$suffix_ear}
                                         else
                                                 app=${i%$suffix_war}
                                         fi
#Se crea path completo donde se encuentra el archivo a desplegar
					 app_path="${path}/"
					 app_path="${app_path}${i}"
				 	 echo "${app_path}"
#Se realiza deploy de cada aplicación listada
						java weblogic.Deployer -adminurl t3://localhost:${port} -username weblogic -password ${pass} -deploy -name ${app} -targets ${target} -source ${app_path}
				done
			;;
			'n')
				echo "Despliegue cancelado"
			;;
			*)
				echo "Opción inválida, despliegue cancelado"
			;;
		esac
				
	;;
	*)
		echo "Opción inválida. Uso: sh $0 Opcion"
		echo "deployone - Despliega un sólo artefacto"
		echo "deployall - Despliega todos los artefactos de una ruta"
	;;
esac
