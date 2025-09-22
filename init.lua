-- =========================
-- init.lua برای Neovim 0.11.4+
-- =========================

-- Bootstrapping lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.api.nvim_set_keymap('n', '<F5>', ':w<CR>:terminal car % --short<CR>i<CR>', { noremap = true, silent = false })
-- =========================
-- Plugins
-- =========================
require("lazy").setup({
  { "neovim/nvim-lspconfig", lazy = false },
  { "hrsh7th/nvim-cmp", lazy = false },
  { "hrsh7th/cmp-nvim-lsp", lazy = false },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
  { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate", lazy = false },
  { "nvim-tree/nvim-tree.lua", dependencies = "nvim-tree/nvim-web-devicons", lazy = false },
  { "lewis6991/gitsigns.nvim", lazy = false },
  { "nvim-lualine/lualine.nvim", dependencies = "nvim-tree/nvim-web-devicons", lazy = false },
  { "folke/tokyonight.nvim", lazy = false },
  {
    "navarasu/onedark.nvim",
    lazy = false,  -- Load هنگام استارت
    config = function()
      require('onedark').setup {
        style = 'darker',  -- سبک تم: dark, darker, cool, deep, warm, warmer, light
        transparent = false,
      }
      require('onedark').load()
    end
  },
  {
    "windwp/nvim-autopairs",
    lazy = false,
    config = function()
    require("nvim-autopairs").setup({
        check_ts = true,        -- هماهنگی با treesitter
        enable_check_bracket_line = true,
    })
    end
  },
    {
      "MeanderingProgrammer/markdown.nvim",
      ft = "markdown",
      config = function()
        require("markdown").setup({})
      end,
    } 
})

-- =========================
-- General Settings
-- =========================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.wrap = false

-- =========================
-- Treesitter
-- =========================
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "cpp", "python", "go", "javascript", "typescript", "lua", "html", "css", "bash", "vue", "php" },
  highlight = { enable = true },
  indent = { enable = true },
}

vim.keymap.set({"n", "i"}, "<Home>", function()
  local col = vim.fn.col(".")
  local first_non_blank = vim.fn.col("'^")
  if col == first_non_blank then
    return "<Home>"
  else
    return "0^"
  end
end, {expr = true, noremap = true})


-- =========================
-- LSP Setup
-- =========================
local lspconfig = require('lspconfig')

-- Python
lspconfig.pyright.setup{}

-- Go
lspconfig.gopls.setup{}

-- C++
lspconfig.clangd.setup{}

-- TypeScript / JS / JSX / TSX
lspconfig.ts_ls.setup{}

-- Vue
lspconfig.volar.setup{}

-- HTML / CSS
lspconfig.html.setup{}
lspconfig.cssls.setup{}

-- Lua
lspconfig.lua_ls.setup{
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = {'vim'} },
      workspace = { library = vim.api.nvim_get_runtime_file("", true) },
      telemetry = { enable = false },
    }
  }
}

-- Bash
lspconfig.bashls.setup{}

-- PHP
lspconfig.intelephense.setup{}

-- =========================
-- nvim-cmp Setup
-- =========================
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  })
})

-- =========================
-- NvimTree
-- =========================
require'nvim-tree'.setup {
  view = { width = 30, side = 'left' },
  filters = { dotfiles = false },
}
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- =========================
-- GitSigns
-- =========================
require('gitsigns').setup()

-- =========================
-- Lualine
-- =========================
require('lualine').setup {
  options = { theme = 'tokyonight', section_separators = '', component_separators = '' }
}

-- =========================
-- مفید Keymaps
-- =========================
vim.keymap.set('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>a', { noremap = true, silent = true })
vim.keymap.set('n', '<C-w>', ':bd<CR>', { noremap = true, silent = true })

