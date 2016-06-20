# stream oriented kurento
#
# VERSION               4.4.3

FROM      ubuntu:14.04
MAINTAINER Patxi Gortázar <patxi.gortazar@gmail.com>

RUN apt-get update && apt-get install -y wget

RUN	echo "deb http://ubuntu.kurento.org trusty kms6" | tee /etc/apt/sources.list.d/kurento.list \
	&& wget -O - http://ubuntu.kurento.org/kurento.gpg.key | apt-key add - \
	&& apt-get update \
	&& apt-get -y install kurento-media-server-6.0 gdebi-core curl \
	&& apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV COTURN_VERSION 4.4.5.3
WORKDIR /tmp
RUN wget -qO- http://turnserver.open-sys.org/downloads/v${COTURN_VERSION}/turnserver-${COTURN_VERSION}-debian-wheezy-ubuntu-mint-x86-64bits.tar.gz | tar xzv
RUN gdebi -n coturn*.deb
RUN echo "TURNSERVER_ENABLED=1" >> /etc/default/coturn \
	&& echo "user=kurento:kurento" >> /etc/turnserver.conf \
	&& echo "realm=kurento.org" >> /etc/turnserver.conf \
	&& echo "external-ip=52.193.72.117" >> /etc/turnserver.conf

EXPOSE 8888

COPY ./entrypoint.sh /entrypoint.sh

ENV GST_DEBUG=Kurento*:5

ENTRYPOINT ["/entrypoint.sh"]
