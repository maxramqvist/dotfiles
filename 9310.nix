{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [
      "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/dell/xps/13-9310"
    ];



  # For booting system with luks encrypted root on LVM
  # Reference: https://gist.github.com/martijnvermaat/76f2e24d0239470dd71050358b4d5134
  # 
  # NVME SSD:
  #   Partition 1: 512MB /boot with type EFI System and VFAT
  #   Partition 2: Luks encrypted partition containing a LVM VG:
  #      lv: swap last 8GB
  #      lv: root 100%Free mounted on / XFS 
  #
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "nodev";
    efiSupport = true;
    enableCryptodisk = true;
  };
  boot.initrd.luks.devices.luksroot = {
    allowDiscards = true;
    device = "/dev/disk/by-uuid/51fcf0f8-c905-4053-8bd7-698bcc0589a6"; # the whole partition
  };

  networking.interfaces.wlp113s0.useDHCP = true;

  networking.wireguard.enable = true;
}
