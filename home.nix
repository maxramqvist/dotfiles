{ config, lib, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports =
    [
      (import "${home-manager}/nixos")
      ./alacritty/alacritty.nix
      ./waybar/waybar.nix
      ./sway/sway.nix
      ./nvim/nvim.nix
    ];
  # Home Manager
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users.max = {
    home.packages = [
      pkgs.bat
      pkgs.kanshi
    ];
    gtk = {
      enable = true;
      iconTheme = {
        name = "Qogir";
      };
      theme = {
        name = "Dracula";
      };
      font = {
        name = "UbuntuMono Nerd Font";
        size = 12;
      };
    };
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/https" = "chromium.desktop";
        "x-scheme-handler/chrome" = "chromium.desktop";
        "text/html" = "chromium.desktop";
        "application/x-extension-htm" = "chromium.desktop";
        "application/x-extension-html" = "chromium.desktop";
        "application/x-extension-shtml" = "chromium.desktop";
        "application/xhtml+xml" = "chromium.desktop";
        "application/x-extension-xhtml" = "chromium.desktop";
        "application/x-extension-xht" = "chromium.desktop";
        "x-scheme-handler/msteams" = "teams.desktop";
      };
      associations.added = {
        "x-scheme-handler/https" = "chromium.desktop";
        "x-scheme-handler/chrome" = "chromium.desktop";
        "text/html" = "chromium.desktop";
        "application/x-extension-htm" = "chromium.desktop";
        "application/x-extension-html" = "chromium.desktop";
        "application/x-extension-shtml" = "chromium.desktop";
        "application/xhtml+xml" = "chromium.desktop";
        "application/x-extension-xhtml" = "chromium.desktop";
        "application/x-extension-xht" = "chromium.desktop";
      };

    };
    services = {
      kanshi = {
        enable = true;
        profiles = {
          bara_laptop = {
            outputs = [
              {
                criteria = "eDP-1";
                status = "enable";
                position = "0,0";
              }
            ];
          };
          jobbet = {
            outputs = [
              {
                criteria = "eDP-1";
                status = "disable";
              }
              {
                criteria = "Unknown HP Z27n G2 6CM8060FV2";
                status = "enable";
                position = "0,0";
              }
            ];
          };
          hemma = {
            outputs = [
              {
                criteria = "eDP-1";
                status = "disable";
              }
              {
                criteria = "Unknown HP Z27n G2 6CM80602TX";
                status = "enable";
                position = "0,0";
              }
            ];
          };
        };
      };
    };
    programs = {
      chromium = {
        enable = true;
        commandLineArgs = [ "--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer,VaapiVideoDecoder,VaapiVideoEncoder" "--ozone-platform=wayland" ];
        extensions = [
          #         { id = "hdokiejnpimakedhajhdlcegeplioahd"; } # lastpass
        ];
      };
      foot = {
        enable = true;
        server = {
          enable = true;
        };
        settings = {
          main = {
            font = "UbuntuMono Nerd Font:size=14";
            dpi-aware = "yes";
          };
          cursor = {
            color = "eeeeee 9f515a";
          };
          colors = {
            foreground = "dbdee9";
            background = "0e1420";
            regular0 = "5b6272";
            regular1 = "bf616a";
            regular2 = "a3be8c";
            regular3 = "ebcb8b";
            regular4 = "81a1c1";
            regular5 = "b48ead";
            regular6 = "88c0d0";
            regular7 = "e5e9f0";
            bright0 = "4c566a";
            bright1 = "bf616a";
            bright2 = "a3be8c";
            bright3 = "ebcb8b";
            bright4 = "81a1c1";
            bright5 = "b48ead";
            bright6 = "8fbcbb";
            bright7 = "eceff4";
          };
          mouse = {
            hide-when-typing = "yes";
          };
        };
      };
      git = {
        enable = true;
        userName = "maxramqvist";
        userEmail = "max.ramqvist@gmail.com";
      };
      starship = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          add_newline = false;
          character = {
            success_symbol = "[➜](bold green)";
            error_symbol = "[➜](bold red)";
          };
        };
      };
      zsh = {
        enable = true;
        autocd = true;
        enableAutosuggestions = true;
        enableCompletion = true;
        enableSyntaxHighlighting = true;
        shellAliases = {
          tf = "terraform";
          aw = "$HOME/git/aw/tooling-awesome-cli-js/bin/run";
          awl = "AWESOME_API=http://localhost:5050 $HOME/git/aw/tooling-awesome-cli-js/bin/run";
          v = "nvim";
          ip = "ip --color";
          ssh = "TERM=xterm-256color ssh";
          swaylock = "swaylock -C $HOME/dotfiles/sway/swaylock.config";
          cat = "bat -pp";
        };
        initExtraBeforeCompInit = ''
          [ -f ~/zshrc ] && source ~/zshrc
          unalias z 2> /dev/null
          z() {
            [ $# -gt 0 ] && _z "$*" && return
            cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "''${*##-* }" | sed 's/^[0-9,.]* *//')"
          }
          zstyle ':completion:*' menu select
        '';
        history = {
          size = 10000;
          ignoreDups = true;
          extended = true;
          share = true;
        };
        oh-my-zsh = {
          enable = true;
          plugins = [
            "git"
            "z"
          ];
        };
      };
      fzf = {
        enable = true;
        enableZshIntegration = true;
      };
    };
  };
}
