FROM virtualflybrain/docker-vfb-neo4j:enterprise

# from compose args
ARG CONF_REPO
ARG CONF_BRANCH

ENV CONF_BASE=/opt/conf_base
ENV CONF_DIR=${CONF_BASE}/config/update-prod

# A set of transactions to be run one by one. A directory with *.neo4j files
VOLUME /input
ENV CSV_IMPORT_TRANSACTIONS=/input/dumps/csv_imports/transactions

RUN mkdir -p /opt/VFB/backup

RUN apk update && apk add tar gzip curl wget git

RUN mkdir $CONF_BASE
###### REMOTE CONFIG ######
ARG CONF_BASE_TEMP=${CONF_BASE}/temp
RUN mkdir $CONF_BASE_TEMP
RUN cd "${CONF_BASE_TEMP}" && git clone --quiet ${CONF_REPO} && cd $(ls -d */|head -n 1) && git checkout ${CONF_BRANCH}
# copy inner project folder from temp to conf base
RUN cd "${CONF_BASE_TEMP}" && cd $(ls -d */|head -n 1) && cp -R . $CONF_BASE && cd $CONF_BASE && rm -r ${CONF_BASE_TEMP}

COPY process.sh /opt/VFB/
COPY import_ontology_transaction.neo4j /opt/VFB/
# COPY pdb_set_indices.neo4j /opt/VFB/

RUN chmod +x /opt/VFB/process.sh

ENTRYPOINT ["/opt/VFB/process.sh"]
