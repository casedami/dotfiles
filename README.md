# setup

```bash
git clone https://github.com/cdmill/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

I am using GNU stow to manage my dotfiles. After installing stow, use it to store
whichever config files you want and they will be saved in `~/.config/`.

```bash
$ stow nvim
$ stow tmux
...
```
