# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
{
  imports =
    [
      /etc/nixos/hardware-configuration.nix # Include the results of the hardware scan.
      ./home.nix
      ./set-and-forget.nix
      ./apps.nix
      ./9310.nix
      ./virtualisation.nix
      ./jobbhack.nix
    ];

  system.stateVersion = "21.11"; # You know.

  # Fonts
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
      noto-fonts-emoji-blob-bin
    ];
    fontconfig = {
      defaultFonts = {
        emoji = [ "Blobmoji" ];
      };
    };

  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.max = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "docker" "audio" "libvirtd" ];
  };
  security.sudo.wheelNeedsPassword = false;
  nixpkgs.config.allowUnfree = true;


}

