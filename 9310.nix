{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [
      "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/dell/xps/13-9310"
    ];

}
