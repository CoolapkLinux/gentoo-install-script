emerge app-eselect/eselect-repository
eselect gcc set 2
eselect repository enable benzene-overlay gentoo-zh haskell mv lto-overlay ssnb edgets
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