# nix
NixOS + dotfiles setup


# Get started

1. Install NixOS with encrypted disks, look in 9310.nix
1. run passwd "max"
1. Set up the channels: 
```bash
 sudo nix-channel --add https://nixos.org/channels/nixpkgs-unstable
 sudo nix-channel --add https://nixos.org/channels/nixos-unstable
 sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
 sudo nix-channel --update
 nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
 nix-channel --update
 sudo nix-shell '<home-manager>' -A install
```
1. clone this repo to ~/dotfiles
1. run ```chown -R max /etc/nixos && ./link.sh``` in ~/dotfiles
1. run ```sudo nixos-rebuild boot```
1. reboot
1. get backups of ssh keys and such
1. enjoy
