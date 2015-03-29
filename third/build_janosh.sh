cd /third/
cd Janosh
./build_dependencies.sh
make -j4
make DESTDIR=/ PREFIX=/lounge/ install
ln -s /usr/lib/x86_64-linux-gnu/libzmq.so.3 /usr/lib/x86_64-linux-gnu/libzmq.so


