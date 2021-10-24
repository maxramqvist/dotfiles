{ config, pkgs, lib, ... }:
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
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
    jq
    lsof
    mpv # Add mpv config to nix config: https://nixos.wiki/wiki/Accelerated_Video_Playback
    nodejs-16_x
    powertop
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
    nomad consul terraform azure-cli
    # zsh
    zsh
    # pulseaudio + bluetooth
    pavucontrol pulsemixer 
  ];

  virtualisation.docker = {
    enable = true;
  };
  
  # virtualisation.podman = { # also add docker-compose replacement, some python script... google
  #   enable = true;
  #   dockerCompat = true;
  # };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;


}

