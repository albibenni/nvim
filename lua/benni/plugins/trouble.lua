return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
	opt = {
		focus = true,
	},
	cmd = "Trouble",
	keys = {
		{ "<leader>tt", "<cmd>Trouble diagnostics toggle<CR>", desc = "Open trouble workspace diagnostics" },
		{
			"<leader>xd",
			"<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
			desc = "Open trouble document diagnostics",
		},
		{ "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "Open trouble quickfix list" },
		{ "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Open trouble location list" },
		{ "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "Open todos in trouble" },
	},
	-- config = function()
	-- 	require("trouble").setup({
	-- 		icons = false,
	-- 	})
	--
	-- 	vim.keymap.set("n", "<leader>tt", function()
	-- 		require("trouble").toggle()
	-- 	end)
	--
	-- 	vim.keymap.set("n", "[t", function()
	-- 		require("trouble").next({ skip_groups = true, jump = true })
	-- 	end)
	--
	-- 	vim.keymap.set("n", "]t", function()
	-- 		require("trouble").previous({ skip_groups = true, jump = true })
	-- 	end)
	-- end,
}
