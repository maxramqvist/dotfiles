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
      ./wayland-wm-de.nix
      ./9310.nix
    ];

  system.stateVersion = "21.11"; # You know.

  # Fonts
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      nerdfonts
      siji
    ];
  };

  # Enable OpenGL
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  services.printing = {
    enable = true;
    browsing = true;
    browsedConf = ''
      BrowseDNSSDSubTypes _cups,_print
      BrowseLocalProtocols all
      BrowseRemoteProtocols all
      CreateIPPPrinterQueues All

      BrowseProtocols all
    '';
  };
  services.avahi = {
    enable = true;
    nssmdns = true;
  };


  security.rtkit.enable = true;

  # Using pipewire for screen sharing on chromium apps (Slack, VSCode) and bluetooth.
  # START Bluetooth headset stuff
  # ...stuff that might be needed for best possible bluetooth headset (AirPods Pro) support on 
  # Linux. Which is pretty poor. At best good audio, terrible mic.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    media-session.config.bluez-monitor.rules = [
      {
        # Matches all cards
        matches = [{ "device.name" = "~bluez_card.*"; }];
        actions = {
          "update-props" = {
            "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
            # mSBC is not expected to work on all headset + adapter combinations.
            "bluez5.msbc-support" = true;
            # SBC-XQ is not expected to work on all headset + adapter combinations.
            "bluez5.sbc-xq-support" = true;
          };
        };
      }
      {
        matches = [
          # Matches all sources
          { "node.name" = "~bluez_input.*"; }
          # Matches all outputs
          { "node.name" = "~bluez_output.*"; }
        ];
        actions = {
          "node.pause-on-idle" = false;
        };
      }
    ];
  };

  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull; # Not sure about this one.
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket"; # Bluetooth codecs/headset support: A2DP Sink
      };
    };
  };
  services.blueman.enable = true; # manage bluetooth devices from CLI https://nixos.wiki/wiki/Bluetooth 
  # STOP Bluetooth headset stuff

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.max = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "docker" "audio" ];
  };
  security.sudo.wheelNeedsPassword = false;
  nixpkgs.config.allowUnfree = true;


}

