#!/bin/sh
DEFAULT='https://raw.githubusercontent.com/matentzn/ontologies/master/smalltest.owl'

echo "Import prod"
QUERY=/opt/VFB/import_ontology_transaction.neo4j

CMD='s,'${DEFAULT}','${IMPORT}',g'
echo ${CMD}
sed -i ${CMD} ${QUERY}
cat ${QUERY}
curl -d '@'${QUERY} -H "Content-Type: application/json" -user ${user}':'${password} -X POST ${server}/db/data/transaction/commit
