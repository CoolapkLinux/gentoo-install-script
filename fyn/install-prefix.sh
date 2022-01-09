mkfs.fat -F 32 /dev/nvme0n1p1
mkfs.btrfs -f /dev/nvme0n1p2
mount /dev/nvme0n1p2 /mnt/gentoo
mkdir -p /mnt/gentoo/var/tmp
mount /dev/sda2 /mnt/gentoo/var/tmp
mkdir -p /mnt/gentoo/home
mount /dev/sda3 /mnt/gentoo/home

