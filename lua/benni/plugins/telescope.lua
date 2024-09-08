return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		--{ -- If encountering errors, see telescope-fzf-native README for installation instructions
		-- 	"nvim-telescope/telescope-fzf-native.nvim",
		-- 	-- `build` is used to run some command when the plugin is installed/updated.
		-- 	-- This is only run then, not every time Neovim starts up.
		-- 	build = "make",
		--
		-- 	-- `cond` is a condition used to determine whether this plugin should be
		-- 	-- installed and loaded.
		-- 	cond = function()
		-- 		return vim.fn.executable("make") == 1
		-- 	end,
		-- },
		-- { "nvim-telescope/telescope-ui-select.nvim" },
		-- -- Useful for getting pretty icons, but requires a Nerd Font.
		-- { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},

	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local transform_mod = require("telescope.actions.mt").transform_mod

		local trouble = require("trouble")

		local builtin = require("telescope.builtin")
		local keymap = vim.keymap
		local trouble_telescope = require("trouble.sources.telescope")
		local custom_actions = transform_mod({
			open_trouble_qflist = function(prompt_bufnr)
				trouble.toggle("quickfix")
			end,
		})

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
						["<C-t>"] = trouble_telescope.open,
					},
				},
			},
		})
		telescope.load_extension("fzf")

		keymap.set("n", "<leader>pf", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<C-p>", builtin.git_files, {})
		keymap.set("n", "<leader>ps", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>pWs", function()
			local word = vim.fn.expand("<cWORD>")
			builtin.grep_string({ search = word })
		end)
		keymap.set("n", "<leader>pws", function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end, {})
		keymap.set("n", "<leader>pt", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
		keymap.set("n", "<leader>pc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })

		keymap.set("n", "<leader>vh", builtin.help_tags, {})
	end,
}
