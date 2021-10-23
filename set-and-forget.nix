{ config, pkgs, lib, ... }:
{
    # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # # Try to remove tearing - didnt work:
  # boot.kernelParams = [ "i915.enable_psr=0" ]; 

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Network
  programs.nm-applet.enable = true;
  networking = {
    # FIX: This conflicts with something? OS defaults?
    # resolvconf.enable = false;
     nameservers = [
      "1.1.1.1"
      "9.9.9.9"
    ];
    hostName = "3560"; # Define your hostname.
    interfaces.enp0s31f6.useDHCP = true;
    interfaces.wlp0s20f3.useDHCP = true;
    networkmanager = {
      enable = true;
      dns = "none"; # no effect, resolvconf still generates /etc/resolv.conf
    };
  };

  # Select internationalisation properties.
  time.timeZone = "Europe/Stockholm";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "sv-latin1";
  };


  # Disable Nvidia
  hardware.nvidiaOptimus.disable = lib.mkDefault true;
  boot.blacklistedKernelModules = lib.mkDefault [ "nouveau" "nvidia" ];


  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true; # Might help wifi?
  services.tlp.enable = true;
  services.fwupd.enable = true;
}

