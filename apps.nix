{ config, pkgs, lib, ... }:

let
  digicert = builtins.fetchurl {
    url = "https://cacerts.digicert.com/DigiCertTLSRSASHA2562020CA1-1.crt.pem";
  };
  slack = pkgs.slack.overrideAttrs (old: {
    #   # The flag --enable-features=UseOzonePlatform currently breaks Slack. Start hangs after message "interface 'wl_output' has no event 4"
    #   #--add-flags "--ozone-platform=wayland --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer,VaapiVideoDecoder,VaapiVideoEncoder"
    installPhase = old.installPhase + ''
      rm $out/bin/slack

      makeWrapper $out/lib/slack/slack $out/bin/slack \
        --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
        --prefix PATH : ${lib.makeBinPath [pkgs.xdg-utils]} \
        --add-flags " --enable-features=WebRTCPipeWireCapturer,VaapiVideoDecoder,VaapiVideoEncoder"
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
  workPkgs = with pkgs; [
    temporal
    nomad
    minio-client
    consul
    terraform
    azure-cli
    vault
    openssl
    teams
    gnumake
    docker-compose
    ansible_2_11
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
    coreutils
    curl
    dig
    dracula-theme
    fontpreview
    git
    go_1_17
    gotop
    gcc
    jq
    yq
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
  ] ++ workPkgs;

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      features = {
        buildkit = true;
      };
    };
  };

}

