{ config, pkgs, fontSize, ... }:

let
  #colorScheme = import ../color-schemes/campbell.nix;
  #colorScheme = import ../color-schemes/dracula.nix;
  colorScheme = import ../color-schemes/github_default_dark.nix; # https://github.com/projekt0n/github-nvim-theme/blob/main/extras/alacritty/dark_default.yml
in
{
  home-manager.users.max.programs = {
    alacritty = {
      enable = true;
      settings = {
        live_config_reload = true;
        env.TERM = "alacritty";
        shell.program = "${pkgs.zsh}/bin/zsh";
        selection.save_to_clipboard = false;
        url = {
          launcher = "open";
          modifiers = "shift";
        };
        mouse_bindings = [
          {
            mouse = "Middle";
            action = "ClearSelection";
          }
        ];
        window = {
          opacity = 1;
        };
        bell = {
          animation = "EaseOutExpo";
          duration = 10;
          color = "#6272A4";
        };
        cursor = {
          style = "Block";
          unfocused_hollow = true;
        };
        font = {
          use_thin_strokes = true;
          offset = {
            x = 0;
            y = 0;
          };
          glyph_offset = {
            x = 0;
            y = 0;
          };
          size = 12;
          normal = {
            family = "JetBrainsMono Nerd Font";
            style = "Medium";
          };
          bold = {
            family = "JetBrainsMono Nerd Font";
            style = "Bold";
          };
          italic = {
            family = "JetBrainsMono Nerd Font";
            style = "Italic";
          };
          bold_italic = {
            family = "JetBrainsMono Nerd Font";
            style = "Bold Italic";
          };
        };
        window = {
          decorations = "full";
          padding = {
            x = 5;
            y = 5;
          };
        };
        draw_bold_text_with_bright_colors = true;
        colors = {
          name = colorScheme.name;
          primary = {
            background = colorScheme.background;
            foreground = colorScheme.foreground;
          };
          normal = {
            black = colorScheme.black;
            red = colorScheme.red;
            green = colorScheme.green;
            yellow = colorScheme.yellow;
            blue = colorScheme.blue;
            magenta = colorScheme.magenta;
            cyan = colorScheme.cyan;
            white = colorScheme.white;
          };
          bright = {
            black = colorScheme.blackBright;
            red = colorScheme.redBright;
            green = colorScheme.greenBright;
            yellow = colorScheme.yellowBright;
            blue = colorScheme.blueBright;
            magenta = colorScheme.magentaBright;
            cyan = colorScheme.cyanBright;
            white = colorScheme.whiteBright;
          };
        };
      };
    };
  };
}

