require("benni.remap")
require("benni.set")
require("benni.lazy_init")

local augroup = vim.api.nvim_create_augroup
local benni_group = augroup("Benni", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

function R(name)
	require("plenary.reload").reload_module(name)
end

vim.filetype.add({
	extension = {
		templ = "templ",
	},
})

autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

autocmd({ "BufWritePre" }, {
	group = benni_group,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

-- vim.api.nvim_create_autocmd("VimEnter", {
-- 	callback = function()
-- 		vim.cmd("Copilot disable")
-- 	end,
-- })
