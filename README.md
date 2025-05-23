# setup

```bash
git clone https://github.com/cdmill/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

if you're using linux you can run the install script to go through the setup wizard

```bash
./install.sh
```


Otherwise, install GNU stow and use it to store whichever config files you want and they
will be saved in `~/.config/`.

```bash
$ stow nvim
$ stow tmux
...
```
