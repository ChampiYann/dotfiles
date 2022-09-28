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

### Default shell
