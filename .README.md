# Dotfile repo

## How to clone
On a new machine, clone the repo as a bare repo.
```sh
git clone --bare https://github.com/ChampiYann/dotfiles $HOME/.cfg
```

Set an alias to help a little.
```sh
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```

Checkout the files in the repe.
```sh
config checkout
```

You get a conflict if some of the files already exist. Delete then or back them up and checout again.

Configure the repo not to show untracked file.
```sh
config config --local status.showUntrackedFiles no
```

## Adding new files to track
Just run the the a `config add <dotfile name>`, commit and push.
