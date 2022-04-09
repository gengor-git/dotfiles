local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn -- to call Vim functions e.g. fn.bufnr()
local g = vim.g -- a table to access global variables
local opt = vim.opt -- to set options
local map = vim.api.nvim_set_keymap -- map keys easier

-- Bootstrap Paq when needed ------------------------------------------
local install_path = fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth=1", "https://github.com/savq/paq-nvim.git", install_path })
end

-- Plugins ------------------------------------------------------------
require("paq") ({
    "savq/paq-nvim",

    "hoob3rt/lualine.nvim",
    "kdheepak/tabline.nvim",

    "sainnhe/everforest",    -- colorscheme
    "folke/tokyonight.nvim", -- colorscheme

    "kyazdani42/nvim-web-devicons",
    "ryanoasis/vim-devicons",

    --"kyazdani42/nvim-tree.lua", -- bugged

    "nvim-telescope/telescope.nvim",
    --"nvim-treesitter/nvim-treesitter", -- has problems with missing cc or gcc

    --    "ixru/nvim-markdown", -- Markdown mode

    "neovim/nvim-lspconfig", -- for setting up language servers
    "hrsh7th/nvim-cmp", -- completion, requires sources
    "hrsh7th/cmp-buffer", -- buffer completion source
    "hrsh7th/cmp-nvim-lsp", -- lsp completion source
    "saadparwaiz1/cmp_luasnip", -- lua snippets source
    "hrsh7th/cmp-emoji", -- emoji source

    "L3MON4D3/LuaSnip", -- snippet engine in lua
    "rafamadriz/friendly-snippets", -- collection of snippets

    "nvim-lua/plenary.nvim", -- this is required for neogit
    "TimUntersberger/neogit", -- magit like extension for neovim

    "ur4ltz/surround.nvim",

    "norcalli/nvim-colorizer.lua",
})

-- gitsigns setup -----------------------------------------------------
--[[require("gitsigns").setup({
numhl = true,
signcolumn = false,
})--]]


-- colorizer --
opt.termguicolors = true
require('colorizer').setup()


-- colorscheme --------------------------------------------------------
cmd([[colorscheme tokyonight]]) -- Put your favorite colorscheme here

-- basics -------------------------------------------------------------
g.mapleader = " "
map('n', '<Leader>fs', ':write<CR>', {noremap = true})  -- quicker save
map('n', '<C-t>', ':tabnew<CR>', {noremap = true})      -- create new tab 
map('n', '<Leader>bn', ':bn<CR>', {noremap = true})     -- cycle through buffers
map('n', '<Leader>t', ':tabnext<CR>', {noremap = true}) -- toggle between tabs
map('n', '<Leader>bd', ':bd<CR>', {noremap = true})     -- delete file

map('n', '<C-h>', '<C-w>h', {noremap = true})
map('n', '<C-j>', '<C-w>j', {noremap = true})
map('n', '<C-k>', '<C-w>k', {noremap = true})
map('n', '<C-l>', '<C-w>l', {noremap = true})


map('i', 'jf', '<Esc>', {noremap = true}) -- exit insert more elegantly
map('i', 'fj', '<Esc>', {noremap = true}) -- exit insert more elegantly

-- lualine ------------------------------------------------------------
require('lualine').setup({
    options = {
        icons_enabled = true,
        theme = "tokyonight",
    }
})

-- tabline ------------------------------------------------------------
require('tabline').setup {}

-- Nvim-Tree ----------------------------------------------------------
--map('n', '<C-n>', ':NvimTreeToggle<CR>', {noremap = true})
--map('n', '<leader>r', ':NvimTreeRefresh<CR>', {noremap = true})
--map('n', '<leader>n', ':NvimTreeFindFile<CR>', {noremap = true})
--g.nvim_tree_side = 'right'
--g.nvim_tree_width = '40'
--g.nvim_tree_quit_on_open = 0
--g.nvim_tree_disable_keybindings = 1

-- neogit -------------------------------------------------------------
local neogit = require('neogit')
neogit.setup {}
map('n', '<Leader>gs', ':Neogit<CR>', {noremap = true})

-- telescope ----------------------------------------------------------
require('telescope').setup{}
map('n', '<Leader>ff', ':Telescope find_files<CR>', {noremap = true})
map('n', '<Leader>fg', ':Telescope live_grep<CR>', {noremap = true})
map('n', '<Leader>fb', ':Telescope buffers<CR>', {noremap = true})
map('n', '<Leader>fh', ':Telescope help_tags<CR>', {noremap = true})

-- More dev stuff -----------------------------------------------------
-- completion stuff
vim.o.completeopt = "menuone,noselect"

local luasnip = require'luasnip'

require("luasnip/loaders/from_vscode").load()

local cmp = require'cmp'
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = function(fallback)
            if vim.fn.pumvisible() == 1 then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, true, true), 'n')
            elseif luasnip.expand_or_jumpable() then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
            else
                fallback()
            end
        end,
        ['<S-Tab>'] = function(fallback)
            if vim.fn.pumvisible() == 1 then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, true, true), 'n')
            elseif luasnip.jumpable(-1) then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
            else
                fallback()
            end
        end,
    },
    sources = {
        { name = 'nvim_lua' },
        { name = 'buffer' },
        { name = 'emoji' },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }
})

-- LSP ----------------------------------------------------------------
-- 🐍 python
require'lspconfig'.pyright.setup{} -- npm i -g pyright; put binary in path

-- surround mode ------------------------------------------------------
require "surround".setup {}

-- options ------------------------------------------------------------
opt.encoding = "utf-8" -- Set default encoding to UTF-8
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 4 -- Size of an indent
opt.smartindent = true -- Insert indents automatically
opt.cursorline = true
opt.clipboard = "unnamedplus"
opt.incsearch = true -- Shows the match while typing
opt.hlsearch = true -- Highlight found searchresults
opt.ignorecase = true
opt.number = true
opt.numberwidth = 5
opt.scrolloff = 20
opt.mouse = "a"
opt.termguicolors = true

