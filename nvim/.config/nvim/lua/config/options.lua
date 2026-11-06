-- OPTIONS
local set = vim.opt

-- timeout
vim.o.timeoutlen = 300

-- Clipboard
vim.g.clipboard = "osc52"
vim.opt.clipboard = "unnamedplus"

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

-- Enable mouse
vim.opt.mouse = "a"

-- Fix tab button
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

-- Wrapping: keep wrapped lines aligned under the indent they came from
vim.opt.wrap = true
vim.opt.linebreak = true -- break at word boundaries, not mid-word
vim.opt.breakindent = true -- wrapped lines inherit the line's indent
vim.opt.breakindentopt = "shift:2" -- ...plus 2 extra columns so the wrap is obvious
vim.opt.showbreak = "↪ "

-- keep cursor at least 8 rows from top/bot
set.scrolloff = 8

-- Colors for ipad...
vim.opt.termguicolors = true

vim.opt.jumpoptions:append("view")

-- diff options
vim.opt.diffopt:append({ "linematch:60", "algorithm:histogram" })

-- faster cursor hold
set.updatetime = 50

-- Go templates. Neovim's builtin rule maps *.tmpl to the unrelated "template"
-- filetype, so gopls and the gotmpl parser never attach without this.
vim.filetype.add({
	extension = {
		tmpl = "gotmpl",
		gotmpl = "gotmpl",
		gohtml = "gotmpl",
		gotxt = "gotmpl",
	},
})

-- K / :Man takes over the current window instead of opening a horizontal split
vim.opt.keywordprg = ":hide Man"

-- *.hdl defaults to vhdl in nvim's builtin filetype map; these are
-- nand2tetris chip definitions -> syntax/hdl.vim
vim.filetype.add({ extension = { hdl = "hdl" } })
