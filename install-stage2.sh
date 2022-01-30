# 准备环境
source /etc/profile 
export PS1="(chroot) ${PS1}"

# 启用fyn的特殊选项
echo "if you are fyn?[y/N]"
read fyn
clear

# 建立efi目录
mkdir -p /boot/efi /var/tmp/portage
if [$fyn == "y" -o $fyn == "yes"]
then
    rm -f /etc/fstab
    cp /home/fstab /etc/fstab
else
    echo "Now exit the fstab(Suppose your memory is greater than 8G)"
    nano -w /etc/fstab
    echo "tmpfs                   /var/tmp/portage        tmpfs           defaults,rw,nodev,nosuid,size=5G,noatime    0 0" >> /etc/fstab
fi
clear

# 挂载所有分区
mount -a

# 更新镜像
if [$fyn == "y" -n $fyn == "yes"]
then
    mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf
    emerge-websync
fi
emerge --sync

# 建立notmpfs目录
mkdir -p /var/tmp/notmpfs
# 设置notmpfs目录
cat>>/etc/portage/package.env<<EOF
app-office/libreoffice		notmpfs.conf
dev-lang/ghc			notmpfs.conf
dev-lang/mono			notmpfs.conf
dev-lang/rust			notmpfs.conf
dev-lang/spidermonkey		notmpfs.conf
mail-client/thunderbird		notmpfs.conf
sys-devel/gcc			notmpfs.conf
www-client/chromium		notmpfs.conf chromium
www-client/firefox		notmpfs.conf
net-im/telegram-desktop         notmpfs.conf
www-client/librewolf            notmpfs.conf
EOF
echo "PORTAGE_TMPDIR=\"/var/tmp/notmpfs\"" > /etc/portage/env/notmpfs.conf

# 选择init
cat <<EOF
Which init would you like to use:
1)openrc     2)systemd
EOF
echo "Enter the nember before you choose(openrc is default):"
read init

# 选择桌面环境
cat <<EOF
Which desktop would you like to use:
1)plasma     2)gnome     3)xfce     4)server
PS: if you want to use both gnome and kde, please choose 2
EOF
echo "Enter the nember before you choose(plasma is default):"
read desktop

# 设置配置文件
if [${init} == "1" -o ${init} == ""]
then
    if [${desktop} == "1" -o ${desktop} == ""]
    then
        eselect profile set 'default/linux/amd64/17.1/desktop/plasma'
    elif [${desktop} == "2"
    then
        eselect profile set 'default/linux/amd64/17.1/desktop/gnome'
    elif [${desktop} == "3"]
    then
        eselect profile set 'default/linux/amd64/17.1/desktop'
    elif [${desktop} == "4"]
    then
        eselect profile set 'default/linux/amd64/17.1'
    else
        echo "wrong format"
        echo "please enter it again" && read desktop
    fi
elif [${init} == "2"] 
then
    if [${desktop} == "1" -o ${desktop} == ""]
    then
        eselect profile set 'default/linux/amd64/17.1/desktop/plasma/systemd'
    elif [${desktop} == "2"]
    then
        eselect profile set 'default/linux/amd64/17.1/desktop/gnome/systemd'
    elif [${desktop} == "3"]
    then
        eselect profile set 'default/linux/amd64/17.1/desktop/systemd'
    elif [${desktop} == "4"]
    then
        eselect profile set 'default/linux/amd64/17.1/systemd'
    else
        echo "wrong format"
        echo "please enter desktop again" && read desktop
    fi
else
    echo "wrong format"
    echo "please enter init again" && read init
fi
clear

# 创建用户并设置密码
USE="-pam" emerge -1 sysapps/shadow
echo "Set the root password"
passwd root
if [$fyn == "y" -o $fyn == "yes"]
then
    emerge zsh
    mv /home/fyn /home/fyn-1
    useradd -m -G users,wheel,audio -s /bin/zsh fyn
    rm -rf /home/fyn
    mv /home/fyn-1 /home/fyn 
    passwd fyn
else
    echo "Enter the expected username:" && read username
    useradd -m -G users,wheel,audio -s /bin/zsh $username
    passwd  $username
fi
emerge -1 sys-apps/shadow
# 配置clang和ltoize（for fyn）
if [$fyn == "y" -o $fyn == "yes"]
then
    emerge gcc
    bash fyn/thinlto.sh
    clear
fi

# 尝试自动更新系统
emerge --verbose --update --deep --newuse @world --autounmask-write
yes | etc-update --automode -3
USE="-harfbuzz" emerge --oneshot freetype
emerge --verbose --update --deep --newuse @world
emerge --depclean 
emerge -uvDN @world
emerge @preserved-rebuild
perl-cleaner --all
emerge -uvDN --with-bdeps=y @world

# 时区和语言环境
echo "Enter your timezone:"
read timezone
echo "${timezone}" >> /etc/timezone
emerge --config sys-libs/timezone-data
cat>/etc/locale.gen<<EOF
C.UTF8 UTF-8
en_US.UTF-8 UTF-8
zh_CN.UTF-8 UTF-8
zh_CN.GBK GBK
EOF
locale-gen
eselect locale set 'zh_CN.utf8'

# 配置内核
if [$fyn == "y" -o $fyn == "yes"]
then
    bash fyn/kernel.sh
else
    emerge gentoo-sources genkernel
    genkernel all
fi
emerge sys-kernel/linux-firmware 

# 配置系统
emerge sudo 
sed -i "s/# %wheel ALL=(ALL)/%wheel ALL=(ALL)/" /etc/sudoers
echo "enter hostname" && read hostname
echo "hostname=${hostname}" > /etc/conf.d/hostname
emerge sys-boot/grub
if [$fyn == "y" -o $fyn == "yes"]
then
    rm -r /root
    cp -r /home/root /root
    grub-install --target=x86_64-efi --efi-directory=/boot --removable --bootloader-id=Gentoo-fyn
else
    grub-install --target=x86_64-efi --efi-directory=/boot --removable  --bootloader-id=Gentoo
grub-mkconfig -o /boot/grub/grub.cfg
if [${init} == "1" -o ${init} == ""]
then
    emerge cronie
    rc-update add cronie
    emerge --ask --noreplace net-misc/netifrc
    nano /etc/conf.d/net
elif [${init} == "2"]
then 
    sed -i 's/\# GRUB_CMDLINE_LINUX=\"init=\/usr\/lib\/systemd\/systemd\"/GRUB_CMDLINE_LINUX=\"init=\/usr\/lib\/systemd\/systemd\"/g' /etc/default/grub
    ln -sf /proc/self/mounts /etc/mtab
    systemd-machine-id-setup
    emerge networkmanager && systemctl enable NetworkManager
fi
