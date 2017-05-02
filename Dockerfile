FROM node

#install required dependencies
RUN apt-get update && \
    apt-get --no-install-recommends -y install \
           build-essential pkg-config erlang \
           libicu-dev libmozjs185-dev libcurl4-openssl-dev curl

COPY apache-couchdb-2.0.0.tar.gz .

#install couchdb 2.0.0
RUN tar -xf apache-couchdb-2.0.0.tar.gz && \
    cd apache-couchdb-2.0.0 && \
    ./configure && \
    make release

#add couchdb user
RUN adduser --system \
        --shell /bin/bash \
        --group --gecos \
        "CouchDB Administrator" couchdb

RUN cp -R /apache-couchdb-2.0.0/rel/couchdb /home/couchdb
RUN chown -R couchdb:couchdb /home/couchdb/couchdb
RUN find /home/couchdb/couchdb -type d -exec chmod 0770 {} \;
RUN chmod 0644 /home/couchdb/couchdb/etc/*

RUN sed -i'' 's/bind_address = 127.0.0.1/bind_address = 0.0.0.0/' /home/couchdb/couchdb/etc/default.ini

RUN mkdir -p app
ADD package.json ./app
ADD . ./app
RUN npm install --silent
RUN chmod +x ./app/start.sh

CMD ["./app/start.sh"]
