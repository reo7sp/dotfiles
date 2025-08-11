# dotfiles

My config files:

- zsh: [zsh/my.zshrc](./zsh/my.zshrc), [zsh/zsh_plugins.txt](./zsh/zsh_plugins.txt).
- vim: [vim/my.vimrc](./vim/my.vimrc), [vim/ideavimrc](./vim/ideavimrc), [vim/neovintageousrc](./vim/neovintageousrc).
- sublime text: [sublime-dotfiles repo](https://github.com/reo7sp/sublime-dotfiles?tab=readme-ov-file#sublime-dotfiles).
- cursor: [cursor-dotfiles repo](https://github.com/reo7sp/cursor-dotfiles?tab=readme-ov-file#cursor-dotfiles).
- ranger: [ranger/rc.conf](./ranger/rc.conf).
- kitty: [kitty/kitty.conf](./kitty/kitty.conf).
- git: [git/install](./git/install).
- rg: [rg/ripgreprc](./rg/ripgreprc).

<br>

How zsh looks:

![zsh screenshot](https://i.imgur.com/m7jOpKB.png)

How vim looks:

![vim screenshot](https://i.imgur.com/gkvmdvC.png)

## How to install

```sh
git clone --depth 1 https://github.com/reo7sp/dotfiles
cd dotfiles
./install zsh vim ranger rg
```

## How to install quick

```sh
git clone --depth 1 https://github.com/reo7sp/dotfiles
cd dotfiles
./install -q zsh vim ranger rg
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

Available modules: `zsh`, `vim`, `ranger`, `kitty`, `git`, `rg`.
