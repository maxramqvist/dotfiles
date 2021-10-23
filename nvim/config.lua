local opt = vim.opt
local g = vim.g

vim.cmd [[ 
  filetype plugin indent on
  " On pressing tab, insert 2 spaces
  set expandtab
  " show existing tab with 2 spaces width
  set tabstop=2
  set softtabstop=2
  " when indenting with '>', use 2 spaces width
  set shiftwidth=2
]]

--Treesitter setup
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    ignore_install = { "c" }, -- List of parsers to ignore installing
    disable = { "c", "rust" },  -- list of language that will be disabled
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
