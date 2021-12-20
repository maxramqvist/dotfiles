{ config, pkgs, lib, ... }:
let
  #colorScheme = import ../color-schemes/campbell.nix;
  colorScheme = import ../color-schemes/dracula.nix;
  #colorScheme = import ../color-schemes/github_default_dark.nix; # https://github.com/projekt0n/github-nvim-theme/blob/main/extras/alacritty/dark_default.yml
  increaseBrightness = pkgs.writeShellScriptBin "increaseBrightness" ''
    number=$(brightnessctl get)
    if [ "$number" -ge 0 ] && [ "$number" -le 1000 ]; then
      brightnessctl s +200
    elif [ "$number" -ge 1001 ] &&  [ "$number" -le 10000 ]; then
      brightnessctl s +1000
    elif [ "$number" -ge 10001 ] &&  [ "$number" -le $(brightnessctl max) ]; then
      brightnessctl s +10%
    fi
  '';
  decreaseBrightness = pkgs.writeShellScriptBin "decreaseBrightness" ''
      number=$(brightnessctl get)
    if [ "$number" -ge 0 ] && [ "$number" -le 1000 ]; then
      brightnessctl s 200-
    elif [ "$number" -ge 1001 ] &&  [ "$number" -le 10000 ]; then
      brightnessctl s 1000-
    elif [ "$number" -ge 10001 ] &&  [ "$number" -le $(brightnessctl max) ]; then
      brightnessctl s 10%-
    fi
  '';
in
{
  home-manager.users.max.home = {
    sessionVariables = {
      GTK_THEME = "Dracula";
    };
    packages = [
      decreaseBrightness
      increaseBrightness
    ];
  };
  home-manager.users.max.programs = {
    mako = {
      enable = true;
      anchor = "bottom-right";
      backgroundColor = "#00000000";
      borderColor = "#4C7899FF";
      textColor = "#FFFFFFFF";
      borderRadius = 0;
      borderSize = 1;
      defaultTimeout = 20000; # ms. 0 = no timeout, keep until acknowledged
      font = "monospace 12";
      #      iconPath = ""; 
      icons = true;
    };
  };
  home-manager.users.max.wayland.windowManager.sway = {
    enable = true;
    package = pkgs.sway;
    systemdIntegration = true;
    wrapperFeatures.gtk = true;
    extraSessionCommands =
      ''
        export EDITOR=nvim
        export MOZ_ENABLE_WAYLAND=1
        export WLR_DRM_NO_MODIFIERS=1
        export SDL_VIDEODRIVER=wayland
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        export _JAVA_AWT_WM_NONREPARENTING=1
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
      };
      fonts = {
        names = [ "SauceCodePro Nerd Font Mono" ];
        style = "Regular";
        size = 12.0;
      };
      #  inhibit_idle = "fullscreen"; # inhibits swayidle (playing video or similar) when running fullscreen apps
      modifier = "Mod4";
      # Inherit defaults but add overrides to keybindings
      keybindings = lib.mkOptionDefault {
        # Brightness
        "XF86MonBrightnessDown" = "exec decreaseBrightness";
        "XF86MonBrightnessUp" = "exec increaseBrightness";
        # Volume
        "XF86AudioRaiseVolume" = "exec pamixer -i 10";
        "XF86AudioLowerVolume" = "exec pamixer -d 10";
        "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "Mod4+space" = "exec wofi --show drun --allow-images";
        "Mod4+Shift+space" = "exec wofi --show run";
        "Mod4+Shift+e" = "exec wofi-emoji";
        "Mod4+Backspace" = "split toggle";
        "Mod4+Escape" = "exec swaylock -C $HOME/dotfiles/sway/swaylock.config";
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
        # Status bar: waybar
        { command = "waybar"; }
        { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
        { command = "swayidle -w timeout 600 'swaylock -C $HOME/dotfiles/sway/swaylock.config' timeout 1800 'swaymsg \"output * dpms off\"' resume 'swaymsg \"output * dpms on\"'"; }
      ];

      # Probably replace output with Kanshi
      output = {
        # Set wallpaper
        #"*" = { bg = "/home/max/dotfiles/bg/jupiter-PIA23444.jpg fill #000000"; };
        "*" = { bg = "#000000 solid_color"; };

        # You can get the names of your outputs by running: swaymsg -t get_outputs
        eDP-1 = {
          resolution = "1920x1080";
          position = "0,0";
        };
        HDMI-A-1 = {
          resolution = "2560x1440";
          position = "1920,0";
        };
      };
    };
  };
}
