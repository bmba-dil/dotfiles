return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		plugins = {
			presets = { operators = true, motions = true, text_objects = true, g = true, z = true, nav = true },
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
}
