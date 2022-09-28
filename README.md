# Dotfile repo

## How to clone
On a new machine, clone the repo as a bare repo.
```sh
git clone --bare git@github.com:ChampiYann/dotfiles.git $HOME/.cfg
```
```sh
git clone --bare https://github.com/ChampiYann/dotfiles $HOME/.cfg
```

Set an alias to help a little.
```sh
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```

Checkout the files in the repo.
```sh
config checkout
```

You get a conflict if some of the files already exist. Delete then or back them up and checkout again.

Configure the repo not to show untracked file.
```sh
config config --local status.showUntrackedFiles no
```

## Adding new files to track
Just run the the a `config add <dotfile name>`, commit and push.

## Setup
Run setup scripts if needed in `.setup-scripts`

### Font
Install the fonts for powerlevel10k here: https://github.com/romkatv/powerlevel10k#manual-font-installation

Add the following snippet to the JSON config of Windows Terminal app:
```json
"font":
{
  "face": "MesloLGS NF"
}
```
Config can be added to the default profile of to the specific profile of the WSL terminal.

While you're at it, turn the bell off:
```json
"bellStyle": "none"
```

### Default shell
Set you default shell to ZSH:
```sh
sudo usermod -s /usr/bin/zsh <username>
```

## Troubleshooting
Files in `/etc/profile.d/` do not get sourced. You might have proxy settings there that are not sourced before zinit tries to connect to github.com thus failing the installation.

To fix this you can add the following line to your `/etc/zsh/zprofile` file:
```sh
emulate sh -c 'source /etc/profile'
```
*source: https://bugs.launchpad.net/ubuntu/+source/zsh/+bug/1800280/comments/7*
