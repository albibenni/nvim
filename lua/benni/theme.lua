local theme_file = vim.fn.expand("~/.local/state/omarchy/current/theme/neovim.lua")

local fallback = {
	{ "folke/tokyonight.nvim", lazy = false, priority = 1000 },
}

if vim.fn.filereadable(theme_file) == 0 then
	return fallback
end

local ok, omarchy_specs = pcall(dofile, theme_file)
if not ok or type(omarchy_specs) ~= "table" then
	return fallback
end

local specs = {}
local colorscheme

for _, spec in ipairs(omarchy_specs) do
	if spec[1] == "LazyVim/LazyVim" then
		colorscheme = spec.opts and spec.opts.colorscheme
	else
		spec.lazy = false
		spec.priority = math.max(spec.priority or 0, 1000)
		table.insert(specs, spec)
	end
end

if colorscheme then
	vim.api.nvim_create_autocmd("User", {
		pattern = "LazyDone",
		once = true,
		callback = function()
			vim.cmd.colorscheme(colorscheme)
		end,
	})
end

return specs
