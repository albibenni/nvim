-- For `plugins/markview.lua` users.
return {
	"OXY2DEV/markview.nvim",
	lazy = false,

	-- For `nvim-treesitter` users.
	priority = 49,

	config = function()
		local presets = require("markview.presets")

		local markview = require("markview")

		markview.markdown = {
			headigns = presets.headings.arrowed,
		}
	end,

	-- For blink.cmp's completion
	-- source
	-- dependencies = {
	--     "saghen/blink.cmp"
	-- },
}
