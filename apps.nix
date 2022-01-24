{ config, pkgs, lib, ... }:

let
  digicert = builtins.fetchurl {
    url = "https://cacerts.digicert.com/DigiCertTLSRSASHA2562020CA1-1.crt.pem";
  };
  slack = pkgs.slack.overrideAttrs (old: {
    installPhase = old.installPhase + ''
      rm $out/bin/slack

      makeWrapper $out/lib/slack/slack $out/bin/slack \
        --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
        --prefix PATH : ${lib.makeBinPath [pkgs.xdg-utils]} \
        --add-flags "--ozone-platform=wayland --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer,VaapiVideoDecoder,VaapiVideoEncoder"
    '';
  });
    teams = pkgs.teams.overrideAttrs (old: {
    installPhase = old.installPhase + ''
      rm $out/bin/teams

      makeWrapper $out/opt/teams/teams $out/bin/teams \
        --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
        --prefix PATH : ${lib.makeBinPath [pkgs.xdg-utils]} \
        --add-flags "--ozone-platform=wayland --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer,VaapiVideoDecoder,VaapiVideoEncoder"
    '';
  });
in
{
  # Make sure digicert are trusted in OS cert store
  security.pki.certificateFiles = [ digicert ];

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
    gnumake
    go_1_17
    gcc
    jq
    yq
    lsof
    lua5_1
    mpv # Add mpv config to nix config: https://nixos.wiki/wiki/Accelerated_Video_Playback
    minio-client
    nodejs-16_x
    python310
    ripgrep
    shellcheck
    sshfs
    slack
    spotify
    teams
    tree
    remmina
    unzip
    vault
    vscode
    wget
    webcamoid
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

