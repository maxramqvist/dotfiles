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
