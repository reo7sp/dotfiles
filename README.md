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

### Step 1: Install chezmoi

macOS:

```sh
brew install chezmoi
```

Linux:

```sh
sudo apt-get install chezmoi # Debian/Ubuntu
sudo dnf install chezmoi     # Fedora
```

### Step 2: Install dotfiles

```sh
chezmoi init reo7sp
```

> If the repository was cloned manually:
>
> ```sh
> git clone https://github.com/reo7sp/dotfiles.git
> cd dotfiles
> chezmoi --source . init
> ```

### Step 3: Apply

```sh
chezmoi apply
```


## Usage

Import dotfiles:

```sh
chezmoi cd
chezmoi re-add
```

Install dotfiles:

```sh
chezmoi cd
git fetch
git reset --hard origin/master
chezmoi status
chezmoi apply
```

Upgrade plugins:

```sh
upgrade-edit-zsh
upgrade-edit-vim
```

List dotfiles:

```sh
chezmoi managed
```
