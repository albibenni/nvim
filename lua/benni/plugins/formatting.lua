return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")
		local util = require("conform.util")

		conform.setup({
			formatters_by_ft = {
				sh = { "shfmt" },
				bash = { "shfmt" },
				javascript = { "vp_fmt", "biome", stop_after_first = true },
				typescript = { "vp_fmt", "biome", stop_after_first = true },
				javascriptreact = { "vp_fmt", "biome", stop_after_first = true },
				typescriptreact = { "vp_fmt", "biome", stop_after_first = true },
				svelte = { "vp_fmt", "biome", stop_after_first = true },
				css = { "vp_fmt", "biome", stop_after_first = true },
				html = { "vp_fmt", "prettier", stop_after_first = true },
				json = { "vp_fmt", "biome", stop_after_first = true },
				yaml = { "yamlfmt" },
				markdown = { "prettier" },
				graphql = { "vp_fmt", "biome", stop_after_first = true },
				liquid = { "prettier" },
				rust = { "rustfmt", lsp_format = "fallback" },
				c = { "clang-format" },
				go = { "gofmt" },
				lua = { "stylua" },
				python = { "isort", "black" },
				java = { "google-java-format" },
			},
			formatters = {
				vp_fmt = {
					command = "vp",
					args = { "fmt", "--stdin-filepath", "$FILENAME" },
					stdin = true,
					cwd = util.root_file({
						"vite.config.ts",
						"vite.config.js",
						"vite.config.mts",
						"vite.config.mjs",
					}),
					require_cwd = true,
				},
				shfmt = {
					prepend_args = { "-i", "2" }, -- indent with 2 spaces
					-- other options: "-i", "4" for 4 spaces
					-- "-ci" for switch case indentation
					-- "-bn" for binary ops like && and | on next line
				},
			},
			-- format_on_save = {
			-- 	lsp_format = "fallback",
			-- 	async = false,
			-- 	timeout_ms = 1000,
			-- },
		})

		vim.keymap.set({ "n", "v" }, "<leader>f", function()
			conform.format({
				lsp_format = "fallback",
				async = false,
				timeout_ms = 1000,
			}, function(err)
				if err then
					vim.notify("Formatting error: " .. tostring(err), vim.log.levels.ERROR)
				end
			end)
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
