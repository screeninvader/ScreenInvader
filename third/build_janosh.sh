cd /third/
cd Janosh
#./build_dependencies.sh
threads="`grep -c ^processor /proc/cpuinfo`"
export PATH="$PATH:/usr/local/bin/"
make -j"$threads" screeninvader_debug
make DESTDIR=/ PREFIX=/lounge/ install


