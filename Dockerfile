FROM solr:8.8.1-slim

COPY solr.in.sh /etc/default/

USER root
COPY kawasaki-gc/ /var/solr/data/kawasaki-gc/
RUN apt-get update && \
    apt-get install -y nkf curl --no-install-recommends && \
    curl 'https://www.city.kawasaki.jp/300/cmsfiles/contents/0000075/75059/GarbageDataBase.csv' 2>/dev/null | nkf -wLu | sed -e '1d' >> /var/solr/data/kawasaki-gc/garbage.csv && \
    chown -R solr:solr /var/solr/data/kawasaki-gc/ && \
    rm -rf /var/lib/apt/lists/*

USER solr
RUN solr start && \
    sleep 10 && \
    curl -XPOST -H'Content-Type:application/csv' 'http://localhost:8983/solr/kawasaki-gc/update?commit=true&f.synonyms.split=true&f.synonyms.separator=%20' --data-binary @/var/solr/data/kawasaki-gc/garbage.csv && \
    solr stop -all