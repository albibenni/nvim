return {
	{
		"mfussenegger/nvim-jdtls",
		ft = { "java" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local function setup_jdtls()
				local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
				local workspace_dir = vim.fn.expand("~") .. "/jdtls-data/" .. project_name

				-- Get the correct paths
				local jdtls_install = vim.fn.expand("~") .. "/.local/share/nvim/mason/packages/jdtls"
				local jar_path = vim.fn.glob(jdtls_install .. "/plugins/org.eclipse.equinox.launcher_*.jar")

				local capabilities = {}
				local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
				if ok then
					capabilities = cmp_nvim_lsp.default_capabilities()
				end

				local config = {
					-- The command that starts the language server
					-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
					cmd = {
						-- Java executable (uses system Java from /usr/bin/java on Arch)
						"java",

						"-Declipse.application=org.eclipse.jdt.ls.core.id1",
						"-Dosgi.bundles.defaultStartLevel=4",
						"-Declipse.product=org.eclipse.jdt.ls.core.product",
						"-Dlog.protocol=true",
						"-Dlog.level=ALL",
						"-Xmx1g",
						"--add-modules=ALL-SYSTEM",
						"--add-opens",
						"java.base/java.util=ALL-UNNAMED",
						"--add-opens",
						"java.base/java.lang=ALL-UNNAMED",

						-- 💀
						"-jar",
						jar_path,

						-- Configuration directory for Linux
						"-configuration",
						jdtls_install .. "/config_linux",

						-- 💀
						-- See `data directory configuration` section in the README
						"-data",
						workspace_dir,
					},

					-- 💀
					-- This is the default if not provided, you can remove it. Or adjust as needed.
					-- One dedicated LSP server & client will be started per unique root_dir
					root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),

					-- Here you can configure eclipse.jdt.ls specific settings
					-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
					-- for a list of options
					settings = {
						java = {
							signatureHelp = { enabled = true },
							contentProvider = { preferred = "fernflower" },
							completion = {
								favoriteStaticMembers = {
									"org.hamcrest.MatcherAssert.assertThat",
									"org.hamcrest.Matchers.*",
									"org.hamcrest.CoreMatchers.*",
									"org.junit.jupiter.api.Assertions.*",
									"java.util.Objects.requireNonNull",
									"java.util.Objects.requireNonNullElse",
									"org.mockito.Mockito.*",
								},
								filteredTypes = {
									"com.sun.*",
									"io.micrometer.shaded.*",
									"java.awt.*",
									"jdk.*",
									"sun.*",
								},
							},
						},
					},

					-- Language server `initializationOptions`
					-- You need to extend the `bundles` with paths to jar files
					-- if you want to use additional eclipse.jdt.ls plugins.
					--
					-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
					--
					-- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
					init_options = {
						bundles = {},
					},
					capabilities = capabilities,
				}
				-- This starts a new client & server,
				-- or attaches to an existing client & server depending on the `root_dir`.
				require("jdtls").start_or_attach(config)
			end

			-- Set up autocmd for Java filetype
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "java",
				callback = setup_jdtls,
			})

			-- Call it for the current buffer in case it's already a java file
			if vim.bo.filetype == "java" then
				setup_jdtls()
			end

			-- Ensure Treesitter highlighting is applied after JDTLS starts
			vim.defer_fn(function()
				if vim.bo.filetype == "java" then
					vim.cmd("edit")
				end
			end, 100)
		end,
	},
}
