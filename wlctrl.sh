#!/bin/sh 
# Description: WebLogic adminServer and managedServer start script 
# Author: ltarango 12/16/2010

# Customize according to installation:
WLS_DOMAIN=base_domain
WLS_OWNER=oracle
WLS_MOUNT=/u01/app
WLS_MANAGED_SERVER1=Recaudador
WLS_BIDOMAIN=bifoundation_domain_2
WLS_BIMANAGED_SERVER1=bi_server1

JAVA_HOME=/u01/app/oracle/product/11.1.1/fmw_1/jrockit-R28.1.4-4.0.1
export JAVA_HOME
PATH=$JAVA_HOME/bin:$PATH:$HOME/bin
export PATH


# Do not change from here forward:

WLS_FMW_HOME=${WLS_MOUNT}/${WLS_OWNER}/product/11.1.1/fmw_1
WLS_HOME=${WLS_FMW_HOME}/user_projects/domains/${WLS_DOMAIN}
WLS_BIHOME=${WLS_FMW_HOME}/user_projects/domains/${WLS_BIDOMAIN}
WLS_NODE_HOME=${WLS_FMW_HOME}/wlserver_10.3/server/bin
WLS_LOG_START=${WLS_FMW_HOME}/logs/start.`date '+%d%m%y'`.log
WLS_LOG_STOP=${WLS_FMW_HOME}/logs/stop.`date '+%d%m%y'`.log


startWebLogic()
{ 
   echo ".... Iniciando WebLogic"
   cd $WLS_HOME/bin
   echo $WLS_HOME/bin
   nohup ./startWebLogic.sh >> ${WLS_LOG_START} 2>&1 &
   return 0
} 


startNodeManager()
{
   echo ".... Iniciando Node Manager"
   cd $WLS_NODE_HOME
   echo $WLS_NODE_HOME
   nohup ./startNodeManager.sh >> ${WLS_LOG_START} 2>&1 &
   return 0
}


startWLManagedServer()
{
   echo ".... Iniciando WebLogic Managed Server"
   cd $WLS_HOME/bin
   echo $WLS_HOME/bin
   nohup ./startManagedWebLogic.sh ${WLS_MANAGED_SERVER1} >> ${WLS_LOG_START} 2>&1 &
   return 0
}

startBI()
{ 
   echo ".... Iniciando BI Publisher"
   cd $WLS_BIHOME/bin
   echo $WLS_BIHOME/bin
   nohup ./startWebLogic.sh >> ${WLS_LOG_START} 2>&1 &
   return 0
} 


startBIManagedServer()
{
   echo ".... Iniciando BI Publisher Managed Server"
   cd $WLS_BIHOME/bin
   echo $WLS_BIHOME/bin
   nohup ./startManagedWebLogic.sh ${WLS_BIMANAGED_SERVER1} >> ${WLS_LOG_START} 2>&1 &
   return 0
}

stopWLManagedServer()
{
   echo ".... Deteniendo WebLogic Managed Server"
   cd $WLS_HOME/bin
   echo $WLS_HOME/bin
   nohup ./stopManagedWebLogic.sh $WLS_MANAGED_SERVER1 >> ${WLS_LOG_STOP} 2>&1 &
   return 0
}

stopNodeManager()
{
   echo ".... Deteniendo Node Manager"
   kill `getNodeManager_pid` `getNodeManager_script_pid`
   return 0
}

stopWebLogic()
{ 
   echo ".... Deteniendo WebLogic"
   cd $WLS_HOME/bin
   echo $WLS_HOME/bin
   nohup ./stopWebLogic.sh >> ${WLS_LOG_STOP} 2>&1 &
   return 0
} 


stopBIManagedServer()
{
   echo ".... Deteniendo BI Publisher Managed Server"
   cd $WLS_BIHOME/bin
   echo $WLS_BIHOME/bin
   nohup ./stopManagedWebLogic.sh $WLS_BIMANAGED_SERVER1 >> ${WLS_LOG_STOP} 2>&1 &
   return 0
}


stopBI()
{ 
   echo ".... Deteniendo BI Publisher"
   cd $WLS_BIHOME/bin
   echo $WLS_BIHOME/bin
   nohup ./stopWebLogic.sh >> ${WLS_LOG_STOP} 2>&1 &
   return 0
} 

getNodeManager_script_pid()
{
	nodemanager_pid=`ps -ef | grep startNodeManager | grep -v grep | awk '{ print $2 }'`
	echo $nodemanager_pid
}

getNodeManager_pid()
{
	script_pid=`getNodeManager_script_pid`
	nodemanager_pid=`ps --no-headers --ppid $script_pid 2>/dev/null | awk '{ print $1 }'`
	echo $nodemanager_pid
}

case "$1" in
    'startwl')
        startWebLogic
        sleep 120
        startWLManagedServer
        sleep 360
        ;; 
    'stopwl')
        stopWLManagedServer
        sleep 180
        stopWebLogic
        sleep 180
        ;;
    'stopms')
        stopWLManagedServer
        sleep 180
        ;;
    'startms')
        startWLManagedServer
        sleep 360
        ;;
    'startbi')
        startBI
        sleep 120
        startBIManagedServer
        sleep 360
        ;;
   'stopbi')
        stopBIManagedServer
        sleep 180
        stopBI
        sleep 180
        ;;
   'startnm')
        startNodeManager
        sleep 30
        ;; 
    'stopnm')
        stopNodeManager
        sleep 40
        ;;
   'startall')
        startWebLogic
        sleep 120
	startNodeManager
        sleep 30
        startWLManagedServer
        sleep 360
	startBI
        sleep 120
        startBIManagedServer
        sleep 360
        ;; 
    'stopall')
        stopWLManagedServer
        sleep 180
	stopBIManagedServer
        sleep 180
	stopNodeManager
        sleep 40
        stopBI
        sleep 180
        stopWebLogic
        sleep 180
        ;;
    *) 
        echo "* Opcion Invalida. Uso: sh $0 OPCION"
        echo "OPCIONES:"
        echo "   startwl  - Inicia el WebLogic y el Managed Server"
        echo "   stopwl   - Detiene el WebLogic y el Managed Server"
        echo "   startms  - Inicia el Managed Server"
        echo "   stopms   - Detiene el Managed Server"
        echo "   startbi  - Inicia el BI Publisher y el BI Managed Server"
        echo "   stopbi   - Detiene el BI Publisher y el BI Managed Server"
        echo "   startnm  - Inicia el Node Manager"
        echo "   stopnm   - Detiene el Node Manager"
        echo "   startall - Inicia los servicios de Fusion Middle Ware"
        echo "   stopall  - Detiene los servicios de Fusion Middle Ware"
        exit 1
        ;;
esac


