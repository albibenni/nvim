return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { -- If encountering errors, see telescope-fzf-native README for installation instructions
            "nvim-telescope/telescope-fzf-native.nvim",
            -- `build` is used to run some command when the plugin is installed/updated.
            -- This is only run then, not every time Neovim starts up.
            build = "make",

            -- `cond` is a condition used to determine whether this plugin should be
            -- installed and loaded.
            cond = function()
                return vim.fn.executable("make") == 1
            end,
        },
        { "nvim-telescope/telescope-ui-select.nvim" },
        -- Useful for getting pretty icons, but requires a Nerd Font.
        { "nvim-tree/nvim-web-devicons",            enabled = vim.g.have_nerd_font },
    },

    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local builtin = require('telescope.builtin')
        local keymap = vim.keymap

        telescope.setup({
            defaults = {
                path_display = { "smart" },
                mappings = {}
            }
        })
        telescope.load_extension("fzf")


        keymap.set('n', '<leader>pf', builtin.find_files, {})
        keymap.set('n', '<C-p>', builtin.git_files, {})
        keymap.set('n', '<leader>ps', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)
        keymap.set('n', '<leader>pWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)
        keymap.set('n', '<leader>pws', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
        keymap.set('n', '<leader>vh', builtin.help_tags, {})
    end
}
