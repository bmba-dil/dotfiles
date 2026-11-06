local p = require("config.palette")
local sel_bg = p.bg3

return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = { "nvim-tree/nvim-web-devicons", "famiu/bufdelete.nvim" },
	event = "VeryLazy",
	keys = {
		{ "<S-Right>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
		{ "<S-Left>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
		{ "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
		{ "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
		{ "<leader>bn", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
		{ "<leader>bp", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
		{ "<leader>bd", "<cmd>Bdelete<cr>", desc = "Close buffer" },
		{ "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Close other buffers" },
		{ "<leader>bP", "<cmd>BufferLineTogglePin<cr>", desc = "Toggle pin" },
		{ "<leader>bl", "<cmd>BufferLinePick<cr>", desc = "Pick buffer" },
		{ "<leader>bmn", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
		{ "<leader>bmp", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
		{ "<leader>1", "<cmd>BufferLineGoToBuffer 1<cr>", desc = "Buffer 1" },
		{ "<leader>2", "<cmd>BufferLineGoToBuffer 2<cr>", desc = "Buffer 2" },
		{ "<leader>3", "<cmd>BufferLineGoToBuffer 3<cr>", desc = "Buffer 3" },
		{ "<leader>4", "<cmd>BufferLineGoToBuffer 4<cr>", desc = "Buffer 4" },
		{ "<leader>5", "<cmd>BufferLineGoToBuffer 5<cr>", desc = "Buffer 5" },
	},
	opts = {
		options = {
			mode = "buffers", -- set to "tabs" to only show tabpages
			themable = true,
			numbers = "ordinal",
			close_command = "Bdelete! %d",
			name_formatter = function(buf)
				if buf.path:match("^oil://") then
					-- "oil:///Users/tmac/.config/nvim/lua/" -> "/Users/tmac/.config/nvim/lua"
					local dir = buf.path:gsub("^oil://", ""):gsub("/$", "")
					local name = vim.fn.fnamemodify(dir, ":t") -- last component: "lua"
					return "Oil" .. vim.fn.fnamemodify(dir, ":~")
				end
				-- anything else: return nil -> default label
			end,
			right_mouse_command = "Bdelete! %d",
			left_mouse_command = "buffer %d",
			middle_mouse_command = nil,
			indicator = {
				icon = "▎",
				style = "underline", -- underline indicator on the active buffer
			},
			buffer_close_icon = "󰅖",
			modified_icon = "●",
			close_icon = "",
			left_trunc_marker = "",
			right_trunc_marker = "",
			max_name_length = 18,
			max_prefix_length = 15,
			truncate_names = true,
			tab_size = 18,
			diagnostics = "nvim_lsp", -- lsp indicators
			diagnostics_update_in_insert = false,
			diagnostics_indicator = function(count, level, diagnostics_dict, context)
				local icons = { error = " ", warning = " ", info = " ", hint = " " }
				local s = " "
				for e, n in pairs(diagnostics_dict) do
					local sym = icons[e] or ""
					s = s .. sym .. n .. " "
				end
				return s
			end,
			offsets = {
				{
					filetype = "neo-tree",
					text = function()
						return vim.fn.getcwd()
					end,
					text_align = "center",
					separator = true,
				},
			},
			color_icons = true,
			show_buffer_icons = true,
			show_buffer_close_icons = true,
			show_close_icon = true,
			show_tab_indicators = true,
			show_duplicate_prefix = true,
			persist_buffer_sort = true,
			move_wraps_at_ends = false,
			separator_style = "thin",
			enforce_regular_tabs = false,
			always_show_bufferline = true,
			hover = {
				enabled = true, -- hover events on tabs
				delay = 200,
				reveal = { "close" },
			},
			sort_by = "id",
		},
		-- Every group is set explicitly. bufferline's defaults derive from
		-- Normal's background, which is "NONE" for terminal transparency --
		-- anything left unset collapses to grey.
		highlights = {
			fill = { bg = "NONE" },

			-- tabs
			background = { fg = p.muted, bg = "NONE" },
			buffer_visible = { fg = p.text, bg = "NONE" },
			buffer_selected = { fg = p.accent1, bg = sel_bg, bold = true, italic = false },

			-- ordinal numbers
			numbers = { fg = p.muted, bg = "NONE" },
			numbers_visible = { fg = p.text, bg = "NONE" },
			numbers_selected = { fg = p.accent1, bg = sel_bg, bold = true, italic = false },

			-- modified dot
			modified = { fg = p.warning, bg = "NONE" },
			modified_visible = { fg = p.warning, bg = "NONE" },
			modified_selected = { fg = p.success, bg = sel_bg },

			-- close buttons
			close_button = { fg = p.muted, bg = "NONE" },
			close_button_visible = { fg = p.text, bg = "NONE" },
			close_button_selected = { fg = p.error, bg = sel_bg },

			-- duplicate-name prefix
			duplicate = { fg = p.faint, bg = "NONE", italic = true },
			duplicate_visible = { fg = p.faint, bg = "NONE", italic = true },
			duplicate_selected = { fg = p.accent3, bg = sel_bg, italic = true },

			-- separators / indicator
			separator = { fg = p.line, bg = "NONE" },
			separator_visible = { fg = p.line, bg = "NONE" },
			separator_selected = { fg = p.line, bg = sel_bg },
			offset_separator = { fg = p.line, bg = "NONE" },
			indicator_visible = { fg = p.line, bg = "NONE" },
			indicator_selected = { fg = p.accent1, bg = sel_bg },

			-- diagnostics
			diagnostic = { fg = p.muted, bg = "NONE" },
			diagnostic_visible = { fg = p.muted, bg = "NONE" },
			diagnostic_selected = { fg = p.text, bg = sel_bg, bold = true },
			error = { fg = p.error, bg = "NONE" },
			error_visible = { fg = p.error, bg = "NONE" },
			error_selected = { fg = p.error, bg = sel_bg, bold = true },
			error_diagnostic = { fg = p.error, bg = "NONE" },
			error_diagnostic_visible = { fg = p.error, bg = "NONE" },
			error_diagnostic_selected = { fg = p.error, bg = sel_bg, bold = true },
			warning = { fg = p.warning, bg = "NONE" },
			warning_visible = { fg = p.warning, bg = "NONE" },
			warning_selected = { fg = p.warning, bg = sel_bg, bold = true },
			warning_diagnostic = { fg = p.warning, bg = "NONE" },
			warning_diagnostic_visible = { fg = p.warning, bg = "NONE" },
			warning_diagnostic_selected = { fg = p.warning, bg = sel_bg, bold = true },
			info = { fg = p.accent2, bg = "NONE" },
			info_visible = { fg = p.accent2, bg = "NONE" },
			info_selected = { fg = p.accent2, bg = sel_bg, bold = true },
			info_diagnostic = { fg = p.accent2, bg = "NONE" },
			info_diagnostic_visible = { fg = p.accent2, bg = "NONE" },
			info_diagnostic_selected = { fg = p.accent2, bg = sel_bg, bold = true },
			hint = { fg = p.muted, bg = "NONE" },
			hint_visible = { fg = p.muted, bg = "NONE" },
			hint_selected = { fg = p.muted, bg = sel_bg, bold = true },
			hint_diagnostic = { fg = p.muted, bg = "NONE" },
			hint_diagnostic_visible = { fg = p.muted, bg = "NONE" },
			hint_diagnostic_selected = { fg = p.muted, bg = sel_bg, bold = true },

			-- BufferLinePick
			pick = { fg = p.error, bg = "NONE", bold = true },
			pick_visible = { fg = p.error, bg = "NONE", bold = true },
			pick_selected = { fg = p.error, bg = sel_bg, bold = true },

			-- tabpages + truncation markers
			tab = { fg = p.muted, bg = "NONE" },
			tab_selected = { fg = p.accent1, bg = sel_bg, bold = true },
			tab_separator = { fg = p.line, bg = "NONE" },
			tab_separator_selected = { fg = p.line, bg = "NONE" },
			tab_close = { fg = p.error, bg = "NONE" },
			trunc_marker = { fg = p.faint, bg = "NONE" },
		},
	},
}
