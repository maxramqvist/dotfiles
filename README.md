# nix
NixOS + dotfiles setup


# Get started

1. Install NixOS
1. Set up the channels: 
```bash
 sudo nix-channel --add https://nixos.org/channels/nixpkgs-unstable
 sudo nix-channel --add https://nixos.org/channels/nixos-unstable
 sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
 sudo nix-channel --update
 nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
 nix-channel --update
```
1. Install home-manager: ```nix-shell '<home-manager>' -A install```
1. clone this repo to ~/dotfiles
1. run ```chown -R max /etc/nixos && ./link.sh``` in ~/dotfiles
1. run ```sudo nixos-rebuild switch```
1. get backups of ssh keys and such
1. enjoy
