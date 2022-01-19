#!/bin/sh
echo "Ensuring /etc/nixos is owned by current user"
chown ${USER} /etc/nixos
echo "Setting up the links.."
ln -sf $(pwd)/configuration.nix /etc/nixos/configuration.nix
echo "..done."
