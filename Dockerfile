FROM solr:8.8.1-slim

USER root

COPY solr.in.sh /etc/default/
COPY kawasaki-gc/ /var/solr/data/kawasaki-gc/
RUN chown -R solr:solr /var/solr/data/kawasaki-gc/

USER solr