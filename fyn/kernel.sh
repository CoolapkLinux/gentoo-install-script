emerge linux-tkg-sources
eselect kernel set 1
cd /usr/src/linux
cp /home/.config /usr/src/linux
make olddefconfig
make -j7 && make modules_install && make install