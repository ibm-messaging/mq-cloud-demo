#!/bin/bash
# © Copyright IBM Corporation 2018, 2021
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# configure_qmgr.sh <qm-1-connections-file> <app-file-1> <qm-2-connections-file> <app-file-2> <user-file>
# 
# QMGR_1_HOST: hostname of first qmgr (e.g. qm1234.domain.com)
# QMGR_1_PORT: port for first qmgr (e.g. 31999)
# QMGR_1_NAME: name of first qmgr (e.g. QM1234)
# QMGR_1_ENV: environment of first qmgr (e.g. IBM)
#
# QMGR_2_HOST: hostname of second qmgr (e.g. qm5678.other.domain.com)
# QMGR_2_NAME: name of second qmgr (e.g. QM5678)
# QMGR_2_PORT: port for second qmgr (e.g. 31998)
# QMGR_2_ENV: environment of second qmgr (e.g. AWS)
# APP_USERNAME: username of application (e.g. stockapp)

# Set connection details files
QM_FILE_1=$1
APP_FILE_1=$2
QM_FILE_2=$3
APP_FILE_2=$4
USER_FILE=$5

# Default strings for Common Environments
BMX="BMX"
IBM="IBM"
AWS="AWS"
ONPREM="ONPREM"

# Defaults
QMGR_1_HOST=
QMGR_1_PORT=
QMGR_1_NAME=
QMGR_1_ENV=
QMGR_2_HOST=
QMGR_2_NAME=
QMGR_2_PORT=
QMGR_2_ENV=
APP_1_USERNAME=
APP_2_USERNAME=

printf "=============================================================\n"
printf "=                                                           =\n"
printf "=          CONFIGURE QMGR 1 <-> QMGR 2 CONNECTION           =\n"
printf "=                                                           =\n"
printf "=============================================================\n\n"

printf "Configure two queue managers to send and receive messages.\n\n"

if [ -f "${QM_FILE_1}" ]; 
then
  QMGR_1_HOST=`jq '.hostname' ${QM_FILE_1} -r`
  QMGR_1_PORT=`jq '.listenerPort' ${QM_FILE_1} -r`
  QMGR_1_NAME=`jq '.queueManagerName' ${QM_FILE_1} -r`
  QMGR_1_ENV=`jq '.hostname' ${QM_FILE_1} -r | awk -F"-" '{ print $2}' | tr '[:lower:]' '[:upper:]'`
  if [ ${QMGR_1_ENV} == ${BMX} ];
  then
    QMGR_1_ENV=${IBM}
    echo ${QMGR_1_ENV}
  fi
else
  printf "Hostname of first queue manager: e.g. qm1.domain.com\n"
  printf ""
  printf "> "

  INPUT=`read INPUT;echo $INPUT`
  TRIM_INPUT=`echo ${INPUT} | awk '{ print $1}'`
  if [[ "${TRIM_INPUT}" == "" ]] ;
  then
    printf " The response was blank - exiting...\n"
    exit -1
  fi
  QMGR_1_HOST=${INPUT}

  printf "\nPort Number of first queue manager: e.g. 31234\n"
  printf "> "

  INPUT=`read INPUT;echo $INPUT`
  TRIM_INPUT=`echo ${INPUT} | awk '{ print $1}'`
  if [[ "${TRIM_INPUT}" == "" ]] ;
  then
    printf " The response was blank - exiting...\n"
    exit -1
  fi
  QMGR_1_PORT=${INPUT}

  printf "\nName of first queue manager: e.g. QM1\n"
  printf "> "

  INPUT=`read INPUT;echo $INPUT`
  TRIM_INPUT=`echo ${INPUT} | awk '{ print $1}'`
  if [[ "${TRIM_INPUT}" == "" ]] ;
  then
    printf " The response was blank - exiting...\n"
    exit -1
  fi
  QMGR_1_NAME=${INPUT}

  printf "\nEnvironment of first queue manager:\n"
  printf "e.g. IBM, AWS, ONPREMISE, LOCAL, REMOTE...\n"
  printf "> "

  INPUT=`read INPUT;echo $INPUT`
  TRIM_INPUT=`echo ${INPUT} | awk '{ print $1}'`
  if [[ "${TRIM_INPUT}" == "" ]] ;
  then
    printf " The response was blank - exiting...\n"
    exit -1
  fi
  QMGR_1_ENV=${INPUT}
fi

if [ -f "${QM_FILE_2}" ]; 
then
  QMGR_2_HOST=`jq '.hostname' ${QM_FILE_2} -r`
  QMGR_2_PORT=`jq '.listenerPort' ${QM_FILE_2} -r`
  QMGR_2_NAME=`jq '.queueManagerName' ${QM_FILE_2} -r`
  QMGR_2_ENV=`jq '.hostname' ${QM_FILE_2} -r | awk -F"-" '{ print $2}' | tr '[:lower:]' '[:upper:]'`
  if [ ${QMGR_2_ENV} == ${BMX} ];
  then
    QMGR_2_ENV=${IBM}
    echo ${QMGR_2_ENV}
  fi
else
  printf "\nHostname of second queue manager: e.g. qm2.other.domain.com\n"
  printf ""
  printf "> "

  INPUT=`read INPUT;echo $INPUT`
  TRIM_INPUT=`echo ${INPUT} | awk '{ print $1}'`
  if [[ "${TRIM_INPUT}" == "" ]] ;
  then
    printf " The response was blank - exiting...\n"
    exit -1
  fi
  QMGR_2_HOST=${INPUT}

  printf "\nPort Number of second queue manager: e.g. 31235\n"
  printf "> "

  INPUT=`read INPUT;echo $INPUT`
  TRIM_INPUT=`echo ${INPUT} | awk '{ print $1}'`
  if [[ "${TRIM_INPUT}" == "" ]] ;
  then
    printf " The response was blank - exiting...\n"
    exit -1
  fi
  QMGR_2_PORT=${INPUT}

  printf "\nName of second queue manager: e.g. QM2\n"
  printf "> "

  INPUT=`read INPUT;echo $INPUT`
  TRIM_INPUT=`echo ${INPUT} | awk '{ print $1}'`
  if [[ "${TRIM_INPUT}" == "" ]] ;
  then
    printf " The response was blank - exiting...\n"
    exit -1
  fi
  QMGR_2_NAME=${INPUT}

  printf "\nEnvironment of second queue manager:\n"
  printf "Must be upper case, and nospaces; e.g. 'IBM' or 'ONPREMISE'\n"
  printf "> "

  INPUT=`read INPUT;echo $INPUT`
  TRIM_INPUT=`echo ${INPUT} | awk '{ print $1}'`
  if [[ "${TRIM_INPUT}" == "" ]] ;
  then
    printf " The response was blank - exiting...\n"
    exit -1
  fi
  QMGR_2_ENV=${INPUT}
fi

if [ -f ${APP_FILE_1} ];
then
  APP_1_USERNAME=`jq '.mqUsername' ${APP_FILE_1} -r`
else
  printf "\nUsername for application user: e.g. stockapp\n"
  printf "> "

  INPUT=`read INPUT;echo $INPUT`
  TRIM_INPUT=`echo ${INPUT} | awk '{ print $1}'`
  if [[ "${TRIM_INPUT}" == "" ]] ;
  then
    printf " The response was blank - exiting...\n"
    exit -1
  fi
  APP_1_USERNAME=${INPUT}
fi

if [ -f ${APP_FILE_2} ];
then
  APP_2_USERNAME=`jq '.mqUsername' ${APP_FILE_2} -r`
else
  printf "\nUsername for application user: e.g. stockapp\n"
  printf "> "

  INPUT=`read INPUT;echo $INPUT`
  TRIM_INPUT=`echo ${INPUT} | awk '{ print $1}'`
  if [[ "${TRIM_INPUT}" == "" ]] ;
  then
    printf " The response was blank - exiting...\n"
    exit -1
  fi
  APP_2_USERNAME=${INPUT}
fi


if [ -f ${USER_FILE} ];
then
  MQ_CLOUD_USERNAME=`jq '.mqUsername' ${USER_FILE} -r`
  PLATFORM_API_KEY=`jq '.apiKey' ${USER_FILE} -r`
else
  printf "\nUsername for application user: e.g. stockapp\n"
  printf "> "

  INPUT=`read INPUT;echo $INPUT`
  TRIM_INPUT=`echo ${INPUT} | awk '{ print $1}'`
  if [[ "${TRIM_INPUT}" == "" ]] ;
  then
    printf " The response was blank - exiting...\n"
    exit -1
  fi
  MQ_CLOUD_USERNAME=${INPUT}

  printf "\nPassword for application user:\n"
  printf "For IBM Cloud users this will be your Platform API Key\n"
  printf "> "

  INPUT=`read INPUT;echo $INPUT`
  TRIM_INPUT=`echo ${INPUT} | awk '{ print $1}'`
  if [[ "${TRIM_INPUT}" == "" ]] ;
  then
    printf " The response was blank - exiting...\n"
    exit -1
  fi
  PLATFORM_API_KEY=${INPUT}
fi


printf "\nPlease verify your settings:\n"
printf "QMGR_1_HOST:  ${QMGR_1_HOST}\n"
printf "QMGR_1_PORT: ${QMGR_1_PORT}\n"
printf "QMGR_1_NAME: ${QMGR_1_NAME}\n"
printf "QMGR_1_ENV: ${QMGR_1_ENV}\n"
printf "QMGR_2_HOST: ${QMGR_2_HOST}\n"
printf "QMGR_2_NAME: ${QMGR_2_NAME}\n"
printf "QMGR_2_PORT: ${QMGR_2_PORT}\n"
printf "QMGR_2_ENV: ${QMGR_2_ENV}\n"
printf "APP_1_USERNAME: ${APP_1_USERNAME}\n"
printf "APP_2_USERNAME: ${APP_2_USERNAME}\n"
printf "MQ_CLOUD_USERNAME: ${MQ_CLOUD_USERNAME}\n"
printf "PLATFORM_API_KEY is SET"

printf "\nPlease confirm these details are correct, enter 'y' to continue:\n"
printf "> "

AFIRM=`read INPUT;echo $INPUT`
TRIM_INPUT=`echo ${AFIRM} | awk '{ print $1}'`
if [[ "${TRIM_INPUT}" == "" ]] ;
then
	printf " The response was blank - exiting...\n"
	exit -1
fi
if [ "${AFIRM}" != "y" ] && [ "${AFIRM}" != "Y" ] ;
then
	printf " The response was not y or Y - exiting...\n"
	exit -1
fi

printf "=============================================\n"
printf "=                                            =\n"
printf "=         CONFIGURE ${QMGR_1_NAME}              =\n"
printf "=                                            =\n"
printf "==============================================\n\n"

printf '==================================\n'
printf '        LOGIN TO REST API         \n'
printf '==================================\n\n'

curl https://web-${QMGR_1_HOST}/ibmmq/rest/v1/login -H "Content-Type: application/json" \
  -X POST -v --data '{"username":"'${MQ_CLOUD_USERNAME}'","password":"'${PLATFORM_API_KEY}'"}' -k -c cookiejar.txt

# curl to send mqsc message via RESTful

CSRF_TOKEN=$(cat cookiejar.txt | grep TRUE | awk '{print $7}')

declare -a cmds=("DEFINE QLOCAL('TO.${QMGR_2_ENV}') USAGE(XMITQ)"
                "DEFINE QREMOTE(STOCK.REPLY) RNAME(STOCK.REPLY) RQMNAME('${QMGR_2_NAME}') XMITQ('TO.${QMGR_2_ENV}')"
                "DEFINE QLOCAL(STOCK)"
                "SET AUTHREC PROFILE(STOCK) OBJTYPE(QUEUE) PRINCIPAL('${APP_1_USERNAME}') AUTHADD(ALLMQI)"
                "SET AUTHREC PROFILE(STOCK.REPLY) OBJTYPE(QUEUE) PRINCIPAL('${APP_1_USERNAME}') AUTHADD(ALLMQI)"
                "DEFINE CHANNEL('${QMGR_2_ENV}.TO.${QMGR_1_ENV}') CHLTYPE(RCVR) TRPTYPE(TCP)"
                "DEFINE CHANNEL('${QMGR_1_ENV}.TO.${QMGR_2_ENV}') CHLTYPE(SDR) CONNAME('${QMGR_2_HOST}(${QMGR_2_PORT})') XMITQ('TO.${QMGR_2_ENV}') TRPTYPE(TCP)"
                "SET CHLAUTH('${QMGR_2_ENV}.TO.${QMGR_1_ENV}') TYPE(QMGRMAP) QMNAME('${QMGR_2_NAME}') ACTION(ADD) USERSRC(CHANNEL)"
                "START CHANNEL('${QMGR_1_ENV}.TO.${QMGR_2_ENV}')"
                "DISPLAY CHSTATUS('${QMGR_1_ENV}.TO.${QMGR_2_ENV}')"
                )

for i in "${cmds[@]}"
do
    printf "\n==========================================================\n\n"
    printf "Executing MQSC Command\n"
    printf "$i\n"
    printf "\n==========================================================\n\n"

    curl https://web-${QMGR_1_HOST}/ibmmq/rest/v1/admin/action/qmgr/${QMGR_1_NAME}/mqsc \
    -H "ibm-mq-rest-csrf-token: ${CSRF_TOKEN}" -H "Content-Type: application/json" \
    -X POST --data '{"type":"runCommand","parameters":{"command":"'"$i"'"}}'\
    -k -b cookiejar.txt
done

printf "\n==========================================================\n\n"
printf "            QUEUE manager ${QMGR_1_NAME} CONFIGURED         \n"
printf "\n==========================================================\n\n"

rm -rf cookiejar.txt
unset CSRF_TOKEN

printf "=============================================\n"
printf "=                                            =\n"
printf "=         CONFIGURE ${QMGR_2_NAME}              =\n"
printf "=                                            =\n"
printf "==============================================\n\n"

printf '==================================\n'
printf '        LOGIN TO REST API         \n'
printf '==================================\n\n'

curl https://web-${QMGR_2_HOST}/ibmmq/rest/v1/login -H "Content-Type: application/json" \
  -X POST -v --data '{"username":"'${MQ_CLOUD_USERNAME}'","password":"'${PLATFORM_API_KEY}'"}' -k -c cookiejar.txt

# curl to send mqsc message via RESTful

CSRF_TOKEN=$(cat cookiejar.txt | grep TRUE | awk '{print $7}')

declare -a cmds=("DEFINE QLOCAL('TO.${QMGR_1_ENV}') USAGE(XMITQ)"
                "DEFINE QREMOTE(STOCK) RNAME(STOCK) RQMNAME('${QMGR_1_NAME}') XMITQ('TO.${QMGR_1_ENV}')"
                "DEFINE QLOCAL(STOCK.REPLY)"
                "SET AUTHREC PROFILE(STOCK) OBJTYPE(QUEUE) PRINCIPAL('${APP_2_USERNAME}') AUTHADD(ALLMQI)"
                "SET AUTHREC PROFILE(STOCK.REPLY) OBJTYPE(QUEUE) PRINCIPAL('${APP_2_USERNAME}') AUTHADD(ALLMQI)"
                "DEFINE CHANNEL('${QMGR_1_ENV}.TO.${QMGR_2_ENV}') CHLTYPE(RCVR) TRPTYPE(TCP)"
                "DEFINE CHANNEL('${QMGR_2_ENV}.TO.${QMGR_1_ENV}') CHLTYPE(SDR) CONNAME('${QMGR_1_HOST}(${QMGR_1_PORT})') XMITQ('TO.${QMGR_1_ENV}') TRPTYPE(TCP)"
                "SET CHLAUTH('${QMGR_1_ENV}.TO.${QMGR_2_ENV}') TYPE(QMGRMAP) QMNAME('${QMGR_1_NAME}') ACTION(ADD) USERSRC(CHANNEL)"
                "START CHANNEL('${QMGR_2_ENV}.TO.${QMGR_1_ENV}')"
                "DISPLAY CHSTATUS('${QMGR_2_ENV}.TO.${QMGR_1_ENV}')"
                )

for i in "${cmds[@]}"
do
    printf "\n==========================================================\n\n"
    printf "Executing MQSC Command\n"
    printf "$i\n"
    printf "\n==========================================================\n\n"

    curl https://web-${QMGR_2_HOST}/ibmmq/rest/v1/admin/action/qmgr/${QMGR_2_NAME}/mqsc \
    -H "ibm-mq-rest-csrf-token: ${CSRF_TOKEN}" -H "Content-Type: application/json" \
    -X POST --data '{"type":"runCommand","parameters":{"command":"'"$i"'"}}'\
    -k -b cookiejar.txt 
done

printf "\n==========================================================\n\n"
printf "            QUEUE manager ${QMGR_2_NAME} CONFIGURED         \n"
printf "\n==========================================================\n\n"


printf "\n==========================================================\n\n"
printf "            QUEUE MANAGERS CONFIGURED SUCCESSFULLY          \n"
printf "\n==========================================================\n\n"