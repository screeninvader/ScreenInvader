#!/bin/bash

cd /third/
cp -a searx /usr/local/
sudo useradd searx -d /usr/local/searx
sudo chown searx:searx -R /usr/local/searx

cd /usr/local/searx
sudo -u searx virtualenv searx-ve
sudo -u searx bash -c "cd /usr/local/searx; /usr/lib/python2.7/dist-packages/virtualenv.py searx-ve; source ./searx-ve/bin/activate; pip install -r requirements.txt; python setup.py install; sed -i -e \"s/ultrasecretkey/`openssl rand -hex 16`/g\" searx/settings.yml; sed -i -e \"s/debug : True/debug : False/g\" searx/settings.yml"

