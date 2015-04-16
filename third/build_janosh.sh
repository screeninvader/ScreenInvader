cd /third/
cd Janosh
#./build_dependencies.sh
export PATH="$PATH:/usr/local/bin/"
make -j8 screeninvader_debug
make DESTDIR=/ PREFIX=/lounge/ install


