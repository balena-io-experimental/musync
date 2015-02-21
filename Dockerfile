FROM resin/rpi-node:latest

RUN apt-get -q update && apt-get install -qy libasound2-dev ntpdate

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/app/vendor/node/bin

ADD . /musync

ADD start /start
