#!/bin/bash

cd /root/graphite/webapp/graphite
python manage.py runserver 0.0.0.0:8000 &

cd /root/statsd
nodejs stats.js config.js 
