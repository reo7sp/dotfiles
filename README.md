# dotfiles

My config files.

_How zsh looks:_

![zsh screenshot](https://i.imgur.com/r8oyIlw.png)

_How vim looks:_

![vim screenshot](https://i.imgur.com/QfgfpMP.png)

For Sublime Text configs go to [sublime-dotfiles repo](https://github.com/reo7sp/sublime-dotfiles?tab=readme-ov-file#sublime-dotfiles).

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
