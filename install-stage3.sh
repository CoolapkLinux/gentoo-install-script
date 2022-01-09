emerge plasma-meta gnome-shell gdm gnome-terminal firefox libreoffice-bin app-i18n/fcitx5 app-i18n/fcitx5-chinese-addons app-i18n/fcitx5-gtk app-i18n/fcitx5-qt gentoolkit gentoo-zsh-completions net-im/skypeforlinux sys-apps/bleachbit sys-apps/irqbalance  --autounmask-write
yes | etc-update --automode -3
emerge plasma-meta gnome-shell gdm gnome-terminal firefox libreoffice-bin app-i18n/fcitx5 app-i18n/fcitx5-chinese-addons app-i18n/fcitx5-gtk app-i18n/fcitx5-qt gentoolkit gentoo-zsh-completions net-im/skypeforlinux sys-apps/bleachbit sys-apps/irqbalance  --autounmask-write
yes | etc-update --automode -3
emerge plasma-meta firefox gnome-light libreoffice-bin app-i18n/fcitx5 app-i18n/fcitx5-chinese-addons app-i18n/fcitx5-gtk app-i18n/fcitx5-qt virt-manager gentoolkit gentoo-zsh-completions net-im/skypeforlinux sys-apps/bleachbit sys-apps/irqbalance 
curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v
cp /home/AdGuardHome.yaml /opt/AdGuardHome/AdGuardHome.yaml
rc-update add libvirtd irqbalance
cp -r /home/github/file/win /usr/share/fonts
fc-cache
