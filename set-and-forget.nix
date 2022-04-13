{ config, pkgs, lib, ... }:
{
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Disable IPv6
  boot.kernelParams = [ "ipv6.disable=1" ];
  networking.enableIPv6 = false;

  # Fix function-key and set to F1x-mode default, not function keys ffs...
  boot.extraModprobeConfig = '' 
    options hid_apple fnmode=0
  '';

  # Network
  programs.nm-applet.enable = true; # the little network chooser icon in tray

  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };

  # Generate an immutable /etc/resolv.conf from the nameserver settings
  # above (otherwise DHCP overwrites it):
  # environment.etc."resolv.conf" = with lib; with pkgs; {
  #   source = writeText "resolv.conf" ''
  #     ${concatStringsSep "\n" (map (ns: "nameserver ${ns}") config.networking.nameservers)}
  #     options edns0
  #   '';
  # };

  networking = {
    hostName = "9310";
    ## Trying to set the defined DNS servers as the ONLY DNS servers, but with the config below the
    ## DNS servers from DHCP are appended to the list after the defined DNS servers
    # resolvconf.enable = false; # Cannot enable because of some Nix conflict.

    # resolvconf.dnsExtensionMechanism = false; # Doesn't remove the DHCP recieved DNS servers
    # nameservers = [
    #   # We get these nameservers + whatever DHCP sets.
    #   "1.1.1.1"
    #   "9.9.9.9"
    # ];


    networkmanager = {
      enable = true;
    };
  };

  # Select internationalisation properties.
  time.timeZone = "Europe/Stockholm";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz"; # High DPI Displays.
    packages = with pkgs; [ terminus_font ];
    keyMap = "sv-latin1";
  };

  # SSD stuff
  boot.kernel.sysctl = {
    "vm.swappiness" = 1;
  };
  services.fstrim.enable = true; # trim unused blocks - supposed to prolong ssd life

  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';

  # Power management
  powerManagement = {
    powertop.enable = true;
  };
  #  services.tlp.enable = true; # TLP’s default settings are already optimized for battery life and implement Powertop’s recommendations out of the box. So you may just install and forget it.
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_SCALING_GOVERNOR_ON_AC = "performance";

      # The following prevents the battery from charging fully to
      # preserve lifetime. Run `tlp fullcharge` to temporarily force
      # full charge.
      # https://linrunner.de/tlp/faq/battery.html#how-to-choose-good-battery-charge-thresholds
      START_CHARGE_THRESH_BAT0 = 85;
      STOP_CHARGE_THRESH_BAT0 = 90;

      # 100 being the maximum, limit the speed of my CPU to reduce
      # heat and increase battery usage:
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MAX_PERF_ON_BAT = 60;
    };
  };

  # END Power management

  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  services.fwupd.enable = true;


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

}

