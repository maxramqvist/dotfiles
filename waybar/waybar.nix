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
        # "width" = 48; # Waybar width
        # Choose the order of the modules
        modules-left = [ "sway/workspaces" ];
        modules-center = [ "sway/window" ];
        modules-right = [ "pulseaudio" "custom/emoji-picker" "battery" "network" "clock" "tray" "custom/power"];
          modules = {
          "sway/workspaces" = {
            disable-scroll = true;
            disable-markup  = false;
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
            icon-size = 18;
            spacing = 8;
          };
          "clock" = {
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format-alt = "{:%Y-%m-%d %H:%M} ";
            format = "{:%H:%M} ";
          };
          # "cpu" = {
          #   format = "{usage}%  CPU";
          # };
          # "memory" = {
          #   format = "{}% ";
          # };
          # "disk" = {
          #   format = "{}% ";
          #   tooltip-format = "{used} / {total} used";
          # };
          "battery" = {
            states = {
              good = 95;
              warning = 30;
              critical = 15;
            };
            format = "{capacity}% {icon}";
            # "format-good" = ""; # An empty format will hide the module
            # "format-full" = "";
            format-icons = [ "" "" "" "" "" ];
          };
          "network" = {
            # "interface" = "wlp2s0"; # (Optional) To force the use of this interface
            "format-wifi" = "{essid} ({signalStrength}%) ";
            "format-ethernet" = "{ifname} = {ipaddr}/{cidr} ";
            "format-disconnected" = "Disconnected ⚠";
            "interval" = 7;
          };

        #   "bluetooth" = {
        #     format = "<b>{icon}</b>";
        #     format-alt = "{status} {icon}";
        #     interval = 30;
        #     format-icons = {
        #       "enabled" = "";
        #       "disabled" = "";
        #     };
        #     tooltip-format = "{}";
        #   };

          "pulseaudio" = {
            #"scroll-step" = 1;
            "format" = "{volume}% {icon}";
            "format-bluetooth" = "{volume}% {icon}";
            "format-muted" = "";
            "format-icons" = {
              "headphones" = "";
              "handsfree" = "";
              "headset" = "";
              "phone" = "";
              "portable" = "";
              "car" = "";
              "default" = ["" ""];
            };
            "on-click" = "pavucontrol";
          };
          "custom/power" = {
            format = "";
            on-click = "swaynag --border-bottom-size=3 --message-padding=8 --button-border-size=5 --button-padding=8 --background=#b0a7b8 --border-bottom=#8c78a5 --button-border=#8c78a5 --button-background=#deceed -f Roboto -t warning -m 'Power Menu Options' -b '⏻︁ Power off'  'shutdown -P now' -b '↻︁ Restart' 'shutdown -r now' -b '🛌︁ Hibernate' 'systemctl hibernate' -b '🛌︁ Hybrid-sleep' 'systemctl hybrid-sleep' -b '🛌︁ Suspend' 'systemctl suspend' -b '︁ Logout' 'swaymsg exit' -b ' Lock' 'swaylock-fancy -f Roboto'";
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