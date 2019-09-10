#!/bin/sh

DEFAULT='https://raw.githubusercontent.com/matentzn/ontologies/master/smalltest.owl'

set -e

echo "********Import Prod************"
QUERY=/opt/VFB/import_ontology_transaction.neo4j
CYPHER=/opt/VFB/load_prod.cypher

echo "* Preparing command *"

CMD='s,'${DEFAULT}','${IMPORT}',g'
sed -i ${CMD} ${QUERY}
sed -i ${CMD} ${CYPHER}

echo "* Query (HTTP API) *"
cat ${QUERY}

echo "* Query 2 (Cypher shell) *"
cat ${CYPHER}

echo ""
echo "* Running query *"
#echo "curl -i -X POST ${server}/db/data/transaction/commit -u ${user}:${password} -H 'Content-Type: application/json' -d \"@${QUERY}\""
echo "cat ${CYPHER} | cypher-shell -u ${user} -p ${password} -a ${server} --format plain"
#curl -i -X POST --data "@${QUERY}" -H "Content-Type: application/json" --user ${user}:${password} -X POST ${server}/db/data/transaction/commit
# https://neo4j.com/docs/http-api/3.5/actions/begin-and-commit-a-transaction-in-one-request/
curl -i -X POST ${server}/db/data/transaction/commit -u ${user}:${password} -H 'Content-Type: application/json' -d "@${QUERY}"
#cat ${CYPHER} | cypher-shell -u ${user} -p ${password} -a ${server} --format plain

echo "process complete"