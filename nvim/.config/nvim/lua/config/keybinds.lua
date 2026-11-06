local map = vim.keymap.set

-- Set leader
vim.g.mapleader = " "
map("n", "go", "<CMD>Oil<CR>", { desc = "Oil" })

-- Neo-tree
map("n", "<leader>e", "<CMD>Neotree toggle<CR>", { desc = "Neo-tree" })
-- Terminal buffer
map("t", "<Esc>", [[<C-\><C-n>]])
map("t", "<C-w>", [[<C-\\><C-n><C-w>]])
map("n", "<leader>t", "<cmd>terminal<cr>", { desc = "Open terminal in buffer" })

-- Replace all instances of whatever is under cursor (on line)
map("n", "<leader>s", [[:s/\<<C-r><C-w>\>//gI<Left><Left><Left>]])
map("n", "<leader>S", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]])

-- Alt up/down vscode style
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("v", "Down", ":m '>+1<CR>gv=gv")
map("v", "Up", ":m '<-2<CR>gv=gv")

map("n", "J", "mzJ`z") -- Remap joining lines
map("n", "<C-d>", "<C-d>zz") -- Keep cursor in place while moving up/down page
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv") -- center screen when looping search results
map("n", "N", "Nzzzv")

-- yank into clipboard even if on ssh
map("n", "<leader>y", "<Plug>OSCYankOperator")
map("v", "<leader>y", "<Plug>OSCYankVisual")

-- reload without exiting vim
map("n", "<leader>rl", "<cmd>source ~/.config/nvim/init.lua<cr>")

-- undo tree
map("n", "<leader>u", vim.cmd.UndotreeToggle)

-- Quickfix list stuff
map("n", "<leader>cl", ":cclose<CR>", { silent = true })
map("n", "<leader>co", ":copen<CR>", { silent = true })
map("n", "<leader>cn", ":cnext<CR>zz")
map("n", "<leader>cp", ":cprev<CR>zz")
map("n", "<leader>ci", ":checkhealth vim.lsp<CR>", { desc = "LSP Info" })

-- navigate
map("n", "<C-Left>", "<C-w>h", { desc = "Window left" })
map("n", "<C-Down>", "<C-w>j", { desc = "Window down" })
map("n", "<C-Up>", "<C-w>k", { desc = "Window up" })
map("n", "<C-Right>", "<C-w>l", { desc = "Window right" })
map("n", "<leader>h", "<C-w>h", { desc = "Window left" })
map("n", "<leader>j", "<C-w>j", { desc = "Window down" })
map("n", "<leader>k", "<C-w>k", { desc = "Window up" })
map("n", "<leader>l", "<C-w>l", { desc = "Window right" })
-- split / close
map("n", "<leader>ws", "<C-w>s", { desc = "Split horizontal" })
map("n", "<leader>wv", "<C-w>v", { desc = "Split vertical" })
map("n", "<leader>wq", "<C-w>q", { desc = "Close window" })
map("n", "<leader>wo", "<C-w>o", { desc = "Close all others" })
-- resize
map("n", "<leader>w,", "<C-w><", { desc = "Narrower" })
map("n", "<leader>w.", "<C-w>>", { desc = "Wider" })
map("n", "<leader>w-", "<C-w>-", { desc = "Shorter" })
map("n", "<leader>w+", "<C-w>+", { desc = "Taller" })
map("n", "<leader>w=", "<C-w>=", { desc = "Equalize sizes" })

-- Tabpages
map("n", "<leader>gh", "<cmd>tabprevious<cr>", { desc = "Tab left" })
map("n", "<leader>gl", "<cmd>tabnext<cr>", { desc = "Tab right" })
map("n", "<leader>gn", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader>gq", "<cmd>tabclose<cr>", { desc = "Close tab" })
for i = 1, 5 do
	map("n", "<leader>g" .. i, i .. "gt", { desc = "tab " .. i })
end

-- Esc clears search
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- source file
map("n", "<leader><leader>", function()
	vim.cmd("so")
end)
