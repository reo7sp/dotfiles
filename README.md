# dotfiles

My config files:

- zsh: [config.zsh](./home/dot_config/zsh/config.zsh), [zsh_plugins.txt](./home/dot_zsh_plugins.txt).
- vim: [init.lua](./home/dot_config/nvim/init.lua), [neovintageousrc](./home/dot_neovintageousrc), [ideavimrc](./home/dot_ideavimrc), [vscodevimrc](./home/dot_vscodevimrc).
- ranger: [rc.conf](./home/dot_config/ranger/rc.conf).
- tmux: [tmux.conf](./home/dot_tmux.conf).
- kitty: [kitty.conf](./home/dot_config/kitty/kitty.conf).
- sublime text: [sublime-dotfiles repo](https://github.com/reo7sp/sublime-dotfiles?tab=readme-ov-file#sublime-dotfiles).

<br>

How zsh looks:

![zsh screenshot](https://i.imgur.com/m7jOpKB.png)

How vim looks:

![vim screenshot](https://i.imgur.com/gkvmdvC.png)


## How to install

### Step 1: Download

macOS:

```sh
brew install chezmoi

chezmoi init reo7sp
```

Linux:

```sh
sudo apt-get install chezmoi # Debian/Ubuntu
sudo dnf install chezmoi     # Fedora

chezmoi init reo7sp
```

> If the repository was cloned manually:
>
> ```sh
> git clone https://github.com/reo7sp/dotfiles.git
> cd dotfiles
> chezmoi --source . init
> ```

### Step 2: Apply

```sh
chezmoi apply
```


## Usage

Import:

```sh
chezmoi re-add
```

Install:

```sh
chezmoi status
chezmoi apply
```

Upgrade:

```sh
upgrade-edit-zsh
upgrade-edit-vim
```

List files:

```sh
chezmoi managed
```
