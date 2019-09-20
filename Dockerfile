FROM virtualflybrain/docker-vfb-neo4j:enterprise

ENV server=http://192.168.0.1:7474
ENV user=neo4j
ENV password=password
ENV IMPORT=http://192.168.0.1:8080/rdf4j-server/repositories/vfb?query=PREFIX+rdfs%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0APREFIX+owl%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2002%2F07%2Fowl%23%3E%0APREFIX+rdf%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0APREFIX+obo%3A+%3Chttp%3A%2F%2Fpurl.obolibrary.org%2Fobo%2F%3E%0ACONSTRUCT+%7B%3Fx+%3Fy+%3Fz%7D%0AWHERE+%7B%0A%09%3Fx+%3Fy+%3Fz+.%0A%7D%0A

RUN mkdir -p /opt/VFB/backup

RUN apk update && apk add tar gzip curl wget

COPY process.sh /opt/VFB/
COPY import_ontology_transaction.neo4j /opt/VFB/
COPY load_prod.cypher /opt/VFB/

RUN chmod +x /opt/VFB/process.sh

ENTRYPOINT ["/opt/VFB/process.sh"]
