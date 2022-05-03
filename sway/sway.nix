{ config, pkgs, lib, ... }:
let
  colorScheme = import ../color-schemes/dracula.nix;
  increaseBrightness = pkgs.writeShellScriptBin "increaseBrightness" ''
    number=$(brightnessctl get)
    if [ "$number" -ge 0 ] && [ "$number" -le 50 ]; then
      brightnessctl s +1%
    elif [ "$number" -ge 51 ] &&  [ "$number" -le 100 ]; then
      brightnessctl s +5%
    elif [ "$number" -ge 101 ] &&  [ "$number" -le $(brightnessctl max) ]; then
      brightnessctl s +10%
    fi
  '';
  decreaseBrightness = pkgs.writeShellScriptBin "decreaseBrightness" ''
      number=$(brightnessctl get)
    if [ "$number" -ge 0 ] && [ "$number" -le 51 ]; then
      brightnessctl s 1%-
    elif [ "$number" -ge 51 ] &&  [ "$number" -le 101 ]; then
      brightnessctl s 5%-
    elif [ "$number" -ge 101 ] &&  [ "$number" -le $(brightnessctl max) ]; then
      brightnessctl s 10%-
    fi
  '';
in
{

  # If your settings aren't being saved for some applications (gtk3 applications, firefox), like the size of file selection windows, or the size of the save dialog, you will need to enable dconf. 
  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;
    #gtkUsePortal = true;
    extraPortals = [
      #sway_1_6_1_pin.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-wlr
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
    #sudo su -c "echo 'on' > '/sys/bus/usb/devices/3-8.3.2/power/control'"
    #sudo su -c "echo 'on' > '/sys/bus/usb/devices/3-8.3.3/power/control'"
    sway
  '';

  home-manager.users.max.home = {
    sessionVariables = {
      GTK_THEME = "Dracula";
    };
    packages = with pkgs; [
      pamixer
      brightnessctl
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
      decreaseBrightness
      increaseBrightness
      sway-contrib.grimshot

    ];
  };
  home-manager.users.max.programs = {
    mako = {
      enable = true;
      anchor = "bottom-right";
      defaultTimeout = 20000; # ms. 0 = no timeout, keep until acknowledged
      icons = true;
      backgroundColor = "#353C4A";
      borderColor = "#6272A4";
      textColor = "#FFFFFFFF";
      progressColor = "over #5588AAFF";
      borderRadius = 0;
      borderSize = 1;
      margin = "10";
      padding = "5";

      height = 100;
      width = 300;
    };
  };
  home-manager.users.max.wayland.windowManager.sway = {
    enable = true;
    systemdIntegration = true;
    wrapperFeatures.gtk = true;
    extraConfig = ''
      include /etc/sway/config.d/*
      for_window [class="^.*"] inhibit_idle fullscreen
      for_window [app_id="^.*"] inhibit_idle fullscreen
      set $laptop eDP-1
      bindswitch --reload --locked lid:on output $laptop disable
      bindswitch --reload --locked lid:off output $laptop enable
    '';
    config = {
      terminal = "alacritty";
      input = {
        "*".xkb_layout = "se";
        "type:keyboard" = {
          repeat_delay = "350";
          repeat_rate = "40";
          xkb_options = "caps:escape";
        };
        "type:touchpad" = {
          tap = "disabled";
          natural_scroll = "disabled";
        };
        "type:pointer" = {
          # mouse
          accel_profile = "flat";
          pointer_accel = "-0.6";
        };

      };
      fonts = {
        names = [ "SauceCodePro Nerd Font Mono" ];
        style = "Regular";
        size = 12.0;
      };
      modifier = "Mod4";
      keybindings = lib.mkOptionDefault {
        "XF86MonBrightnessDown" = "exec decreaseBrightness";
        "XF86MonBrightnessUp" = "exec increaseBrightness";
        "XF86AudioRaiseVolume" = "exec pamixer -i 10";
        "XF86AudioLowerVolume" = "exec pamixer -d 10";
        "XF86AudioMute" = ''exec [[ $(pamixer --get-mute) == "true" ]] && pamixer -u || pamixer -m'';
        "Mod4+space" = "exec wofi --show drun --allow-images";
        "Mod4+Shift+space" = "exec wofi --show run";
        "Mod4+Shift+e" = "exec wofi-emoji";
        "Mod4+d" = "exec wofi --show drun --allow-images";
        "Mod4+Backspace" = "split toggle";
        "Print" = "exec grimshot copy area";
        "Control+Print" = "exec grimshot copy screen";
        "Alt+Print" = "exec grimshot save screen";
      };


      # Add colors:
      # Dracula: ported from https://github.com/dracula/i3/blob/master/.config/i3/config
      colors.focused = { border = "#6272A4"; background = "#6272A4"; text = "#F8F8F2"; indicator = "#6272A4 "; childBorder = "#6272A4"; };
      colors.focusedInactive = { border = "#44475A"; background = "#44475A"; text = "#F8F8F2"; indicator = "#44475A"; childBorder = "#44475A"; };
      colors.unfocused = { border = "#282A36"; background = "#282A36"; text = "#BFBFBF"; indicator = "#282A36"; childBorder = "#282A36"; };
      colors.urgent = { border = "#44475A"; background = "#FF5555"; text = "#F8F8F2"; indicator = "#FF5555"; childBorder = "#FF5555"; };
      colors.placeholder = { border = "#282A36"; background = "#282A36"; text = "#F8F8F2"; indicator = "#282A36"; childBorder = "#282A36"; };
      bars = [ ];
      startup = [
        { command = "waybar"; }
        { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }

      ];
      output = {
        "*" = { bg = "#000000 solid_color"; };
      };
    };
  };
}
