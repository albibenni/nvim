-- vim.opt.guicursor = ""

vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.splitright = true
vim.opt.splitbelow = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.cursorline = true

vim.cmd([[autocmd FileType * set formatoptions-=ro]])

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

-- Use system clipboard for yank/paste operations
vim.opt.clipboard = "unnamedplus"

vim.opt.colorcolumn = "120"
-- vim.cmd("highlight ColorColumn ctermbg=235 guibg=#0F0F0F")

--vim.api.nvim_create_autocmd("VimEnter", {
--    callback = function()
--        vim.cmd("Copilot disable")
--    end,
--})
