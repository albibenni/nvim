return {
	"mason-org/mason.nvim",
	dependencies = {
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"mfussenegger/nvim-jdtls",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- {
		-- 	"williamboman/mason-lspconfig.nvim",
		-- 	opts = {
		-- 		automatic_enable = {
		-- 			exclude = {
		-- 				--needs external plugin
		-- 				"jdtls",
		-- 			},
		-- 		},
		-- 	},
		-- },

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")
		mason_lspconfig.opts = {
			automatic_enable = {
				exclude = {
					--needs external plugin
					"jdtls",
				},
			},
		}

		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = {
				"lua_ls",
				-- "tsserver",
				"ts_ls",
				"html",
				"cssls",
				"tailwindcss",
				"graphql",
				"dockerls",
				"pyright",
				"sqlls",
				"emmet_ls",
				"gopls",
				"zls",
				"rust_analyzer",
				"bash-language-server",
				"jdtls",
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"yamlfmt", -- yml formatter
				"golangci-lint", -- go linter
				--"goimports", --go formatter
				"eslint_d", -- js lint
				"cpplint", -- c c++ lint
				"isort", -- python formatter
				"black", -- python formatter
				"pylint", -- python lint
				"jsonlint", -- json lint
				"yamlfmt", -- yaml format
				"clang-format", -- c c++ format
			},
		})
	end,
}
