cd /third/
git clone https://github.com/screeninvader/SimpleOSD.git
cd SimpleOSD
make clean
make -j8
make DESTDIR=/ PREFIX=/lounge/ install

