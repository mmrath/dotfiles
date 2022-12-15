# Fedora 37 on mac

After installation edit /etc/default/grub file . GRUB_ENABLE_BLSCFG=false

And then run this command

grub2-mkconfig -o /boot/grub2/grub.cfg


