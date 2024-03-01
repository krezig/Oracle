#!/bin/bash
pid=$(ps -fea | grep rec_domain | grep recaudador | awk '{print $2}')
jstack $pid > /home/oracle/thread_dumps/Recadump.`date '+%Y%m%d_%T'`.log
