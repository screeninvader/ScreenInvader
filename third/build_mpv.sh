cd /third/mpv-build
echo '--disable-gl' > mpv_options
./rebuild -j4
./install
