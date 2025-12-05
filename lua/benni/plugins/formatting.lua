return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				sh = { "shfmt" },
				bash = { "shfmt" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				svelte = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "yamlfmt" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				liquid = { "prettier" },
				rust = { "rustfmt", lsp_format = "fallback" },
				c = { "clang-format" },
				go = { "gofmt" },
				lua = { "stylua" },
				python = { "isort", "black" },
			},
			formatters = {
				shfmt = {
					prepend_args = { "-i", "2" }, -- indent with 2 spaces
					-- other options: "-i", "4" for 4 spaces
					-- "-ci" for switch case indentation
					-- "-bn" for binary ops like && and | on next line
				},
			},
			-- format_on_save = {
			-- 	lsp_fallback = true,
			-- 	async = false,
			-- 	timeout_ms = 1000,
			-- },
		})

		vim.keymap.set({ "n", "v" }, "<leader>f", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
