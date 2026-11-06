-- Color file names to match their devicon (nvim-web-devicons already assigns
-- each recognized extension its own highlight group/color; this reuses that
-- instead of a separate hand-picked palette, and stays plain/gray for
-- anything devicons doesn't recognize, e.g. .tar/.bak/.gz/no-extension --
-- same fallback behavior the icon column already has).
-- Must run BEFORE neo-tree's setup() call below: filesystem/buffers/
-- git_status components.lua each do
-- `vim.tbl_deep_extend("force", common_components, source_specific)` at
-- *require* time, which happens synchronously inside setup(). That snapshots
-- whatever common_components.name is at that instant, so patching it after
-- setup() runs would be silently ignored.
do
	local common_components = require("neo-tree.sources.common.components")
	local highlights = require("neo-tree.ui.highlights")
	local original_name = common_components.name
	common_components.name = function(config, node, state)
		local result = original_name(config, node, state)
		if node.type ~= "file" then
			return result
		end
		-- These two are more useful signals than filetype, so let them win over
		-- the devicon color. Everything else -- including dotfile/hidden/
		-- gitignored coloring inherited from a parent folder via
		-- children_inherit_highlights -- should not block the file's own type
		-- color, so devicon matching intentionally overrides those below.
		if result.highlight == highlights.FILE_NAME_OPENED then
			return result
		end
		if config.use_git_status_colors then
			local git_status = state.components.git_status({}, node, state)
			if git_status and git_status.highlight then
				return result
			end
		end
		local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
		if devicons_ok then
			local _, hl = devicons.get_icon(node.name)
			if hl then
				result.highlight = hl
			end
		end
		return result
	end
end

require("neo-tree").setup({
	close_if_last_window = false,
	popup_border_style = "NC",
	clipboard = {
		sync = "global",
	},
	enable_git_status = true,
	default_component_config = {
		container = {
			enable_character_fade = true,
		},
		indent = {
			indent_size = 2,
			padding = 1,
			with_markers = true,
			indent_marker = "|",
			last_indent_marker = "L",
			highlight = "NeoTreeIndentMarker",
			with_expanders = nil,
			expander_collapsed = " ",
			expander_expanded = " ",
			expander_highlight = "NeoTreeExpander",
		},
		icon = {
			folder_closed = " ",
			folder_open = " ",
			folder_empty = " ",
			provider = function(icon, node, state)
				if node.type == "file" or node.type == "terminal" then
					local success, web_devicons = pcall(require, "nvim-web-devicons")
					local name = node.type == "terminal" and "terminal" or node.name
					if success then
						local devicon, hl = web_devicons.get_icon(name)
						icon.text = devicon or icon.text
						icon.highlight = hl or icon.highlight
					end
				end
			end,
			default = "*",
			highlight = "NeoTreeFileIcon",
			use_filtered_icons = true,
		},
		modified = {
			symbol = "[+]",
			highlight = "NeoTreeFileIcon",
		},
		name = {
			trailing_slash = false,
			use_filtered_icons = true,
			use_git_status_colors = true,
			highlight = "NeoTreeFileName",
		},
		git_status = {
			symbol = {
				added = "+",
				modified = "~",
				deleted = "x",
				renamed = "r",
				untracked = "!",
				ignored = " ",
				unstaged = "u",
				staged = "s",
				conflict = "c",
			},
		},
		file_size = {
			enabled = false,
		},
		type = {
			enabled = true,
			width = 12,
			required_width = 122,
		},
		last_modified = {
			enabled = true,
			width = 20,
			required_width = 88,
		},
		created = {
			enabled = true,
			width = 20,
			required_width = 110,
		},
		symlink_target = {
			enabled = false,
		},
	},
	filesystem = {
		filtered_items = {
			visible = true, -- show everything (dotfiles, gitignored, etc.); nothing is ever hidden
		},
	},
	window = {
		position = "left",
		width = 16,
		mappings = {
			["<bs>"] = "navigate_up",
			["."] = "set_root",
			["w"] = "open_vsplit",
			["H"] = "toggle_hidden",
			["/"] = "fuzzy_finder",
			["D"] = "fuzzy_finder_directory",
			["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
			["f"] = "filter_on_submit",
			["<c-x>"] = "clear_filter",
			["[g"] = "prev_git_modified",
			["]g"] = "next_git_modified",
			["o"] = {
				"show_help",
				nowait = false,
				config = { title = "Order by", prefix_key = "o" },
			},
			["oc"] = { "order_by_created", nowait = false },
			["od"] = { "order_by_diagnostics", nowait = false },
			["og"] = { "order_by_git_status", nowait = false },
			["om"] = { "order_by_modified", nowait = false },
			["on"] = { "order_by_name", nowait = false },
			["os"] = { "order_by_size", nowait = false },
			["ot"] = { "order_by_type", nowait = false },
		},
	},
	commands = {}, -- Add a custom command or override a global one using the same function name
	buffers = {
		follow_current_file = {
			enabled = true, -- This will find and focus the file in the active buffer every time
			--              -- the current file is changed while the tree is open.
			leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
		},
		group_empty_dirs = true, -- when true, empty folders will be grouped together
		show_unloaded = true,
		window = {
			mappings = {
				["d"] = "buffer_delete",
				["bd"] = "buffer_delete",
				["<bs>"] = "navigate_up",
				["."] = "set_root",
				["o"] = {
					"show_help",
					nowait = false,
					config = { title = "Order by", prefix_key = "o" },
				},
				["oc"] = { "order_by_created", nowait = false },
				["od"] = { "order_by_diagnostics", nowait = false },
				["om"] = { "order_by_modified", nowait = false },
				["on"] = { "order_by_name", nowait = false },
				["os"] = { "order_by_size", nowait = false },
				["ot"] = { "order_by_type", nowait = false },
			},
		},
	},
	git_status = {
		window = {
			position = "float",
			mappings = {
				["A"] = "git_add_all",
				["gu"] = "git_unstage_file",
				["gU"] = "git_undo_last_commit",
				["ga"] = "git_add_file",
				["gt"] = "git_toggle_file_stage",
				["gr"] = "git_revert_file",
				["gc"] = "git_commit",
				["gp"] = "git_push",
				["gl"] = "git_pull",
				["gg"] = "git_commit_and_push",
				["o"] = {
					"show_help",
					nowait = false,
					config = { title = "Order by", prefix_key = "o" },
				},
				["oc"] = { "order_by_created", nowait = false },
				["od"] = { "order_by_diagnostics", nowait = false },
				["om"] = { "order_by_modified", nowait = false },
				["on"] = { "order_by_name", nowait = false },
				["os"] = { "order_by_size", nowait = false },
				["ot"] = { "order_by_type", nowait = false },
			},
		},
	},
})

-- Dotfiles are still tagged as "filtered" internally (that's what drives the
-- NeoTreeDotfile highlight) even though filtered_items.visible above means
-- they're never actually hidden. Recolor that group so it reads as "config
-- file" rather than the default dim gray. Neo-tree resets this highlight
-- group on every ColorScheme event (see highlights.lua), so reapply after.
local function set_dotfile_highlight()
	vim.api.nvim_set_hl(0, "NeoTreeDotfile", { fg = "#7dcfff", italic = true })
end
set_dotfile_highlight()
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = set_dotfile_highlight,
})

-- Grow the tree window as you navigate into deeper nesting so full names
-- render. neo-tree truncates each line to the *live* window width at draw
-- time (renderer.lua), so panning the viewport can't reveal already-cut
-- text -- the window has to actually be wider. Its own resize_monitor_timer
-- polls window width every ~50ms and redraws on change, so just resizing
-- here is enough; no manual refresh call needed.
local zoom_base_width = 16 -- matches window.width above
local zoom_per_level = 6
local zoom_depth_threshold = 2 -- levels to allow before growing
local zoom_max_width = 60

vim.api.nvim_create_autocmd("FileType", {
	pattern = "neo-tree",
	callback = function(args)
		vim.api.nvim_create_autocmd("CursorMoved", {
			buffer = args.buf,
			callback = function()
				local state = require("neo-tree.sources.manager").get_state_for_window()
				if not state or not state.tree or not state.winid then
					return
				end
				-- state.tree:get_node() calls vim.fn.win_findbuf() internally to
				-- locate the window; right after reopening with <leader>e there's a
				-- brief window where CursorMoved fires before that lookup resolves,
				-- which throws. Harmless to skip a frame here -- the next
				-- CursorMoved fires once things settle.
				local ok, node = pcall(function()
					return state.tree:get_node()
				end)
				if not ok or not node then
					return
				end
				local depth = node:get_depth()
				local target_width = math.min(
					zoom_max_width,
					zoom_base_width + math.max(0, depth - zoom_depth_threshold) * zoom_per_level
				)
				if vim.api.nvim_win_get_width(state.winid) ~= target_width then
					vim.api.nvim_win_set_width(state.winid, target_width)
				end
			end,
		})
	end,
})
