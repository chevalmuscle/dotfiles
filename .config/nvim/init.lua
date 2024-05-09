-- Base config
vim.g.mapleader = " "
vim.showmatch = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.scrolloff = 8
vim.opt.updatetime = 50
vim.wo.relativenumber = true
vim.wo.number = true
vim.wo.cursorline = true
vim.opt.expandtab = true
vim.opt.mouse = ""

-- Plugins

local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

Plug 'Mofiqul/vscode.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'numToStr/Navigator.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'lukas-reineke/lsp-format.nvim'
Plug 'nvim-telescope/telescope-live-grep-args.nvim'

Plug 'kyazdani42/nvim-web-devicons'
Plug 'jose-elias-alvarez/buftabline.nvim'

Plug 'tpope/vim-fugitive'

Plug 'olexsmir/gopher.nvim'

-- highlight occurences
Plug 'RRethy/vim-illuminate'

-- markdown preview
Plug 'iamcco/markdown-preview.nvim'

-- LSP Support
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

-- Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'L3MON4D3/LuaSnip'

Plug 'VonHeikemen/lsp-zero.nvim'

Plug 'tpope/vim-commentary'

Plug 'tpope/vim-surround'

vim.call('plug#end')

require('mason').setup()

-- vscode theme
vim.o.background = 'dark'
require('vscode').setup({
    transparent = false,
    italic_comments = true,

    -- Disable nvim-tree background color
    disable_nvimtree_bg = true,

    color_overrides = {
        vscTabOutside = "#454545"
    }
})
require('vscode').load()

-- treesitter
require('nvim-treesitter.configs').setup {
    ensure_installed = { 'go', 'javascript', 'html' },
    highlight = {
        enable = true,
        use_languagetree = true
    }
}

-- telescope
require("telescope").load_extension("live_grep_args")

-- nvim-tree
require("nvim-tree").setup()

-- Navigator
require('Navigator').setup({
    auto_save = 'current',
    disable_on_zoom = true
})

-- gitsigns
require('gitsigns').setup()

-- buftabline
require("buftabline").setup {
    tab_format = " #{n}: #{b}#{f} #{i} "
}

-- markdown preview dark theme is shit. set it to light
vim.g.mkdp_theme = "light"

-- lsp
local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp.default_keymaps({
        buffer = bufnr
    })

    lsp.buffer_autoformat()

    local opts = {
        buffer = bufnr
    }
    local bind = vim.keymap.set

    bind('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
end)

-- lua lsp config
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

-- golang lsp config + format on save
require("lsp-format").setup {}
lspconfig = require("lspconfig")

lspconfig.gopls.setup {
    on_attach = require("lsp-format").on_attach
}
lspconfig.tsserver.setup {}

local python_root_files = {
    'WORKSPACE',
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    'pyrightconfig.json',
}
lspconfig["pyright"].setup {
    on_attach = on_attach,
    root_dir = lspconfig.util.root_pattern(unpack(python_root_files))
}

lsp.setup()

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

-- Keybindings
local map = vim.api.nvim_set_keymap
local opts = {
    noremap = true,
    silent = true
}

-- disable arrows in normal mode
vim.keymap.set('n', '<up>', '<nop>')
vim.keymap.set('n', '<down>', '<nop>')
vim.keymap.set('n', '<left>', '<nop>')
vim.keymap.set('n', '<right>', '<nop>')

-- keybindings: nvim-tree
vim.keymap.set('n', '<leader>t', '<CMD>NvimTreeToggle<CR>')

-- keybindings: navigator
map('n', "<C-h>", "<CMD>lua require('Navigator').left()<CR>", opts)
map('n', "<C-k>", "<CMD>lua require('Navigator').up()<CR>", opts)
map('n', "<C-l>", "<CMD>lua require('Navigator').right()<CR>", opts)
map('n', "<C-j>", "<CMD>lua require('Navigator').down()<CR>", opts)
map('n', "<C-p>", "<CMD>lua require('Navigator').previous()<CR>", opts)

-- keybindings: telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- keybindings: tabs
vim.keymap.set('n', '<TAB>', '<CMD>bnext<CR>', opts)
vim.keymap.set('n', '<S-TAB>', '<CMD>bprev<CR>', opts)
vim.keymap.set('n', '<leader>x', '<CMD>bdelete<CR>', opts)

-- keybindings: gopher
vim.keymap.set('n', "<leader>gtj", "<CMD>GoTagAdd json<CR>", opts)
vim.keymap.set('n', "<leader>gie", "<CMD>GoIfErr<CR>", opts)

-- keybindings: open floating window for errors
vim.keymap.set('n', '<leader>i', function() vim.diagnostic.open_float() end, { desc = 'Toggle Diagnostics' })

-- keybindings: treesitter-context
vim.keymap.set("n", "<leader>c", function() require("treesitter-context").go_to_context() end, { silent = true })

-- keybindings: git diff split using fugitive
vim.keymap.set('n', "<leader>gds", "<CMD>Gdiffsplit<CR>", opts)

-- move when in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- keep cursor in the middle when jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- keep cursor in the middle when searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- override highlighted and keep current paste buffer
vim.keymap.set("x", "<leader>p", [["_dP]])

-- use system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- edit word at cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
