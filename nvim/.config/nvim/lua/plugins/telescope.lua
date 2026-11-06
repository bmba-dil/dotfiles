return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		cmd = "Telescope",
		keys = {
			{ "<leader>ff", "<Cmd>Telescope find_files<CR>", desc = "Find files" },
			{ "<leader>fg", "<Cmd>Telescope live_grep<CR>", desc = "Live Grep" },
			{ "<leader>fb", "<Cmd>Telescope buffers<CR>", desc = "Buffers" },
			{ "<leader>fh", "<Cmd>Telescope help_tags<CR>", desc = "Help" },
			{ "<leader>fr", "<Cmd>Telescope registers<CR>", desc = "Registers" },
			{ "<leader>fy", "<Cmd>Telescope neoclip<CR>", desc = "Yank history" },
			{ "<leader>fk", "<Cmd>Telescope keymaps<CR>", desc = "Keymaps" },
			{ "<leader>fo", "<Cmd> Telescope oldfiles<CR>", desc = "Oldfiles" },
			-- find_files/live_grep above search from the cwd; these always search
			-- all of ~/projects no matter where nvim was opened.
			{
				"<leader>fp",
				function()
					require("telescope.builtin").find_files({ cwd = "~/projects", prompt_title = "Find in ~/projects" })
				end,
				desc = "Find files in ~/projects",
			},
			{
				"<leader>fH",
				function()
					require("telescope.builtin").find_files({ cwd = "~", prompt_title = "Find in root ~" })
				end,
				desc = "Find files in root ~",
			},
			{
				"<leader>fP",
				function()
					require("telescope.builtin").live_grep({ cwd = "~/projects", prompt_title = "Grep ~/projects" })
				end,
				desc = "Grep ~/projects",
			},
			-- Pick a directory under ~/projects, then fuzzy-find files inside it.
			{
				"<leader>fd",
				function()
					local actions = require("telescope.actions")
					local action_state = require("telescope.actions.state")
					local root = vim.fn.expand("~/projects")
					require("telescope.pickers")
						.new({}, {
							prompt_title = "Pick a directory",
							finder = require("telescope.finders").new_oneshot_job(
								{ "fd", "--type", "d", "--exclude", "node_modules", "--exclude", ".git", ".", root },
								{
									entry_maker = function(path)
										local rel = path:sub(#root + 2)
										return { value = path, display = rel, ordinal = rel }
									end,
								}
							),
							sorter = require("telescope.config").values.generic_sorter({}),
							attach_mappings = function(prompt_bufnr)
								actions.select_default:replace(function()
									local entry = action_state.get_selected_entry()
									actions.close(prompt_bufnr)
									if entry then
										require("telescope.builtin").find_files({ cwd = entry.value })
									end
								end)
								return true
							end,
						})
						:find()
				end,
				desc = "Find files in a chosen dir",
			},
		},
		opts = {
			defaults = {
				layout_strategy = "horizontal",
				layout_config = { prompt_position = "top" },
				sorting_strategy = "ascending",
				preview = { treesitter = false },
				hidden = true,
				mappings = {
					i = {
						["<C-j>"] = "move_selection_next",
						["<C-k>"] = "move_selection_previous",
					},
				},
				pickers = {
					find_files = { hidden = true },
					live_grep = {
						additional_args = function()
							return { "--hidden" }
						end,
					},
				},
			},
		},
		config = function(_, opts)
			require("telescope").setup(opts)
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "neoclip")
		end,
	},
}
