
{ config, lib, pkgs, vimUtils, ... }:

/*
Todo:
  - [ ] goto definition
  - [x] hur söka kod? <Leader>fg
  - [x] autocomplete, både från lokala variabler och från libbar: nvim-cmp
  - [ ] copy paste genom global clipboard
  - [ ] tema
*/

let
  colorScheme = import ../color-schemes/campbell.nix;

  # installs a vim plugin from git with a given tag / branch
  pluginGit = ref: repo: pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
    };
  };

  # always installs latest version
  plugin = pluginGit "HEAD";
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
    withPython3 = true;
    vimdiffAlias = true;
    extraConfig = ''
      luafile $HOME/dotfiles/nvim/config.lua
      luafile $HOME/dotfiles/nvim/lsp.lua
      luafile $HOME/dotfiles/nvim/telescope.lua
      luafile $HOME/dotfiles/nvim/cmp.lua
      '';
    extraPackages = with pkgs; [
 
     # Requirements for treesitter
     gcc
     fd

     # extra language servers
     sumneko-lua-language-server
     terraform-lsp
     nodePackages.typescript nodePackages.typescript-language-server
     gopls
     rnix-lsp # nix lsp server
     python39
     python39Packages.python-lsp-server
    ];
    plugins = with pkgs.vimPlugins; [

      (plugin "nvim-treesitter/nvim-treesitter")
      (plugin "projekt0n/github-nvim-theme")
      # Tree-sitter with all grammars
#      (pkgs.vimPlugins.nvim-treesitter.withPlugins (
#        plugins: pkgs.tree-sitter.allGrammars)
#        ) # improved syntax highlighting, all grammars installed the NixOS way

      # sane setup for language servers
      nvim-lspconfig

      # autocomplete with nvim-cmp
      cmp-buffer
      cmp-nvim-lsp
      nvim-cmp

      # snippets
      luasnip
      cmp_luasnip

      # Language support
      vim-terraform           # terraform ftw
      vim-nix                 # vim syntax for nix ftw
      vim-go                  # lets go!

      # find stuff
      telescope-nvim
      telescope-fzf-native-nvim
      
      # Filebrowser
      nerdtree                # tree explorer
      nerdtree-git-plugin     # shows files git status on the NerdTree
      
      nvim-web-devicons     # icons for filebrowser, not sure how to enable in nerdtree
      
      # status line
      lualine-nvim
    ];
  };
}
