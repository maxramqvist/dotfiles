
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
      luafile $HOME/dotfiles/nvim/telescope.lua
      luafile $HOME/dotfiles/nvim/cmp.lua
    '';
    extraPackages = with pkgs; [
 
     # Requirements for treesitter
     gcc

     # extra language servers
     sumneko-lua-language-server
     terraform-lsp
     nodePackages.typescript nodePackages.typescript-language-server
     gopls
     rnix-lsp             # nix lsp server
    ];
    plugins = with pkgs.vimPlugins; [

      # Tree-sitter with all grammars
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (
        plugins: pkgs.tree-sitter.allGrammars)
        ) # improved syntax highlighting, all grammers installed the NixOS way
      nvim-lspconfig          # configure the lsp - needs a file that setups the language servers aswell

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

      telescope-nvim
      #fzf-vim                 # fuzzy finder - replace with telescope?
      
      # Filebrowser
      nerdtree                # tree explorer
      nerdtree-git-plugin     # shows files git status on the NerdTree
      # nvim-web-devicons     # icons for filebrowser, not sure how to enable in nerdtree
      
    ];
  };
}
