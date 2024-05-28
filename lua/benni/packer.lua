-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.3',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    --    use({
    --        'rose-pine/neovim',
    --        as = 'rose-pine',
    --        config = function()
    --            vim.cmd('colorscheme rose-pine')
    --        end
    --    })
    use { "catppuccin/nvim", as = "catppuccin", config = function() vim.cmd('colorscheme catppuccin') end }
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    -- use { 'nvim-treesitter/playground' }
    use "nvim-lua/plenary.nvim" -- don't forget to add this one if you don't have it yet!
    use { "ThePrimeagen/harpoon", branch = "harpoon2", requires = { { "nvim-lua/plenary.nvim" } } }
    use { 'mbbill/undotree' }
    use { 'tpope/vim-fugitive' }
    use({
        "iamcco/markdown-preview.nvim",
        run = "cd app && npm install",
        setup = function()
            local g = vim.g
            g.mkdp_auto_start = 1
            g.mkdp_auto_close = 1
            g.mkdp_page_title = "${name}.md"
            g.mkdp_preview_options = {
                disable_sync_scroll = 0,
                disable_filename = 1,
            }
        end,
        ft = "markdown",
    })

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    }
    use { "github/copilot.vim" }
    use("eandrju/cellular-automaton.nvim")
    use("folke/zen-mode.nvim")
    use("laytan/cloak.nvim")
end)
