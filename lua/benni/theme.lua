local M = {}

local valid_themes = {
	latte = true,
	frappe = true,
	macchiato = true,
	mocha = true,
	tokyonight = true,
	["night-owl"] = true,
	custom = true,
	lumon = true,
	ethereal = true,
	everforest = true,
	gruvbox = true,
	miasma = true,
	hackerman = true,
	["osaka-jade"] = true,
	kanagawa = true,
	nord = true,
	["matte-black"] = true,
	vantablack = true,
	ristretto = true,
	["retro-82"] = true,
	["rose-pine"] = true,
	white = true,
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

	local palettes = {
		lumon = { "#16242d", "#d6e2ee", "#8bc9eb" }, ethereal = { "#060b1e", "#ffcead", "#7d82d9" }, everforest = { "#2d353b", "#d3c6aa", "#7fbbb3" }, gruvbox = { "#282828", "#d4be98", "#7daea3" },
		miasma = { "#222222", "#c2c2b0", "#78824b" }, hackerman = { "#0b0c16", "#ddf7ff", "#82fb9c" }, ["osaka-jade"] = { "#111c18", "#c1c497", "#509475" }, kanagawa = { "#1f1f28", "#dcd7ba", "#dcd7ba" },
		nord = { "#2e3440", "#d8dee9", "#81a1c1" }, ["matte-black"] = { "#121212", "#bebebe", "#e68e0d" }, vantablack = { "#000000", "#ffffff", "#8d8d8d" }, ristretto = { "#2c2525", "#e6d9db", "#f38d70" },
		["retro-82"] = { "#05182e", "#f6dcac", "#faa968" }, ["rose-pine"] = { "#191724", "#e0def4", "#c4a7e7" }, white = { "#ffffff", "#000000", "#6e6e6e" },
	}
	local palette = palettes[theme]
	if palette then
		vim.opt.background = theme == "white" and "light" or "dark"
		vim.api.nvim_set_hl(0, "Normal", { bg = palette[1], fg = palette[2] })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = palette[1], fg = palette[2] })
		vim.api.nvim_set_hl(0, "FloatBorder", { bg = palette[1], fg = palette[3] })
		vim.api.nvim_set_hl(0, "Visual", { bg = palette[3], fg = palette[1] })
		vim.api.nvim_set_hl(0, "Comment", { fg = palette[3], italic = true })
		return
	end

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
