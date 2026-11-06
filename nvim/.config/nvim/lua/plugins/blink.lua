return {
	{
		"saghen/blink.cmp",
		version = "1.*",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		event = "InsertEnter",
		opts = {
			keymap = {
				preset = "enter",
				["<CR>"] = {
					"accept",
					-- between <tag>|</tag>: split the pair and put cursor on an indented line between
					function()
						local col = vim.api.nvim_win_get_cursor(0)[2]
						local line = vim.api.nvim_get_current_line()
						if line:sub(col, col) == ">" and line:sub(col + 1, col + 2) == "</" then
							vim.api.nvim_feedkeys(vim.keycode("<CR><Esc>O"), "n", false)
							return true
						end
					end,
					"fallback",
				},
				["<Tab>"] = { "select_and_accept", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
				["<C-j>"] = { "select_next", "fallback" },
				["<C-k>"] = { "select_prev", "fallback" }, -- conflicts with signature in default; pick one
				["<C-u>"] = { "scroll_documentation_up", "fallback" },
				["<C-d>"] = { "scroll_documentation_down", "fallback" },
				["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = {
				list = { selection = { preselect = false, auto_insert = false } },
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 2000,
					window = {
						max_width = 50,
						max_height = 10,
						desired_min_width = 20,
						desired_min_height = 3,
						direction_priority = {
							menu_north = { "n", "e", "w", "s" },
							menu_south = { "s", "e", "w", "n" },
						},
					},
				},
			},
			signature = {
				enabled = true,
				trigger = { show_on_trigger_character = false },
			},
			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
					lsp = { score_offset = 15 },
					path = { score_offset = 3 },
					snippets = { score_offset = -2 },
					buffer = {
						score_offset = -10,
						opts = { min_keyword_length = 3 },
					},
				},
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
}
