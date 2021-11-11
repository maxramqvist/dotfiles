{ config, pkgs, lib, ... }:
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    aliza
    ansible_2_11
    chromium
    coreutils
    curl
    dig
    docker-compose
    dracula-theme
    feh
    firefox
    git
    go
    gcc
    jq
    lsof
    mpv # Add mpv config to nix config: https://nixos.wiki/wiki/Accelerated_Video_Playback
    nodejs-16_x
    python310 
    ripgrep
    slack
    spotify
    teams
    tree
    unzip
    vault
    vscode
    wget
    # work
    nomad
    consul
    terraform
    azure-cli
    openssl
    # zsh
    zsh
    zsh-z
    # pulseaudio + bluetooth
    pavucontrol
    pulsemixer
  ];

  virtualisation.docker = {
    enable = true;
  };

}

