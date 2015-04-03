cd /third/
cd Janosh
./build_dependencies.sh
export PATH="$PATH:/usr/local/bin/"
make screeninvader_debug
make DESTDIR=/ PREFIX=/lounge/ install


