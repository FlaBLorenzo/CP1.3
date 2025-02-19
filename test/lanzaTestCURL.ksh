#!/bin/bash

export TODO=TODOS
export NUM_REGISTROS=40
export URL_BASE=${1}
export RW_RO_MODE="RW"
echo $region
#curl -s -X POST https://hnrgqpsezj.execute-api.us-east-1.amazonaws.com/Prod/todos --data '{"text":"TEST CREASTE CURL API GW"}' | grep "\"statusCode\": 200"
echo $RW_RO_MODE

if [[ "${RW_RO_MODE}" == "RW" ]]
then
        ST=$(curl -s -X POST ${URL_BASE}/todos --data '{"text":"TEST CREASTE CURL API GW"}' | jq '.statusCode')
else
        echo "Lectura SOLO"
        export ST=1
fi

echo "---------------"

if [ $ST -eq 200 ]  # FULL
then
        echo "INSERCION EN ${TODO} TABLE OK"
        for     reg in $(curl -s -X GET ${URL_BASE}/todos | jq '.[].id' | sed -e 's/\"//g' | head -${NUM_REGISTROS})
                do
                        echo "ANTES Procesar para UPDATEAR id: $reg"
                        curl -s -X GET ${URL_BASE}/todos/${reg}
                        echo "Procesando para UPDATEAR id: $reg"
                        curl -s -X PUT ${URL_BASE}/todos/${reg} --data '{"text":"UODATEO ---  nuevo99","checked": true}'
                        echo "DESPUES Procesar para UPDATEAR id: $reg"
                        echo "-------------------------------------------------------------------------------------------------"
                        curl -s -X GET ${URL_BASE}/todos/${reg}
                done


        for     reg in $(curl -s -X GET ${URL_BASE}/todos | jq '.[].id' | sed -e 's/\"//g' | head -${NUM_REGISTROS})
                do
                        echo "ANTES Procesar para BORRAR  id: $reg"
                        curl -s -X DELETE ${URL_BASE}/todos/${reg}
                done
elif [ $ST -eq 1 ]  # RO
then
        echo "Obteniendo Todos los IDs"
        curl -s -X GET ${URL_BASE}/todos | jq '.[].id' | sed -e 's/\"//g'
        for     reg in $(curl -s -X GET ${URL_BASE}/todos | jq '.[].id' | sed -e 's/\"//g' | head -${NUM_REGISTROS})
                do
                        echo "LISTADO DE TODos uno a uno"
                        curl -s -X GET ${URL_BASE}/todos/${reg}
                done
else
        echo "NO SE HA INSERTADO NADA"
        exit 2
fi


