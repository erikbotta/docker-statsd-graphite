#!/bin/bash

# Init db tables
cd /root/graphite/webapp/graphite && PYTHONPATH=/root/graphite/webapp python manage.py migrate --settings=graphite.settings

# Init logs 
mkdir -p /root/graphite/storage/log/webapp && touch /root/graphite/storage/log/webapp/info.log