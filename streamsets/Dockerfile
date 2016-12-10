FROM streamsets/datacollector:1.5.1.2
MAINTAINER Angel Alvarado "angel.angelio@gmail.com"
USER root
RUN apk add --no-cache python && \
    python -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip install pyyaml ua-parser user-agents && \
    rm -r /root/.cache
