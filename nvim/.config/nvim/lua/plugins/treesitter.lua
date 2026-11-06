return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({
			install_dir = vim.fn.stdpath("data") .. "/site",
		})
		require("nvim-treesitter").install({
			"lua",
			"vim",
			"vimdoc",
			"query",
			"python",
			"c",
			"css",
			"rust",
			"zig",
			"go",
			"gomod",
			"gosum",
			"gowork",
			"gotmpl",
			"html",
			"javascript",
			"toml",
			"yaml",
			"json",
			"markdown",
			"markdown_inline",
			"bash",
			"regex",
		})
	end,
}
