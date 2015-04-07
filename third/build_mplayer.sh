#/bin/bash
cd /third/mplayer-export-*

yes | ./configure --enable-menu --disable-dvdnav --disable-dvdread --enable-alsa --disable-mencoder --enable-x11 --enable-xv --enable-vdpau --extra-ldflags="-lm -lX11 -lXext" --enable-neon --enable-armvfp --enable-vfpv3 --extra-cflags=-mfpu=neon

make
make install

