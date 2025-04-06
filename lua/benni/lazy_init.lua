local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
-- Put lazy.nvim in runtimepath for neovim to find it!
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ import = "benni.plugins" },
	{ import = "benni.plugins.lsp" },
}, {
	-- rocks = {
	-- 	hererocks = true,
	-- },
	install = {
		colorscheme = { "nightfly" },
	},
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = { notify = false },
})
