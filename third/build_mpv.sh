cd /third/mpv-build
echo '--disable-gl' > mpv_options
echo '--disable-drm' >> mpv_options
./rebuild -j4
./install
