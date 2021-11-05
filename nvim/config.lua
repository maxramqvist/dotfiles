local opt = vim.opt
local g = vim.g
g.mapleader = " "


vim.cmd [[
  set nowrap
  set nobackup
  set nowritebackup
  set noerrorbells
  set noswapfile
  set shortmess+=c
  set completeopt=menuone,noselect
  set number
  set termguicolors
  set background=dark
  nnoremap <C-Left> :tabprevious<CR>                                                                            
  nnoremap <C-Right> :tabnext<CR>
  nnoremap <C-Up> :tabnew<CR>
  nnoremap <C-j> :tabprevious<CR>                                                                            
  nnoremap <C-k> :tabnext<CR>
  set clipboard=unnamed,unnamedplus
]]
-- Performance
opt.lazyredraw = true
opt.updatetime = 300

-- Indentation
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.shiftround = true
opt.expandtab = true
opt.scrolloff = 3


-- Get rid of annoying viminfo file
opt.viminfo = ""
opt.viminfofile = "NONE"

opt.cmdheight = 2

-- Miscellaneous quality of life
opt.compatible = false
opt.hidden = true

require('github-theme').setup({
  theme_style = "dark_default",
--  function_style = "italic",
--  sidebars = {"qf", "vista_kind", "terminal", "packer"},

  -- Change the "hint" color to the "orange" color, and make the "error" color bright red
--  colors = {hint = "orange", error = "#ff0000"}
})
-- status line
require'lualine'.setup {
options = {
    theme = 'github',
  }
}


--Treesitter setup
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    ignore_install = { "c", "rust", "cuda", "kotlin", "fennel", "tlaplus", "cpp" }, -- List of parsers to ignore installing
    disable = { "c", "rust", "cuda", "kotlin", "fennel", "tlaplus", "cpp" },  -- list of language that will be disabled
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

