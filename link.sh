#!/bin/sh
echo "Setting up the links.."
ln -sf $(pwd)/configuration.nix /etc/nixos/configuration.nix
echo "..done."
