{ config, pkgs, lib, ... }:
{

  # If your settings aren't being saved for some applications (gtk3 applications, firefox), like the size of file selection windows, or the size of the save dialog, you will need to enable dconf. 
  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;
    #gtkUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
    ];
  };

  programs.sway = {
    enable = true;
    wrapperFeatures = {
      gtk = true; # so that gtk works properly
      base = true; # not sure, but testing for screen sharing
    };
    extraPackages = with pkgs; [
      pamixer
      brightnessctl
      swaylock
      swayidle
      wl-clipboard
      wofi # Dmenu is the default in the config but i recommend wofi since its wayland native
      wofi-emoji
      nordic
      # sway polkit
      polkit_gnome
      # sway gtk theming
      gtk-engine-murrine
      gtk_engines
      gsettings-desktop-schemas
      lxappearance # lxappearance must be started with: "GDK_BACKEND=x11 lxappearance"
      kora-icon-theme
      arc-icon-theme
      qogir-icon-theme
    ];
  };
  environment.loginShellInit = ''
    [[ "$(tty)" == /dev/tty1 ]] && \
    export EDITOR=nvim && \
    export MOZ_ENABLE_WAYLAND=1 && \
    export WLR_DRM_NO_MODIFIERS=1 && \
    export SDL_VIDEODRIVER=wayland && \
    export QT_QPA_PLATFORM=wayland && \
    export QT_WAYLAND_DISABLE_WINDOWDECORATION="1" && \
    export _JAVA_AWT_WM_NONREPARENTING=1 && \
    sway
  '';
}

