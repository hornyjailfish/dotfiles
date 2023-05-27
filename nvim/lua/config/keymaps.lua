local keymap = vim.keymap.set
local opts = { silent = true }

vim.g.mapleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- NORMAL --
--
-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Clear highlights
-- keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)

-- leader y/p to yank/paste from "+
keymap("v", "<leader>y", [["+y]], opts)
keymap("n", "<leader>p", [["+p]], opts)

-- INSERT --
--

-- VISUAL --
--
-- Stay in indent mode
-- keymap("v", "<", "<gv", opts)
-- keymap("v", ">", ">gv", opts)

-- Move selected line with c-j/k  FIXME: this method sucks because populate undo too much
keymap("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Put search results in the center
keymap("n", "n", "nzz")
keymap("n", "N", "Nzz")

-- Plugins --
-- nah lazy do it better than separate file
