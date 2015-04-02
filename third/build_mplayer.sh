cd /third/mplayer-export-*

yes | ./configure --disable-dvdnav --disable-dvdread --enable-alsa --disable-mencoder --enable-x11 --enable-xv --enable-vdpau --enable-neon --enable-armvfp --enable-vfpv3 --extra-cflags=-mfpu=neon --extra-ldflags="-lm -lX11 -lXext"

make
make install

