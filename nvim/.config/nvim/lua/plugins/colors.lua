-- lualine, themed from the shared Synthwave Pro palette.
--
-- The old hand-rolled SpaceVim port lived here. It has been replaced by:
--   lua/config/palette.lua      -- the colors (switch palette/depth there)
--   lua/config/highlights.lua   -- applies them to Neovim + plugin groups
-- Nothing in this file defines colors; it only reads them.

local p = require("config.palette")

return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			options = {
				-- NOTE: lualine reads `theme` from options, not the top of opts.
				theme = {
					normal = {
						a = { bg = p.accent1, fg = p.bg0, gui = "bold" },
						b = { bg = p.bg3, fg = p.text },
						c = { bg = "NONE", fg = p.muted },
					},
					insert = { a = { bg = p.success, fg = p.bg0, gui = "bold" } },
					visual = { a = { bg = p.accent3, fg = p.bg0, gui = "bold" } },
					replace = { a = { bg = p.error, fg = p.bg0, gui = "bold" } },
					command = { a = { bg = p.accent2, fg = p.bg0, gui = "bold" } },
					inactive = {
						a = { bg = "NONE", fg = p.faint },
						b = { bg = "NONE", fg = p.faint },
						c = { bg = "NONE", fg = p.faint },
					},
				},
			},
		},
	},
}
