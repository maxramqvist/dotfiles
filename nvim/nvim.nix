
{ config, pkgs, ... }:

/*
Todo:
  - goto definition
  - hur söka kod?
  - autocomplete, både från lokala variabler och från libbar
  - copy paste genom global clipboard
  - tema
*/

let
  colorScheme = import ../color-schemes/campbell.nix;
in 

{

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];
  home-manager.users.max.programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    coc.enable = true;
    withNodeJs = true;
    vimdiffAlias = true;

    extraConfig = ''
      luafile $HOME/dotfiles/nvim/config.lua
      " source $HOME/dotfiles/nvim/github_theme.lua " https://github.com/projekt0n/github-nvim-theme
      luafile $HOME/dotfiles/nvim/lsp.lua
    '';
    extraPackages = with pkgs; [
     # Is this needed? tree-sitter
     sumneko-lua-language-server
     # Requirements for treesitter
     gcc

     # extra language servers
     terraform-lsp
     nodePackages.typescript nodePackages.typescript-language-server
     gopls
     rnix-lsp             # nix lsp server
    ];
    coc.settings = {
      languageserver = {
        "nix" = {
          "command" = "rnix-lsp";
          "filetypes" = [ "nix" ];
        };
      };
    };
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter         # improved syntax highlighting
      vim-terraform           # terraform ftw
      vim-nix                 # vim syntax for nix ftw
      vim-fugitive            # git plugin
      nerdtree                # tree explorer
      nerdtree-git-plugin     # shows files git status on the NerdTree
      nvim-web-devicons       # icons for filebrowser
      fzf-vim                 # fuzzy finder
      galaxyline-nvim         # nice statusline
      nvim-lspconfig          # configure the lsp
      nvim-compe              # complete stuff, should maybe be init before everything else?
    ];
  };
}
