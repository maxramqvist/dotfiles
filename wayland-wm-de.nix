{ config, pkgs, lib, ... }:
{

  # If your settings aren't being saved for some applications (gtk3 applications, firefox), like the size of file selection windows, or the size of the save dialog, you will need to enable dconf. 
  programs.dconf.enable = true; 

  programs.xwayland.enable = false;
  
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      mako # notification daemon
      wofi # Dmenu is the default in the config but i recommend wofi since its wayland native
      wofi-emoji nordic
      # sway polkit
      polkit_gnome
      # sway gtk theming
      gtk-engine-murrine gtk_engines gsettings-desktop-schemas lxappearance # lxappearance must be started with: "GDK_BACKEND=x11 lxappearance"
      kora-icon-theme arc-icon-theme qogir-icon-theme
    ];
  };
  environment.loginShellInit = ''
      [[ "$(tty)" == /dev/tty1 ]] && sway
    '';
}

