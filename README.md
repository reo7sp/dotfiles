# dotfiles

My config files:

- zsh: [zsh/my.zshrc](./zsh/my.zshrc), [zsh/zsh_plugins.txt](./zsh/zsh_plugins.txt).
- vim: [vim/nvim/init.lua](./vim/nvim/init.lua), [vim/neovintageousrc](./vim/neovintageousrc), [vim/ideavimrc](./vim/ideavimrc), [vim/vscodevimrc](./vim/vscodevimrc).
- ranger: [ranger/rc.conf](./ranger/rc.conf).
- tmux: [tmux/tmux.conf](./tmux/tmux.conf).
- rg: [rg/ripgreprc](./rg/ripgreprc).
- htop: [htop/htoprc](./htop/htoprc).
- kitty: [kitty/kitty.conf](./kitty/kitty.conf).
- git: [git/install](./git/install).
- sublime text: [sublime-dotfiles repo](https://github.com/reo7sp/sublime-dotfiles?tab=readme-ov-file#sublime-dotfiles).

<br>

How zsh looks:

![zsh screenshot](https://i.imgur.com/m7jOpKB.png)

How vim looks:

![vim screenshot](https://i.imgur.com/gkvmdvC.png)

## How to install

```sh
git clone --depth 1 https://github.com/reo7sp/dotfiles
cd dotfiles
./install zsh vim ranger tmux rg htop
```

## How to install quick

```sh
git clone --depth 1 https://github.com/reo7sp/dotfiles
cd dotfiles
./install -q zsh vim ranger tmux rg htop
```

## Help

```sh
./install [-q] MODULES    # installs dotfiles
```
```sh
./update [-q] MODULES     # updates dotfiles
```
```sh
./upgrade [-q] MODULES    # upgrades modules' plugins
```

Available modules: `zsh`, `vim`, `ranger`, `tmux`, `rg`, `htop`, `kitty`, `git`.
