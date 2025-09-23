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
Plug 'williamboman/mason.nvim'

-- Autocompletion
Plug 'L3MON4D3/LuaSnip'
Plug 'danymat/neogen'

Plug 'tpope/vim-commentary'

Plug 'tpope/vim-surround'

-- Database
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-completion'
Plug 'kristijanhusak/vim-dadbod-ui'

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
require("telescope").setup({
    defaults = {
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--ignore-case",
        }
    }
})

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

require("core.lsp")
vim.cmd [[set completeopt+=menuone,noselect,popup]]
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        end
        -- Auto-format ("lint") on save.
        -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
        if not client:supports_method('textDocument/willSaveWaitUntil')
            and client:supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
                buffer = args.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
                end,
            })
        end
    end,
})

require('telescope').setup {
    defaults = {
        file_ignore_patterns = {
            "*.geojson",
            "*.svg",
        }
    }
}

require('neogen').setup {
    enabled = true,
    input_after_comment = true,
}


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

-- keybindings: neogen
vim.keymap.set('n', '<leader>nf', function() require("neogen").generate() end, opts)

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
