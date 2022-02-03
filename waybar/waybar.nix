{ config, pkgs, lib, ... }:

{
  home-manager.users.max.home.file = {
    ".config/waybar/style.css".source = ./style.css;
  };
  home-manager.users.max.programs.waybar = {
    enable = true;
    settings = [
      {
        layer = "top"; # Waybar at top layer
        position = "bottom"; # Waybar position (top|bottom|left|right)
        height = 25; # Waybar height
        modules-left = [ "sway/workspaces" ];
        modules-center = [ "sway/window" ];
        modules-right = [
          "network"
          "pulseaudio"
          "battery"
          "tray"
          "clock"
        ];
        modules = {
          "sway/workspaces" = {
            disable-scroll = true;
            disable-markup = false;
            all-outputs = false;
            format = "  {icon}  ";
            format-icons = {
              "1" = "1";
              "2" = "2";
              "3" = "3";
              "4" = "4";
              "5" = "5";
              "6" = "6";
              "7" = "7";
              "8" = "8";
              "9" = "9";
              "10" = "10";
              "focused" = "";
              "default" = "";
            };
          };
          "tray" = {
            icon-size = 24;
            spacing = 8;
          };
          "clock" = {
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format-alt = "{:%Y-%m-%d %H:%M} ";
            format = "{:%H:%M} ";
          };
          "battery" = {
            states = {
              good = 95;
              warning = 30;
              critical = 15;
            };
            format = "{icon} {capacity}%";
            format-icons = [ "" "" "" "" "" ];
            format-charging = "{capacity}% ";
            format-plugged = "{capacity}% ";
            format-discharging = "{capacity}%🔋";
          };
          "network" = {
            "format-wifi" = " {essid} {signalStrength}%";
            "format-ethernet" = "  {bandwidthUpBits} {bandwidthDownBits}";

            "format-disconnected" = "Disconnected ⚠";
            "interval" = 2;
          };

          "bluetooth" = {
            format = "<b>{icon}</b>";
            format-alt = "{status} {icon}";
            interval = 30;
            format-icons = {
              "enabled" = "";
              "disabled" = "";
            };
            tooltip-format = "{}";
          };

          "pulseaudio" = {
            "format" = "{icon} {volume}%";
            "format-bluetooth" = "{volume}% {icon}";
            "format-muted" = "";
            "format-icons" = {
              "headphones" = "";
              "handsfree" = "";
              "headset" = "";
              "phone" = "";
              "portable" = "";
              "car" = "";
              "default" = [ "" "" ];
            };
            "on-click" = "pavucontrol";
          };
          "custom/emoji-picker" = {
            "format" = "👾";
            "tooltip" = "true";
            "tooltip-format" = "Pick an emoji and copy it to the clipboard";
            "on-click" = "wofi-emoji";
          };
        };
      }
    ];
  };
}

