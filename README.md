# dotfiles

My config files.

_How zsh looks:_

![zsh screenshot](https://i.imgur.com/AwJoXBy.png)

_How vim looks:_

![vim screenshot](https://i.imgur.com/qnRuVqt.png)

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
./install -q vim zsh
```

## Help

```sh
./install [-q] MODULES    — installs dotfiles
```
```sh
./update [-q] MODULES     — updates dotfiles
```

Available modules: `zsh`, `vim`, `git`.
