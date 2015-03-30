cd /third/
cd Janosh
./build_dependencies.sh
make -j4
make DESTDIR=/ PREFIX=/lounge/ install


