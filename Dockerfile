FROM phusion/baseimage:0.9.15


RUN apt-get -y update


RUN apt-get -y --force-yes install vim\
 git \
 python \
 python-dev \
 python-pip \
 nginx \
 nodejs


# StatsD
WORKDIR /root
RUN git clone https://github.com/etsy/statsd.git 

WORKDIR /root/statsd
RUN git checkout v0.8.0
COPY /conf/statsd/config.js config.js


RUN pip install whisper
RUN pip install carbon --install-option="--prefix=/root/graphite" --install-option="--install-lib=/root/graphite/lib"
RUN pip install graphite-web --install-option="--prefix=/root/graphite" --install-option="--install-lib=/root/graphite/webapp"


RUN pip install django==1.8 zope.interface django-tagging


# Setup carbon
WORKDIR /root/graphite/conf
RUN cp carbon.conf.example carbon.conf
RUN cp storage-schemas.conf.example storage-schemas.conf

# run carbon
RUN /root/graphite/bin/carbon-cache.py start 

# Configure webapp
WORKDIR /root/graphite/webapp/graphite
RUN PYTHONPATH=/root/graphite/webapp python manage.py migrate --settings=graphite.settings

RUN python manage.py runserver 0.0.0.0:8000 &



EXPOSE 80:80 8000:8000 8125:8125

WORKDIR /root/statsd
CMD nodejs stats.js config.js
