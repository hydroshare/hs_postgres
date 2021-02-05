FROM postgres:13.1
MAINTAINER Alva L. Couch <acouch@cuahsi.org>

RUN apt-get update && apt-get install -y \
    sudo \
    curl \
    ca-certificates \
    gnupg \
    wget

RUN curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

RUN sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt buster-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

RUN apt-get update 
# && 
#    apt-get install -y \
#       postgis \
#       postgresql-13-postgis-2.4 \
#       postgresql-13-postgis-scripts

COPY allow-all.sh /docker-entrypoint-initdb.d/

# Cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 5432
CMD ["postgres"]
