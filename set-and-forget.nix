{ config, pkgs, lib, ... }:
{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # # Try to remove tearing - didnt work:
  # boot.kernelParams = [ "i915.enable_psr=0" ]; 

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Disable IPv6
  boot.kernelParams = [ "ipv6.disable=1" ];
  networking.enableIPv6 = false;


  # Network
  programs.nm-applet.enable = true;

  # Generate an immutable /etc/resolv.conf from the nameserver settings
  # above (otherwise DHCP overwrites it):
  environment.etc."resolv.conf" = with lib; with pkgs; {
    source = writeText "resolv.conf" ''
      ${concatStringsSep "\n" (map (ns: "nameserver ${ns}") config.networking.nameservers)}
      options edns0
    '';
  };
  networking = {

    ## Trying to set the defined DNS servers as the ONLY DNS servers, but with the config below the
    ## DNS servers from DHCP are appended to the list after the defined DNS servers
    # resolvconf.enable = false; # Cannot enable because of some Nix conflict.

    # resolvconf.dnsExtensionMechanism = false; # Doesn't remove the DHCP recieved DNS servers
    nameservers = [
      # We get these nameservers + whatever DHCP sets.
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

  # SSD stuff
  boot.kernel.sysctl = {
    "vm.swappiness" = 1;
  };
  services.fstrim.enable = true; # trim unused blocks - supposed to prolong ssd life?

  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';

  # Power management
  powerManagement = {
    cpuFreqGovernor = lib.mkDefault "powersave";
    powertop.enable = true;
  };

  # Disable Nvidia
  hardware.nvidiaOptimus.disable = lib.mkDefault true;
  boot.blacklistedKernelModules = lib.mkDefault [ "nouveau" "nvidia" ];

  services.tlp.enable = true; # TLP’s default settings are already optimized for battery life and implement Powertop’s recommendations out of the box. So you may just install and forget it.
  # END Power management

  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  services.fwupd.enable = true;
}

