local M = {}

local valid_themes = {
	latte = true,
	frappe = true,
	macchiato = true,
	mocha = true,
	tokyonight = true,
	["night-owl"] = true,
	custom = true,
}

function M.current()
	local state_file = vim.fn.expand("~/.config/theme-switcher/current")
	if vim.fn.filereadable(state_file) == 0 then
		return "mocha"
	end
	local lines = vim.fn.readfile(state_file)
	local flavor = lines[1] or "mocha"
	return valid_themes[flavor] and flavor or "mocha"
end

function M.apply()
	local theme = M.current()

	if theme == "tokyonight" then
		require("tokyonight").setup({
			style = "night",
			transparent = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
		})
		vim.cmd.colorscheme("tokyonight")
		return
	end

	if theme == "custom" then
		require("tokyonight").setup({
			style = "night",
			transparent = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
			on_colors = function(colors)
				colors.bg = "#011628"
				colors.bg_dark = colors.none
				colors.bg_float = colors.none
				colors.bg_highlight = "#143652"
				colors.bg_popup = "#011423"
				colors.bg_search = "#0A64AC"
				colors.bg_sidebar = colors.none
				colors.bg_statusline = colors.none
				colors.bg_visual = "#275378"
				colors.border = "#547998"
				colors.fg = "#CBE0F0"
				colors.fg_dark = "#B4D0E9"
				colors.fg_float = "#CBE0F0"
				colors.fg_gutter = "#627E97"
				colors.fg_sidebar = "#B4D0E9"
			end,
		})
		vim.cmd.colorscheme("tokyonight")
		return
	end

	if theme == "night-owl" then
		require("night-owl").setup({
			transparent_background = true,
		})
		vim.cmd.colorscheme("night-owl")
		return
	end

	require("catppuccin").setup({
		flavour = theme,
		transparent_background = true,
	})
	vim.cmd.colorscheme("catppuccin")
end

return M
