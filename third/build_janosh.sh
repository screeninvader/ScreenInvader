cd /third/
cd Janosh
./build_dependencies.sh
export PATH="$PATH:/usr/local/bin/"
make screeninvader
make DESTDIR=/ PREFIX=/lounge/ install


