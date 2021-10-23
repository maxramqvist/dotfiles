# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
{
  imports =
    [
      ./hardware-configuration.nix # Include the results of the hardware scan.
      ./home.nix
      ./set-and-forget.nix
      ./apps.nix
     # ./x-wm-de.nix
      ./wayland-wm-de.nix
    ];
  
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
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio = {
  #   enable = true;
  #   extraModules = [ pkgs.pulseaudio-modules-bt ]; # Bluetooth codecs/headset support
  #   package = pkgs.pulseaudioFull; # Bluetooth codecs/headset support
  # };

security.rtkit.enable = true;
services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  media-session.config.bluez-monitor.rules = [
    {
      # Matches all cards
      matches = [ { "device.name" = "~bluez_card.*"; } ];
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.max = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "docker" "audio" ];
  };
  security.sudo.wheelNeedsPassword = false;
  nixpkgs.config.allowUnfree = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?


}

