return {
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		opts = {
			opts = {
				enable_close = true, -- Auto close tags
				enable_rename = true, -- Auto rename pairs of tags
				enable_close_on_slash = false, -- Auto close on trailing </
			},
		},
	},
	{
		-- Auto-close brackets/quotes; Enter between {} splits onto an indented line
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			check_ts = true,
			-- only auto-close when the next char is whitespace, end of line, or a closer
			ignored_next_char = "[^%s%)%]%}]",
		},
	},
	"mbbill/undotree",
	{
		-- Show CSS colors
		"brenoprata10/nvim-highlight-colors",
		config = function()
			require("nvim-highlight-colors").setup({})
		end,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			heading = { backgrounds = {} },
			anti_conceal = { enabled = false },
			win_options = { concealcursor = { rendered = "nc" } },
			html = { enabled = false },
			latex = { enabled = false },
		},
	},
	-- {
	-- 	"m4xshen/hardtime.nvim",
	-- 	lazy = false,
	-- 	dependencies = { "MunifTanjim/nui.nvim" },
	-- 	opts = {
	-- 		restriction_mode = "hint",
	-- 	},
	-- },
}
