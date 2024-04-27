vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "<leader><CR>", ":luafile %<CR>")

-- move lines up and down when 'selected'
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z") -- join next line and keep cursor position

vim.keymap.set("n", "<C-d>", "<C-d>zz") -- half page down
vim.keymap.set("n", "<C-u>", "<C-u>zz") -- half page up

vim.keymap.set("n", "n", "nzzzv") -- center line after search
vim.keymap.set("n", "N", "Nzzzv") -- center line after search

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]]) -- It’s the /dev/null of the Vim world - Black hole register "_, delete, paste
-- Example:
-- if you deleted three lines into the unnamed register with 3dd with the intent of pasting them elsewhere with p, 
-- but you wanted to delete another line before doing so, you could do that with "_dd; line gone, and no harm done.
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]]) -- delete into black hole register

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])


-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>") -- Else I accidentally hit it, it quits vim


vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>") -- tmux sessionizer - custom script

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format) -- format code

-- Quickfix and location list
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
 vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]) -- start replacing the word I'm on

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true }) -- make file executable

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/after/plugin/lsp.lua<CR>"); -- go to plugins
vim.keymap.set("n", "<leader>vpk", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/benni/remap.lua<CR>"); -- go to keymap


vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>") -- make it rain - cool

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

vim.keymap.set("n", "<leader>J", ":split +term<CR>")

vim.keymap.set({"n", "v"}, "<leader>h", ":wincmd h<CR>")
--vim.keymap.set({"n", "v"}, "<leader>j", ":wincmd j<CR>")
--vim.keymap.set({"n", "v"}, "<leader>k", ":wincmd k<CR>")
vim.keymap.set({"n", "v"}, "<leader>l", ":wincmd l<CR>")
