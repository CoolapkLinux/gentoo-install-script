source /etc/profile 
export PS1="(chroot) ${PS1}"
mkdir -p /boot/efi /var/tmp/portage
rm -f /etc/fstab
cp /home/fstab /etc/fstab
mount -a
emerge --sync
mkdir -p /var/tmp/notmpfs
emerge gcc
eselect profile set 'default/linux/amd64/17.1/desktop/gnome'
passwd root
mv /home/fyn /home/fyn-1
emerge zsh
echo "Enter the expected username:" && read username
useradd -m -G users,wheel,audio -s /bin/zsh $username
passwd  $username
rm -rf /home/fyn
mv /home/fyn-1 /home/fyn
emerge app-eselect/eselect-repository
eselect gcc set 2
yes | eselect repository enable benzene-overlay gentoo-zh haskell mv lto-overlay ssnb edgets
emerge ltoize lto-rebuild
sed -i 's/^#source/source/' /etc/portage/make.conf
lto-rebuild -r
emerge clang llvm compiler-rt llvm-libunwind lld
sed -i 's/#CC/CC/' /etc/portage/make.conf
sed -i 's/#CXX/CXX/' /etc/portage/make.conf
sed -i 's/#AR/AR/' /etc/portage/make.conf
sed -i 's/#NM/NM/' /etc/portage/make.conf
sed -i 's/#RANLIB/RANLIB/' /etc/portage/make.conf
emerge clang llvm compiler-rt llvm-libunwind lld
emerge --verbose --update --deep --newuse @world --autounmask-write
yes | etc-update --automode -3
USE="-harfbuzz" emerge --oneshot freetype
emerge --verbose --update --deep --newuse @world
emerge --depclean 
emerge -uvDN @world
echo "Asia/Shanghai" >> /etc/timezone
emerge --config sys-libs/timezone-data
echo "C.UTF8 UTF-8" >> /etc/locale.gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "zh_CN.UTF-8 UTF-8" >> /etc/locale.gen
echo "zh_CN.GBK GBK" >> /etc/locale.gen
locale-gen
eselect locale set 'zh_CN.utf8'
emerge linux-tkg-sources 
emerge sudo 
sed -i "s/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/" /etc/sudoers
eselect kernel set 1
cd /usr/src/linux
cp /home/.config /usr/src/linux
make olddefconfig
make -j7 && make modules_install && make install
emerge sys-kernel/linux-firmware
echo "hostname=gentoo-fyn" > /etc/conf.d/hostname
emerge cronie
rm -r /root
cp -r /home/root /root
emerge sys-boot/grub
grub-install --target=x86_64-efi --efi-directory=/boot --removable  --compress=zstd --bootloader-id=Gentoo-fyn --core-compress=auto
grub-mkconfig -o /boot/grub/grub.cfg
emerge --ask --noreplace net-misc/netifrc
nano /etc/conf.d/net
emerge zsh
