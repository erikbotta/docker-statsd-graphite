FROM phusion/baseimage:0.9.15


RUN apt-get -y update


RUN apt-get -y --force-yes install vim\
 git \
 python \
 python-dev \
 python-pip \
 nginx \
 supervisor \
 nodejs \
 libffi-dev \
 libcairo2-dev

# Supervisor setup 
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# StatsD
WORKDIR /root
RUN git clone https://github.com/etsy/statsd.git 
WORKDIR /root/statsd
RUN git checkout v0.8.0
COPY /conf/statsd/config.js config.js


RUN pip install whisper
RUN pip install carbon --install-option="--prefix=/root/graphite" --install-option="--install-lib=/root/graphite/lib"
RUN pip install graphite-web --install-option="--prefix=/root/graphite" --install-option="--install-lib=/root/graphite/webapp"


RUN pip install django==1.8 zope.interface django-tagging cairocffi


# Setup carbon
WORKDIR /root/graphite/conf
RUN cp carbon.conf.example carbon.conf
RUN cp storage-schemas.conf.example storage-schemas.conf



EXPOSE 80 8000 8125/udp

WORKDIR /root
COPY init.sh init.sh
RUN chmod +x init.sh
CMD ["/usr/bin/supervisord"]
