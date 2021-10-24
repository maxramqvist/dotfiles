
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
    withNodeJs = true;
    vimdiffAlias = true;
    # Add theme https://github.com/projekt0n/github-nvim-theme
    extraConfig = ''
      luafile $HOME/dotfiles/nvim/config.lua
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
    coc = { # Completion server with LSP support
      enable = true; # Enable doesnt work, but settings work. https://github.com/nix-community/home-manager/issues/2386
      settings = {
        tsserver.enable = true;
        tslint.configFile = "tslint.json";
        suggest = {
          enablePreview = true;
        };
        languageserver = {
          "nix" = {
            "command" = "rnix-lsp";
            "filetypes" = [ "nix" ];
          };
          "go" = {
            "command" = "gopls";
            "rootPatterns" = ["go.mod"];
            "trace.server" = "verbose";
            "filetypes" = ["go"];
          };
        };
      };
    };
    plugins = with pkgs.vimPlugins; [
      coc-nvim                # Until coc-plugin mentioned above is fixed
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
    ];
  };
}
