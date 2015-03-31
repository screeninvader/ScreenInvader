cd /third/
cd Janosh
./build_dependencies.sh
export PATH="$PATH:/usr/local/bin/"
make -j4
make DESTDIR=/ PREFIX=/lounge/ install


