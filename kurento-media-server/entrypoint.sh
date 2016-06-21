#!/bin/bash
set -e

if [ ! -z "$COTURN_PORT_3478_TCP_ADDR" ]; then
  if [ ! -z "$COTURN_PORT_3478_TCP_PORT" ]; then
    # Generate WebRtcEndpoint configuration
    echo "stunServerAddress=$COTURN_PORT_3478_TCP_ADDR" > /etc/kurento/modules/kurento/WebRtcEndpoint.conf.ini
    echo "stunServerPort=$COTURN_PORT_3478_TCP_PORT" >> /etc/kurento/modules/kurento/WebRtcEndpoint.conf.ini
  fi
fi

EXTERNAL_IP=$(curl -4 icanhazip.com)

echo "TURNSERVER_ENABLED=1" >> /etc/default/coturn \
	&& echo "user=kurento:kurento" >> /etc/turnserver.conf \
	&& echo "realm=kurento.org" >> /etc/turnserver.conf
	
if [ ! -z "$IS_AWS_EC2" ]; then
	# Launch Turnserver if have external IP
	EXTERNAL_IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
	LOCAL_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
	echo "external-ip=${EXTERNAL_IP}/${LOCAL_IP}" >> /etc/turnserver.conf
else
	echo "external-ip=${EXTERNAL_IP}/${LOCAL_IP}" >> /etc/turnserver.conf
fi

if [ ! -z "$COTURN_MIN_PORT" ]; then
	echo "min-port=${COTURN_MIN_PORT}" >> /etc/turnserver.conf
fi

if [ ! -z "$COTURN_MAX_PORT" ]; then
	echo "max-port=${COTURN_MAX_PORT}" >> /etc/turnserver.conf
fi

service coturn start

# Remove ipv6 local loop until ipv6 is supported
cat /etc/hosts | sed '/::1/d' | tee /etc/hosts > /dev/null

exec /usr/bin/kurento-media-server "$@"
