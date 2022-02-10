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
  home-manager.users.max.home = {
    sessionVariables = {
      GTK_THEME = "Dracula";
    };
    packages = [
      decreaseBrightness
      increaseBrightness
      pkgs.sway-contrib.grimshot
      pkgs.swaylock-fancy
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
        "Mod4+Escape" = "exec swaylock -C $HOME/dotfiles/sway/swaylock.config";
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
        { command = "swayidle -w timeout 900 'swaylock -C $HOME/dotfiles/sway/swaylock.config' timeout 900 'swaymsg \"output * dpms off\"' resume 'swaymsg \"output * dpms on\"'"; }
        # { command = "if grep -q open /proc/acpi/button/lid/LID0/state; then echo 'Locket öppet..'; else echo 'Locket stängt'; fi"; }
      ];
      output = {
        # Set wallpaper
        #"*" = { bg = "/home/max/dotfiles/bg/jupiter-PIA23444.jpg fill #000000"; };
        "*" = { bg = "#000000 solid_color"; };
      };
    };
  };
}
