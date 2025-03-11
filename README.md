# dotfiles

My config files:

- zsh: [zsh/my.zshrc](./zsh/my.zshrc).
- vim: [vim/vimrc](./vim/vimrc).
- sublime text: [sublime-dotfiles repo](https://github.com/reo7sp/sublime-dotfiles?tab=readme-ov-file#sublime-dotfiles).
- git: [git/install](./git/install).

<br>

_How zsh looks:_

![zsh screenshot](https://i.imgur.com/h92FoM8.png)

_How vim looks:_

![vim screenshot](https://i.imgur.com/ppNapnR.png)

## How to install

```sh
git clone --depth 1 https://github.com/reo7sp/dotfiles
cd dotfiles
./install
```

## How to install quick

```sh
git clone --depth 1 https://github.com/reo7sp/dotfiles
cd dotfiles
./install -q zsh vim
```

## Help

```sh
./install [-q] MODULES    — installs dotfiles
```
```sh
./update [-q] MODULES     — updates dotfiles
```

Available modules: `zsh`, `vim`, `git`.

## Tips and tricks

See [README_TIPS_AND_TRICKS.md](./README_TIPS_AND_TRICKS.md).
