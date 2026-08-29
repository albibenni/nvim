local M = {}

local transparent_highlight_groups = {
	"Normal",
	"NormalNC",
	"NormalFloat",
	"FloatBorder",
	"SignColumn",
	"EndOfBuffer",
	"FoldColumn",
	"LineNr",
	"WinBar",
	"WinBarNC",
	"StatusLine",
	"StatusLineNC",
	"TabLine",
	"TabLineFill",
	"TabLineSel",
	"Pmenu",
}

local function apply_transparency()
	for _, group in ipairs(transparent_highlight_groups) do
		vim.api.nvim_set_hl(0, group, { bg = "none", ctermbg = "none" })
	end
end

local function apply_transparency_after_theme()
	apply_transparency()
	vim.schedule(apply_transparency)
end

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
	local transparent_group = vim.api.nvim_create_augroup("BenniThemeTransparency", { clear = true })
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = transparent_group,
		callback = apply_transparency_after_theme,
	})

	local native_themes = {
		lumon = { colorscheme = "lumon" },
		ethereal = { colorscheme = "ethereal" },
		everforest = { colorscheme = "everforest", setup = function() require("everforest").setup({ background = "soft", transparent_background_level = 2 }) end },
		gruvbox = { colorscheme = "gruvbox", setup = function() require("gruvbox").setup({ transparent_mode = true }) end },
		miasma = { colorscheme = "miasma" },
		hackerman = { colorscheme = "hackerman" },
		["osaka-jade"] = { colorscheme = "bamboo", setup = function() require("bamboo").setup({ style = "vulgaris", transparent = true }) end },
		kanagawa = { colorscheme = "kanagawa", setup = function() require("kanagawa").setup({ transparent = true }) end },
		nord = { colorscheme = "nordfox" },
		["matte-black"] = { colorscheme = "matteblack" },
		vantablack = { colorscheme = "vantablack", setup = function() require("vantablack").setup({ transparent = true }) end },
		ristretto = { colorscheme = "monokai-pro", setup = function() require("monokai-pro").setup({ filter = "ristretto", transparent_background = true }) end },
		["retro-82"] = { colorscheme = "retro-82" },
		["rose-pine"] = { colorscheme = "rose-pine", setup = function() require("rose-pine").setup({ variant = "main", disable_background = true }) end },
		white = { colorscheme = "white" },
	}
	local native_theme = native_themes[theme]
	if native_theme then
		vim.opt.background = theme == "white" and "light" or "dark"
		if native_theme.setup then native_theme.setup() end
		vim.cmd.colorscheme(native_theme.colorscheme)
		apply_transparency_after_theme()
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
		apply_transparency_after_theme()
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
		apply_transparency_after_theme()
		return
	end

	if theme == "night-owl" then
		require("night-owl").setup({
			transparent_background = true,
		})
		vim.cmd.colorscheme("night-owl")
		apply_transparency_after_theme()
		return
	end

	require("catppuccin").setup({
		flavour = theme,
		transparent_background = true,
	})
	vim.cmd.colorscheme("catppuccin")
	apply_transparency_after_theme()
end

return M
