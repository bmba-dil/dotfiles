return {
	"FeiyouG/commander.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	keys = {
		{ "<leader>f", "<CMD>Telescope commander<CR>", mode = "n" },
		{ "<leader>fc", "<CMD>Telescope commander<CR>", mode = "n" },
	},
	config = function()
		require("commander").setup({
			components = {
				"DESC",
				"KEYS",
				"CAT",
			},
			sort_by = {
				"DESC",
				"KEYS",
				"CAT",
				"CMD",
			},
			integration = {
				telescope = {
					enable = true,
				},
				lazy = {
					enable = true,
					set_plugin_name_as_cat = true,
				},
			},
		})
		require("commander").add({
			{
				desc = "Inside parens",
				keys = { "n", "ci(" },
				cmd = function()
					vim.api.nvim_feedkeys("ci(", "n", false)
				end,
			},
			{
				desc = "Inside braces",
				keys = { "n", "ci{" },
				cmd = function()
					vim.api.nvim_feedkeys("ci{", "n", false)
				end,
			},
			{
				desc = "Inside brackets",
				keys = { "n", "ci[" },
				cmd = function()
					vim.api.nvim_feedkeys("ci[", "n", false)
				end,
			},
			{
				desc = "Inside quotes",
				keys = { "n", 'ci"' },
				cmd = function()
					vim.api.nvim_feedkeys('ci"', "n", false)
				end,
			},
			{
				desc = "Around parens",
				keys = { "n", "da(" },
				cmd = function()
					vim.api.nvim_feedkeys("da(", "n", false)
				end,
			},
			{
				desc = "Change next match",
				keys = { "n", "cgn" },
				cmd = function()
					vim.api.nvim_feedkeys("cgn", "n", false)
				end,
			},
		}, { cat = "Text Objects", set = false, show = true })
	end,
}
