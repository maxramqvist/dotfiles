-- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<C-y>'] = cmp.config.disable, -- If you want to remove the default `<C-y>` mapping, You can specify `cmp.config.disable` value.
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "buffer" },
  }
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- shamelessly stolen from: https://github.com/notusknot/dotfiles-nix/blob/main/config/nvim/lua/lsp.lua

-- This file sets up autocompletion for neovim's native lsp

-- This enables all the language servers I want on my system
-- Change these to whatever languages you use
require'lspconfig'.rnix.setup{
  capabilities = capabilities
}
require'lspconfig'.sumneko_lua.setup{
  capabilities = capabilities
}
require'lspconfig'.gopls.setup{
  capabilities = capabilities
}
require'lspconfig'.terraformls.setup{
  capabilities = capabilities,
  cmd = {"terraform-lsp"};
}
require'lspconfig'.tsserver.setup{
  capabilities = capabilities
}

vim.o.completeopt = "menuone,noselect"


-- Set tab to accept the autocompletion
local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end
_G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-n>"
    else
        return t "<S-Tab>"
    end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})

-- LUA below


require'lspconfig'.sumneko_lua.setup {
  cmd = {"lua-language-server"};
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        -- path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}
