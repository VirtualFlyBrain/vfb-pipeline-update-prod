#!/bin/sh

set -e

echo "process started"
echo "Start: vfb-pipeline-update-prod"
echo "VFBTIME:"
date

DEFAULT_URL='N2O_ONTOLOGY_URL'
DEFAULT_CONFIG='N2O_CONFIG'

QUERY=/opt/VFB/import_ontology_transaction.neo4j

echo "* Preparing command *"

CMD1='s,'${DEFAULT_URL}','${IMPORT}',g'
sed -i ${CMD1} ${QUERY}
CMD2='s,'${DEFAULT_CONFIG}','${IMPORT_CONFIG}',g'
sed -i ${CMD2} ${QUERY}

echo ""
echo "* Running query *"
cat ${QUERY}
#echo "curl -i -X POST ${server}/db/data/transaction/commit -u ${user}:${password} -H 'Content-Type: application/json' -d \"@${QUERY}\""
#echo "cat ${CYPHER} | cypher-shell -u ${user} -p ${password} -a ${server} --format plain"
#curl -i -X POST --data "@${QUERY}" -H "Content-Type: application/json" --user ${user}:${password} -X POST ${server}/db/data/transaction/commit
# https://neo4j.com/docs/http-api/3.5/actions/begin-and-commit-a-transaction-in-one-request/
RESULT=$(curl -i -X POST ${server}/db/data/transaction/commit -u ${user}:${password} -H 'Content-Type: application/json' -d "@${QUERY}")

echo $(RESULT)

if [[ ${RESULT} == *"ERROR:"* ]]; then
    echo "Loading ontology into PROD failed.. "
    echo ${RESULT}
    exit 1
fi

curl -i -X POST ${server}/db/data/transaction/commit -u ${user}:${password} -H 'Content-Type: application/json' -d '{"statements": [{"statement": "CREATE INDEX ON :Individual(short_form)"}]}'
curl -i -X POST ${server}/db/data/transaction/commit -u ${user}:${password} -H 'Content-Type: application/json' -d '{"statements": [{"statement": "CREATE INDEX ON :Class(short_form)"}]}'


#cat ${CYPHER} | cypher-shell -u ${user} -p ${password} -a ${server} --format plain


echo "End: vfb-pipeline-update-prod"
echo "VFBTIME:"
date
echo "process complete"