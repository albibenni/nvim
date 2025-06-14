local prompts = {
	-- Code related prompts
	Explain = "Please explain how the following code works.",
	Review = "Please review the following code and provide suggestions for improvement.",
	Tests = "Please explain how the selected code works, then generate unit tests for it.",
	Refactor = "Please refactor the following code to improve its clarity and readability.",
	FixCode = "Please fix the following code to make it work as intended.",
	FixError = "Please explain the error in the following text and provide a solution.",
	BetterNamings = "Please provide better names for the following variables and functions.",
	Documentation = "Please provide documentation for the following code.",
	SwaggerApiDocs = "Please provide documentation for the following API using Swagger.",
	SwaggerJsDocs = "Please write JSDoc for the following API using Swagger.",
	-- Text related prompts
	Summarize = "Please summarize the following text.",
	Spelling = "Please correct any grammar and spelling errors in the following text.",
	Wording = "Please improve the grammar and wording of the following text.",
	Concise = "Please rewrite the following text to make it more concise.",
}

return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
			{ "nvim-telescope/telescope.nvim" }, -- Use telescope for help actions
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			question_header = "## User ",
			answer_header = "## Copilot ",
			error_header = "## Error ",
			prompts = prompts,
			auto_follow_cursor = false, -- Don't follow the cursor after getting response
			mappings = {
				-- Use tab for completion
				complete = {
					detail = "Use @<Tab> or /<Tab> for options.",
					insert = "<Tab>",
				},
				-- Close the chat
				close = {
					normal = "q",
					insert = "<C-c>",
				},
				-- Reset the chat buffer
				reset = {
					normal = "<C-x>",
					insert = "<C-x>",
				},
				-- Submit the prompt to Copilot
				submit_prompt = {
					normal = "<CR>",
					insert = "<C-CR>",
				},
				-- Accept the diff
				-- accept_diff = {
				-- 	normal = "<C-y>",
				-- 	insert = "<C-y>",
				-- },
				-- Show help
				show_help = {
					normal = "g?",
				},
			},
		},
		config = function(_, opts)
			local chat = require("CopilotChat")
			chat.setup(opts)

			chat.setup({
				model = "claude-sonnet-4",
				window = {
					layout = "float",
				},
			})

			local select = require("CopilotChat.select")
			vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
				chat.ask(args.args, { selection = select.visual })
			end, { nargs = "*", range = true })

			-- Inline chat with Copilot
			vim.api.nvim_create_user_command("CopilotChatInline", function(args)
				chat.ask(args.args, {
					selection = select.visual,
					window = {
						layout = "float",
						relative = "cursor",
						width = 1,
						height = 0.4,
						row = 1,
					},
				})
			end, { nargs = "*", range = true })

			-- Restore CopilotChatBuffer
			vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
				chat.ask(args.args, { selection = select.buffer })
			end, { nargs = "*", range = true })

			-- Custom buffer for CopilotChat
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "copilot-*",
				callback = function()
					vim.opt_local.relativenumber = true
					vim.opt_local.number = true

					-- Get current filetype and set it to markdown if the current filetype is copilot-chat
					local ft = vim.bo.filetype
					if ft == "copilot-chat" then
						vim.bo.filetype = "markdown"
					end
				end,
			})
		end,
		event = "VeryLazy",
		keys = {
			-- Show prompts actions with telescope
			{
				"<leader>cca",
				function()
					local actions = require("CopilotChat.actions")
					require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
				end,
				mode = "v",
				desc = "CopilotChat - Prompt actions",
			},
			{
				"<leader>cca",
				function()
					local actions = require("CopilotChat.actions")
					require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
				end,
				mode = "n",
				desc = "CopilotChat - Prompt actions",
			},
			-- {
			-- 	"<leader>ap",
			-- 	":lua require('CopilotChat.integrations.telescope').pick(require('CopilotChat.actions').prompt_actions({selection = require('CopilotChat.select').visual}))<CR>",
			-- 	mode = "x",
			-- 	desc = "CopilotChat - Prompt actions",
			-- },
			-- Code related commands
			{ "<leader>ce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
			{ "<leader>ct", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
			{ "<leader>cr", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
			{ "<leader>cR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
			{ "<leader>cn", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },
			-- Chat with Copilot in visual mode
			{
				"<leader>cv",
				":CopilotChatVisual",
				mode = "x",
				desc = "CopilotChat - Open in vertical split",
			},
			{
				"<leader>cc",
				":CopilotChat",
				mode = "x",
				desc = "CopilotChat - Open in vertical split",
			},
			{
				"<leader>cx",
				":CopilotChatInline<cr>",
				mode = "x",
				desc = "CopilotChat - Inline chat",
			},
			-- Custom input for CopilotChat
			{
				"<leader>ci",
				function()
					local input = vim.fn.input("Ask Copilot: ")
					if input ~= "" then
						vim.cmd("CopilotChat " .. input)
					end
				end,
				desc = "CopilotChat - Ask input",
			},
			-- Generate commit message based on the git diff
			{
				"<leader>cm",
				"<cmd>CopilotChatCommit<cr>",
				desc = "CopilotChat - Generate commit message for all changes",
			},
			-- Quick chat with Copilot
			{
				"<leader>cq",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						vim.cmd("CopilotChatBuffer " .. input)
					end
				end,
				desc = "CopilotChat - Quick chat",
			},
			-- Debug
			{ "<leader>cD", "<cmd>CopilotChatDebugInfo<cr>", desc = "CopilotChat - Debug Info" },
			-- Fix the issue with diagnostic
			{ "<leader>cf", "<cmd>CopilotChatFixDiagnostic<cr>", desc = "CopilotChat - Fix Diagnostic" },
			-- Clear buffer and chat history
			{ "<leader>cR", "<cmd>CopilotChatReset<cr>", desc = "CopilotChat - Clear buffer and chat history" },
			-- Toggle Copilot Chat Vsplit
			{ "<leader>cT", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat - Toggle" },
			-- Copilot Chat Models
			{ "<leader>cm", "<cmd>CopilotChatModels<cr>", desc = "CopilotChat - Select Models" },
			-- Copilot Chat Agents
			{ "<leader>cA", "<cmd>CopilotChatAgents<cr>", desc = "CopilotChat - Select Agents" },
		},
	},
}
