#!/bin/sh
echo "Setting up the links.."
ln -sf $(pwd)/configuration.nix /etc/nixos/configuration.nix
ln -sf $(pwd)/hardware.nix /etc/nixos/hardware.nix
echo "..done."
