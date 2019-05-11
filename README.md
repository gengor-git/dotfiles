# Dotfiles and Playbooks #

These are my dotfiles together with some Ansible to make the installation
simpler. It is currently still work in progress und may be unstable to use. As
of now they are only inside my Antergos (Arch OS) Linux VM, running a i3-wm.

To use the Ansible files you need to install Ansible `sudo pacman -S ansible`
and then inside the folder run

```bash
sudo ansible-playbook -i inventory main.yml
```

Currently the playbooks only install packages and make some minor config tweaks.
The dotfiles are not yet installed automatically. I suggest you symlink them
manually. Folder structure is identially to what you find in the repo.

![Preview Terminals](screenshot1.png)

![Preview UI](screenshot2.png)


## License ##

My stuff is licensed under GPL 3.

The wallpaper is only in this repo so the scripts are working. I got it from
Alphacoders and credit goes to the respective creator.

[Alphacoders Link to wallpaper](https://wall.alphacoders.com/big.php?i=1010054)
