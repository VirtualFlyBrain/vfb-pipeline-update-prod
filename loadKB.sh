#!/bin/sh
DEFAULT='https://raw.githubusercontent.com/matentzn/ontologies/master/smalltest.owl'

echo "********Import Prod************"
QUERY=/opt/VFB/import_ontology_transaction.neo4j

echo "* Preparing command *"

CMD='s,'${DEFAULT}','${IMPORT}',g'
sed -i ${CMD} ${QUERY}
cat ${QUERY}

echo ""
echo "* Running query *"
echo "curl -i -X POST ${server}/db/data/transaction/commit -u ${user}:${password} -H 'Content-Type: application/json' -d \"@${QUERY}\""
#curl -i -X POST --data "@${QUERY}" -H "Content-Type: application/json" --user ${user}:${password} -X POST ${server}/db/data/transaction/commit
curl -i -X POST ${server}/db/data/transaction/commit -u ${user}:${password} -H 'Content-Type: application/json' -d "@${QUERY}"
