{ config, pkgs, lib, ... }:

let
  digicert = builtins.fetchurl {
    url = "https://cacerts.digicert.com/DigiCertTLSRSASHA2562020CA1-1.crt.pem";
  };
  workPkgs = with pkgs; [
    #azure-cli
    temporal
    nomad
    minio-client
    consul
    terraform
    vault
    openssl
    teams
    gnumake
    docker-compose
    ansible
    wireshark
  ];
in
{
  # Make sure digicert are trusted in OS cert store
  security.pki.certificateFiles = [ digicert ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # aliza - to look att MR files
    btop
    coreutils
    curl
    dig
    dracula-theme
    font-manager
    git
    go_1_18
    gcc
    handlr
    jq
    # yq - broken 2022-04-07
    libreoffice
    lsof
    lua5_1
    mpv # Add mpv config to nix config: https://nixos.wiki/wiki/Accelerated_Video_Playback
    nodejs-16_x
    python310
    ripgrep
    shellcheck
    spotify
    slack
    unzip
    unrar
    youtube-dl
    vscode
    nixpkgs-fmt
    wget
    # zsh
    zsh
    zsh-z
    # pulseaudio + bluetooth
    pavucontrol
    pulsemixer
    programmer-calculator
  ] ++ workPkgs;

}

