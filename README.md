# Dotfiles and Playbooks #

These are my dotfiles together with some Ansible to make the installation
simpler. It is currently still work in progress und may be unstable to use. As
of now they are only inside my Antergos (Arch OS) Linux VM, running a i3-wm.

## Prerequisits ##

These packages must be installed manually:

- ansible

To run the Ansible playbooks enter:

```bash
sudo ansible-playbook -i inventory main.yml
```

## Know Bugs ##

As Ansible needs a custom module which it will checkout when run. However it
does not work in that run and causes and error.

The Workaround is simply: just run the playbooks again, as that time the module
is already present in roots `.ansible` folder.

**Notice:**

The playbook will overwrite your configs with symlinks for the dotfiles. Check
the `config.dotfiles.yml` for the required files. If you do not want this at all
or just don't want the overwriting, set the matching parameters in the
`config.settings.yml` to `no`.

![Preview Terminals](screenshot1.png)

![Preview UI](screenshot2.png)

![Coding is fun](screenshot3.png)

## Manual Installs ##

- [San Francisco Font](https://github.com/supermarin/YosemiteSanFranciscoFont/)
  (put ttfs into `~/.fonts`)

## License ##

My stuff is licensed under GPL 3.

The wallpaper is only in this repo so the scripts are working. I got it from
Alphacoders and credit goes to the respective creator.

[Alphacoders Link to wallpaper](https://wall.alphacoders.com/big.php?i=1010054)
