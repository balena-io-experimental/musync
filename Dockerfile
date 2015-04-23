FROM resin/rpi-node:latest

RUN apt-get -q update && apt-get install -qy libasound2-dev ntpdate

ADD . /musync

RUN cd /musync && npm install

CMD ["bash", "/musync/start.sh"]