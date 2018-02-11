FROM streamsets/datacollector:1.5.1.2
MAINTAINER Angel Alvarado "angel.angelio@gmail.com"
USER root
RUN apk add --no-cache python && \
    python -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip install pyyaml ua-parser user-agents && \
    rm -r /root/.cache
RUN curl -o /tmp/GeoLite2-City.tar.gz http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz
RUN gunzip /tmp/GeoLite2-City.tar.gz
RUN tar -C /tmp -xvf /tmp/GeoLite2-City.tar
RUN mv /tmp/GeoLite2-City_* /tmp/GeoLite2-City