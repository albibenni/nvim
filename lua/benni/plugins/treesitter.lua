return {
	"nvim-treesitter/nvim-treesitter",
	main = "nvim-treesitter.configs",
	branch = "main",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		-- Prefer git instead of tarball downloads to avoid 404s (e.g. for jsonc)
		require("nvim-treesitter.install").prefer_git = true

		-- Autotag must now be setup independently
		require("nvim-ts-autotag").setup()

		-- List of parsers to ensure installed
		local ensure_installed = {
			"vimdoc",
			"javascript",
			"typescript",
			"tsx",
			"jsdoc",
			"json",
			"yaml",
			"html",
			"css",
			"prisma",
			"markdown",
			"markdown_inline",
			"svelte",
			"graphql",
			"bash",
			"lua",
			"vim",
			"dockerfile",
			"gitignore",
			"query",
			"go",
			"rust",
			"c",
			"java",
			"templ",
		}

		-- Auto-install missing parsers
		vim.defer_fn(function()
			local ts = require("nvim-treesitter")
			local installed = ts.get_installed()
			local missing = {}
			for _, p in ipairs(ensure_installed) do
				if not vim.list_contains(installed, p) then
					table.insert(missing, p)
				end
			end
			if #missing > 0 then
				ts.install(missing)
			end
		end, 100)
	end,
}
