FROM postgres:9.4.7
MAINTAINER Michael J. Stealey <stealey@renci.org>

RUN apt-get update && apt-get install -y \
    sudo \
    wget

# RUN sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt trusty-pgdg main" >> /etc/apt/sources.list'
RUN wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
RUN apt-get update && apt-get install -y \
    postgresql-9.4-postgis-2.1 \
    pgadmin3 \
    postgresql-contrib-9.4

RUN sudo sh -c 'sed -e "s/main/main contrib non-free/" < /etc/apt/sources.list > /etc/apt/sources.new'
RUN sudo sh -c 'mv /etc/apt/sources.new /etc/apt/sources.list'
RUN apt-get update && \
    apt-get install -y \
    git \
    gcc \
    make \
    vim \
    libevent-dev \ 
    pkg-config \
    openssl \
    libtool \
    m4 \
    automake \
    pandoc \
    libssl-dev

RUN cd /usr/local/src; \
    git clone https://github.com/pgbouncer/pgbouncer.git; \
    cd pgbouncer; \
    git submodule init; \
    git submodule update; \
    ./autogen.sh; \
    ./configure --with-openssl --without-pam; \
    make; \
    make install 

COPY allow-all.sh /docker-entrypoint-initdb.d/

#RUN echo "listen_addresses = '*'" >> /var/lib/postgresql/data/postgresql.conf

# Cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 5432
CMD ["postgres"]
