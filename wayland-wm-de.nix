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
  # Enable and remove some unused stuff when Electron+Wayland isn't broken anymore...
  #  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.loginShellInit = ''
    [[ "$(tty)" == /dev/tty1 ]] && \
    export EDITOR=nvim && \
    export MOZ_ENABLE_WAYLAND=1 && \
    export WLR_DRM_NO_MODIFIERS=1 && \
    export SDL_VIDEODRIVER=wayland && \
    export QT_QPA_PLATFORM=wayland && \
    export QT_WAYLAND_DISABLE_WINDOWDECORATION="1" && \
    export _JAVA_AWT_WM_NONREPARENTING=1 && \
    WLR_DRM_NO_MODIFIERS=1 sway
  '';
}

