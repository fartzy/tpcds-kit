#!/bin/zsh

if [ $# -ne 4 ]
then
echo "USAGE: gen_all_queries.sh <QUERYDIR> <QUERYDIALECT> <TPCDSKITDIR> <SF>"
echo " where "
echo "   <QUERYDIR> is the full path of the dir to output all the queries too"
echo "   <QUERYDIALECT> is the dialect in which to generate all the queries"
echo "   <TEMPLATESDIR> is the root location of the tpc-ds kit"
echo "   <SF> is the scale factor"
exit -1
fi

QUERYDIR=$1
QUERYDIALECT=$2
TPCDSKITDIR=$3
SF=$4

mkdir -p ${QUERYDIR}/${QUERYDIALECT}
cd ${TPCDSKITDIR}/tools

for line in "${(@f)"$(<"${TPCDSKITDIR}"/query_templates/templates.lst)"}"
{
INPUT=$line
NUM=$(echo $INPUT| cut -d'.' -f 1 | cut -c 6,7)
SQLFILE=query_${NUM}.sql


${TPCDSKITDIR}/tools/dsqgen \
-DIRECTORY ${TPCDSKITDIR}/query_templates \
-INPUT ${TPCDSKITDIR}/query_templates/templates.lst \
-VERBOSE Y \
-TEMPLATE $line \
-QUALIFY Y \
-SCALE $SF \
-DIALECT $QUERYDIALECT \
-OUTPUT_DIR ${QUERYDIR}/${QUERYDIALECT}

mv ${QUERYDIR}/${QUERYDIALECT}/query_0.sql ${QUERYDIR}/${QUERYDIALECT}/${SQLFILE}

}
