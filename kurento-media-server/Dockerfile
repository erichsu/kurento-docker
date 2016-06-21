# kurento-media-server
#
# VERSION               6.5.0

FROM      ubuntu:14.04
MAINTAINER TingYao Hsu <tingyaohsu@tutorabc.com>

ENV COTURN_VERSION 4.4.5.3

RUN apt-get update && apt-get install -y wget

RUN	echo "deb http://ubuntu.kurento.org trusty kms6" | tee /etc/apt/sources.list.d/kurento.list \
	&& wget -O - http://ubuntu.kurento.org/kurento.gpg.key | apt-key add - \
	&& apt-get update \
	&& apt-get -y install kurento-media-server-6.0 gdebi-core curl \
	&& wget -qO- http://coturn.net/turnserver/v${COTURN_VERSION}/turnserver-${COTURN_VERSION}-debian-wheezy-ubuntu-mint-x86-64bits.tar.gz | tar xzv -C /tmp \
	&& gdebi -n /tmp/coturn*.deb \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# http://turnserver.open-sys.org/downloads/v${COTURN_VERSION}/turnserver-${COTURN_VERSION}-debian-wheezy-ubuntu-mint-x86-64bits.tar.gz
# http://coturn.net/turnserver/v${COTURN_VERSION}/turnserver-${COTURN_VERSION}-debian-wheezy-ubuntu-mint-x86-64bits.tar.gz

# for Kurento
EXPOSE 8888

# for turn server
EXPOSE 49152-65535

COPY ./entrypoint.sh /entrypoint.sh

ENV GST_DEBUG=Kurento*:5

ENTRYPOINT ["/entrypoint.sh"]
