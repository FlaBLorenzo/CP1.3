#!/bin/bash

export AGENTE=agente1
ps -ef | grep -v grep| grep java | egrep  ${AGENTE}
if [ $? -ge 1 ]
then
        nohup java -jar agent.jar -url http://54.236.192.92:8080/ -secret @secret-file -name ${AGENTE} -webSocket -workDir "/home/${AGENTE}" &
else
        echo "YA SE HA LANZADO : AGENTE : ${AGENTE}"
fi
