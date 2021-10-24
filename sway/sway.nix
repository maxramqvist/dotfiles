{ config, pkgs, lib, ... }:
{
  home-manager.users.max.home = {
    file = {
      ".cache/backgrounds/leaves.jpg".source = ../bg/leaves.jpg;
    };
    sessionVariables = {
      GTK_THEME = "Dracula";
    };
  };
  home-manager.users.max.wayland.windowManager.sway = {
      enable = true;
      package = pkgs.sway;
      xwayland = false;
      systemdIntegration = true;
      wrapperFeatures.gtk = true;
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

        modifier = "Mod4";
        # Inherit defaults but add overrides to keybindings
        keybindings = lib.mkOptionDefault {
          "Mod4+space" = "exec wofi --show drun --allow-images";
          "Mod4+Shift+space" = "exec wofi --show run";
          "Mod4+Shift+e" = "exec wofi-emoji";
        };

        
      # Add colors:
      # Dracula: ported from https://github.com/dracula/i3/blob/master/.config/i3/config
      colors.focused          = { border = "#6272A4"; background = "#6272A4"; text = "#F8F8F2"; indicator = "#6272A4 "; childBorder = "#6272A4";  };
      colors.focusedInactive  = { border = "#44475A"; background = "#44475A"; text = "#F8F8F2"; indicator = "#44475A"; childBorder = "#44475A";  };
      colors.unfocused        = { border = "#282A36"; background = "#282A36"; text = "#BFBFBF"; indicator = "#282A36"; childBorder = "#282A36";  };
      colors.urgent           = { border = "#44475A"; background = "#FF5555"; text = "#F8F8F2"; indicator = "#FF5555"; childBorder = "#FF5555";  };
      colors.placeholder      = { border = "#282A36"; background = "#282A36"; text = "#F8F8F2"; indicator = "#282A36"; childBorder = "#282A36";  };
      bars = [ ];
      startup = [
        # Status bar: waybar
        { command = "waybar"; }
        { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
        { command = "swayidle -w timeout 1800 'swaylock' timeout 1805 'swaymsg \"output * dpms off\"' resume 'swaymsg \"output * dpms on\"'"; }
      ];

      # Probably replace output with Kanshi
      output = {
        # Set wallpaper
        "*" = { bg = "/home/max/.cache/backgrounds/leaves.jpg fill #000000"; };

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
