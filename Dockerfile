#Installing ES
FROM alpine:3.3
MAINTAINER Angel Alvarado "angel.angelio@gmail.com"
ADD ./build /build
RUN apk update
RUN apk add curl
RUN chmod +x /build/start.sh
