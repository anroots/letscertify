FROM quay.io/letsencrypt/letsencrypt
MAINTAINER Ando Roots <ando@sqroot.eu>

VOLUME /etc/letsencrypt /var/lib/letsencrypt /tmp/letsencrypt-web

ENTRYPOINT []
CMD ["/usr/sbin/cron", "-f"]

RUN apt-get update && \
	apt-get install cron && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /etc/cron* && \
	mkdir /etc/cron.daily

COPY crontab /etc/
COPY update-certs /etc/cron.daily/
