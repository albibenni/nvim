return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main", -- REQUIRED for Neovim 0.12
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		local treesitter = require("nvim-treesitter")

		-- Register custom templ parser
		require("nvim-treesitter.parsers").templ = {
			install_info = {
				url = "https://github.com/vrischmann/tree-sitter-templ.git",
				files = { "src/parser.c", "src/scanner.c" },
				branch = "master",
			},
		}

		-- List of parsers to ensure are installed
		local parsers = {
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

		-- Setup treesitter modules
		treesitter.setup({
			ensure_installed = parsers,
			sync_install = false,
			auto_install = true,
			highlight = {
				enable = true, -- Enable this even in 0.12 for some plugins/modules
				additional_vim_regex_highlighting = { "markdown" },
			},
			indent = {
				enable = true,
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})

		-- Setup autotag (new way)
		require("nvim-ts-autotag").setup()

		-- Native Neovim 0.12 Treesitter highlighting
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype) or vim.bo[args.buf].filetype
				if lang and pcall(vim.treesitter.language.inspect, lang) then
					vim.treesitter.start(args.buf, lang)
				end
			end,
		})

		-- Enable Treesitter highlighting in markdown code blocks (crucial for docs)
		vim.g.markdown_fenced_languages = {
			"ts=typescript",
			"js=javascript",
			"python",
			"lua",
			"rust",
			"go",
			"c",
			"cpp",
		}

		-- Ensure associations for documentation and help
		vim.treesitter.language.add("markdown", { filetype = "lazyhelp" })
		vim.treesitter.language.add("vimdoc", { filetype = "help" })
	end,
}
