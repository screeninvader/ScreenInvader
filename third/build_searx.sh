#!/bin/bash

cd /third/
cp -a searx /usr/local/
sudo useradd searx -d /usr/local/searx
sudo chown searx:searx -R /usr/local/searx
chmod a+x /usr/lib/python2.7/dist-packages/virtualenv.py
ln -s /usr/lib/python2.7/dist-packages/virtualenv.py /usr/bin/virtualenv

cd /usr/local/searx
sudo -u searx bash -c "cd /usr/local/searx; virtualenv searx-ve; source ./searx-ve/bin/activate; ./manage.sh update_packages; pip install -r requirements.txt; python setup.py install; sed -i -e \"s/ultrasecretkey/`openssl rand -hex 16`/g\" searx/settings.yml; sed -i -e \"s/debug : True/debug : False/g\" searx/settings.yml"

