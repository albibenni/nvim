return {
	"nvim-telescope/telescope.nvim",
	-- branch = "0.1.x",
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
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "cmake" },
		-- { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' }
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},

	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")
		local actions = require("telescope.actions")
		-- local transform_mod = require("telescope.actions.mt").transform_mod
		--
		-- local trouble = require("trouble")

		-- local trouble_telescope = require("trouble.sources.telescope")
		-- local custom_actions = transform_mod({
		-- 	open_trouble_qflist = function(prompt_bufnr)
		-- 		trouble.toggle("quickfix")
		-- 	end,
		-- })

		telescope.setup({
			defaults = {
				-- show filename before path
				path_display = { "filename_first" },

				-- smart-case: case-insensitive when all lowercase, sensitive otherwise
				-- --hidden: include dotfiles
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
				},

				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						["<esc>"] = actions.close,
					},
				},

				file_ignore_patterns = { "%.git/", "node_modules/" },
			},
		})

		telescope.load_extension("fzf")

		vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "Fuzzy find files in cwd" })
		vim.keymap.set("n", "<C-p>", builtin.git_files, {})
		vim.keymap.set("n", "<leader>ps", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		vim.keymap.set("n", "<leader>pwc", function()
			local word = vim.fn.expand("<cWORD>")
			builtin.grep_string({ search = word })
		end)
		vim.keymap.set("n", "<leader>pwa", function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end, {})
		vim.keymap.set("n", "<leader>pt", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
		vim.keymap.set(
			"n",
			"<leader>pc",
			"<cmd>Telescope grep_string<cr>",
			{ desc = "Find string under cursor in cwd" }
		)

		vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
	end,
}
