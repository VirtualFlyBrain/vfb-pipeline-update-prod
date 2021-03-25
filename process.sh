#!/bin/sh

set -e

echo "process started"
echo "Start: vfb-pipeline-update-prod"
echo "VFBTIME:"
date

## get remote configs
echo "Sourcing remote config"
source ${CONF_DIR}/config.env

SET_INDICES_QUERY=${CONF_DIR}/pdb_set_indices.neo4j

echo "* Preparing command *"
RESULT=$(curl -i -X POST ${server}/db/neo4j/tx/commit -u ${user}:${password} -H 'Content-Type: application/json' -d '{"statements": [{"statement": "CREATE INDEX ON :Entity(iri)"}]}')
echo ${RESULT}
if [[ ${RESULT} != *"\"errors\":[]"* ]]; then
    echo "Loading nodes into PDB failed.. "
    echo ${RESULT}
    exit 1
fi

echo "Loading nodes"
for i in $CSV_IMPORT_TRANSACTIONS/nodes_*.neo4j; do
    echo $i
    date
    [ -f "$i" ] || break
    QUERY="$i"
    cat $QUERY
    RESULT=$(curl -i -X POST ${server}/db/neo4j/tx/commit -u ${user}:${password} -H 'Content-Type: application/json' -d "@${QUERY}")
    echo $RESULT
    #if [[ ${RESULT} != *"\"errors\":[]"* ]]; then
    #    echo "Loading nodes into PDB failed.. "
    #    echo ${RESULT}
    #    exit 1
    #fi
done

echo "Loading relationships"
for i in $CSV_IMPORT_TRANSACTIONS/relationship_*.neo4j; do
    echo $i
    date
    [ -f "$i" ] || break
    QUERY="$i"
    cat $QUERY
    RESULT=$(curl -i -X POST ${server}/db/neo4j/tx/commit -u ${user}:${password} -H 'Content-Type: application/json' -d "@${QUERY}")
    echo $RESULT
    #if [[ ${RESULT} != *"\"errors\":[]"* ]]; then
    #    echo "Loading relationships into PDB failed.. "
    #    echo ${RESULT}
    #    exit 1
    #fi
done

#curl -i -X POST ${server}/db/data/transaction/commit -u ${user}:${password} -H 'Content-Type: application/json' -d '{"statements": [{"statement": "CREATE INDEX ON :Individual(short_form)"}]}'
#curl -i -X POST ${server}/db/data/transaction/commit -u ${user}:${password} -H 'Content-Type: application/json' -d '{"statements": [{"statement": "CREATE INDEX ON :Class(short_form)"}]}'
curl -i -X POST ${server}/db/neo4j/tx/commit -u ${user}:${password} -H 'Content-Type: application/json' -d "@${SET_INDICES_QUERY}"


#cat ${CYPHER} | cypher-shell -u ${user} -p ${password} -a ${server} --format plain


echo "End: vfb-pipeline-update-prod"
echo "VFBTIME:"
date
echo "process complete"
