#!/lounge/bin/janosh -f

Janosh:system("mkdir -p /run/uwsgi/app/searx")
Janosh:system("chown searx:searx /run/uwsgi/app/searx")
Janosh:system("uwsgi --ini /usr/share/uwsgi/conf/default.ini --ini /etc/uwsgi/apps-enabled/searx.ini")

