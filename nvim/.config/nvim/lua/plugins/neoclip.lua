return {
    {
	"AckslD/nvim-neoclip.lua",
	dependencies = {
	    "nvim-telescope/telescope.nvim",
	    "kkharji/sqlite.lua",
	},
	events = "VeryLazy",
	opts = {
	    history = 100,
	    enable_persistent_history = true,
	    continuous_sync = false,
	    default_register = { '"', "+", "*" },
	    keys = {
		telescope = {
		    i = {
			select = "<CR>",
			paste = "<C-p>",
			paste_behind = "<C-k>",
			replay = "<C-q>",
			delete = "<C-d>",
		    },
		    n = {
			select = "<CR>",
			paste = "p",
			paste_behind = "P",
			replay = "q",
			delete = "d",
		    },
		},
	    },
	},
	config = function(_, opts)
	    require("neoclip").setup(opts)
	end,
    },
}
