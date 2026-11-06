-- Applies the Synthwave Pro palette to Neovim.
-- Colors come from lua/config/palette.lua -- change the palette there, not here.
--
-- Two halves:
--   1. Legacy Vim groups (Comment, Keyword, ...) -- these are what most
--      treesitter captures fall back to by default.
--   2. Explicit @treesitter captures -- the fine-grained ones the legacy
--      groups can't reach (parameters, decorators, method calls, self, ...).
--
-- Normal has bg = "NONE" on purpose: that is what lets Ghostty's
-- background-opacity show through. Anything that needs a real background
-- reads it from the palette instead of deriving it from Normal.

local p = require("config.palette")

local M = {}

function M.apply()
	vim.o.termguicolors = true
	vim.o.background = "dark"

	-- Reset first so switching palettes doesn't leave stale colors behind on
	-- any group this file doesn't explicitly set.
	vim.cmd("hi clear")
	if vim.fn.exists("syntax_on") == 1 then
		vim.cmd("syntax reset")
	end
	vim.g.colors_name = "synthwave-pro"

	local groups = {
		-- ------------------------------------------------------------ editor
		Normal = { fg = p.text, bg = "NONE" }, -- focused
		NormalNC = { fg = p.text, bg = p.unfocus_bg },
		NormalFloat = { fg = p.text, bg = p.bg2 },
		FloatBorder = { fg = p.line, bg = p.bg2 },
		FloatTitle = { fg = p.accent1, bg = p.bg2, bold = true },
		Cursor = { fg = p.bg0, bg = p.accent1 },
		lCursor = { fg = p.bg0, bg = p.accent1 },
		CursorLine = { bg = p.bg2 },
		CursorColumn = { bg = p.bg2 },
		ColorColumn = { bg = p.bg2 },
		LineNr = { fg = p.faint },
		CursorLineNr = { fg = p.accent3, bold = true },
		SignColumn = { fg = p.faint },
		FoldColumn = { fg = p.faint },
		Folded = { fg = p.muted, bg = p.bg2, italic = true },
		VertSplit = { fg = p.line },
		WinSeparator = { fg = p.line },
		Visual = { bg = p.bg3 },
		VisualNOS = { bg = p.bg3 },
		Search = { fg = p.bg0, bg = p.accent3 },
		IncSearch = { fg = p.bg0, bg = p.accent1 },
		CurSearch = { fg = p.bg0, bg = p.accent1 },
		Substitute = { fg = p.bg0, bg = p.accent4 },
		MatchParen = { fg = p.accent2, bold = true, underline = true },
		NonText = { fg = p.line },
		EndOfBuffer = { fg = p.bg1 },
		SpecialKey = { fg = p.line },
		Whitespace = { fg = p.line },
		Conceal = { fg = p.faint },
		Directory = { fg = p.accent2 },
		Title = { fg = p.accent1, bold = true },
		Question = { fg = p.success },
		ModeMsg = { fg = p.accent3, bold = true },
		MoreMsg = { fg = p.success },
		WarningMsg = { fg = p.warning },
		ErrorMsg = { fg = p.error, bold = true },
		Error = { fg = p.error },
		Todo = { fg = p.bg0, bg = p.warning, bold = true },
		QuickFixLine = { bg = p.bg3 },
		Pmenu = { fg = p.text, bg = p.bg2 },
		PmenuSel = { fg = p.bg0, bg = p.accent1, bold = true },
		PmenuSbar = { bg = p.bg3 },
		PmenuThumb = { bg = p.line },
		PmenuKind = { fg = p.accent3, bg = p.bg2 },
		PmenuExtra = { fg = p.muted, bg = p.bg2 },
		WildMenu = { fg = p.bg0, bg = p.accent1 },
		StatusLine = { fg = p.text, bg = p.bg2 },
		StatusLineNC = { fg = p.faint, bg = p.bg1 },
		TabLine = { fg = p.muted, bg = p.bg1 },
		TabLineFill = { bg = "NONE" },
		TabLineSel = { fg = p.accent1, bg = p.bg2, bold = true },
		WinBar = { fg = p.muted },
		WinBarNC = { fg = p.faint },

		-- -------------------------------------------------------------- diff
		DiffAdd = { fg = p.success, bg = p.bg2 },
		DiffChange = { fg = p.warning, bg = p.bg2 },
		DiffDelete = { fg = p.error, bg = p.bg2 },
		DiffText = { fg = p.accent2, bg = p.bg3 },

		-- ------------------------------------------------- legacy syntax
		Comment = { fg = p.faint, italic = true },
		Constant = { fg = p.success },
		String = { fg = p.accent4 },
		Character = { fg = p.accent4 },
		Number = { fg = p.success },
		Boolean = { fg = p.success },
		Float = { fg = p.success },
		Identifier = { fg = p.text },
		Function = { fg = p.accent2 },
		Statement = { fg = p.accent1 },
		Conditional = { fg = p.accent1 },
		Repeat = { fg = p.accent1 },
		Label = { fg = p.accent3 },
		Operator = { fg = p.accent2 },
		Keyword = { fg = p.accent1 },
		Exception = { fg = p.error },
		PreProc = { fg = p.accent3 },
		Include = { fg = p.accent1 },
		Define = { fg = p.accent3 },
		Macro = { fg = p.accent3 },
		PreCondit = { fg = p.accent3 },
		Type = { fg = p.accent3 },
		StorageClass = { fg = p.accent1 },
		Structure = { fg = p.accent3 },
		Typedef = { fg = p.accent3 },
		Special = { fg = p.accent2 },
		SpecialChar = { fg = p.accent4 },
		Tag = { fg = p.accent1 },
		Delimiter = { fg = p.muted },
		SpecialComment = { fg = p.muted, italic = true },
		Debug = { fg = p.error },
		Underlined = { fg = p.accent2, underline = true },
		Ignore = { fg = p.faint },

		-- ------------------------------------------------------------- spell
		SpellBad = { sp = p.error, undercurl = true },
		SpellCap = { sp = p.warning, undercurl = true },
		SpellLocal = { sp = p.accent2, undercurl = true },
		SpellRare = { sp = p.accent3, undercurl = true },

		-- ------------------------------------------------------- diagnostics
		DiagnosticError = { fg = p.error },
		DiagnosticWarn = { fg = p.warning },
		DiagnosticInfo = { fg = p.accent2 },
		DiagnosticHint = { fg = p.muted },
		DiagnosticOk = { fg = p.success },
		DiagnosticUnderlineError = { sp = p.error, undercurl = true },
		DiagnosticUnderlineWarn = { sp = p.warning, undercurl = true },
		DiagnosticUnderlineInfo = { sp = p.accent2, undercurl = true },
		DiagnosticUnderlineHint = { sp = p.muted, undercurl = true },
		DiagnosticUnderlineOk = { sp = p.success, undercurl = true },
		DiagnosticVirtualTextError = { fg = p.error, bg = p.bg2 },
		DiagnosticVirtualTextWarn = { fg = p.warning, bg = p.bg2 },
		DiagnosticVirtualTextInfo = { fg = p.accent2, bg = p.bg2 },
		DiagnosticVirtualTextHint = { fg = p.muted, bg = p.bg2 },

		-- --------------------------------------------------------------- lsp
		LspReferenceText = { bg = p.bg3 },
		LspReferenceRead = { bg = p.bg3 },
		LspReferenceWrite = { bg = p.bg3, underline = true },
		LspInlayHint = { fg = p.faint, italic = true },
		LspSignatureActiveParameter = { fg = p.accent1, bold = true },

		-- ------------------------------- treesitter: variables & constants
		["@variable"] = { fg = p.text },
		["@variable.builtin"] = { fg = p.error, italic = true }, -- self, cls, this
		["@variable.parameter"] = { fg = p.text }, -- was uncolored
		["@variable.parameter.builtin"] = { fg = p.text, italic = true },
		["@variable.member"] = { fg = p.accent3 }, -- obj.field
		["@constant"] = { fg = p.success },
		["@constant.builtin"] = { fg = p.success, italic = true }, -- True/False/None
		["@constant.macro"] = { fg = p.accent3 },
		["@module"] = { fg = p.accent3 },
		["@module.builtin"] = { fg = p.accent3, italic = true },
		["@label"] = { fg = p.accent3 },

		-- --------------------------------- treesitter: literals & strings
		["@string"] = { fg = p.accent4 },
		["@string.documentation"] = { fg = p.success, italic = true }, -- python """docstrings"""
		["@string.regexp"] = { fg = p.accent2 },
		["@string.escape"] = { fg = p.accent2, bold = true },
		["@string.special"] = { fg = p.accent2 },
		["@string.special.path"] = { fg = p.accent2, underline = true },
		["@string.special.url"] = { fg = p.accent2, underline = true },
		["@character"] = { fg = p.accent4 },
		["@character.special"] = { fg = p.accent2 },
		["@boolean"] = { fg = p.success, italic = true },
		["@number"] = { fg = p.success },
		["@number.float"] = { fg = p.success },

		-- ------------------------------- treesitter: types & functions
		["@type"] = { fg = p.accent3 },
		["@type.builtin"] = { fg = p.accent3, italic = true },
		["@type.definition"] = { fg = p.accent3 },
		["@attribute"] = { fg = p.accent3, italic = true }, -- @decorators, was uncolored
		["@attribute.builtin"] = { fg = p.accent3, italic = true },
		["@property"] = { fg = p.success },
		["@function"] = { fg = p.accent2 },
		["@function.builtin"] = { fg = p.accent2, italic = true },
		["@function.call"] = { fg = p.accent2 },
		["@function.macro"] = { fg = p.accent3 },
		["@function.method"] = { fg = p.accent2 },
		["@function.method.call"] = { fg = p.accent2 }, -- was uncolored
		["@constructor"] = { fg = p.accent3, bold = true },
		["@operator"] = { fg = p.accent2 },

		-- ------------------------------------- treesitter: keywords
		["@keyword"] = { fg = p.accent1 },
		["@keyword.coroutine"] = { fg = p.accent1, italic = true }, -- async/await
		["@keyword.function"] = { fg = p.accent1 }, -- def, lambda
		["@keyword.operator"] = { fg = p.accent1 }, -- and, or, not, in
		["@keyword.import"] = { fg = p.accent1 },
		["@keyword.type"] = { fg = p.accent1 },
		["@keyword.modifier"] = { fg = p.accent1 },
		["@keyword.repeat"] = { fg = p.accent1 },
		["@keyword.return"] = { fg = p.accent1, bold = true },
		["@keyword.debug"] = { fg = p.error },
		["@keyword.exception"] = { fg = p.error },
		["@keyword.conditional"] = { fg = p.accent1 },
		["@keyword.conditional.ternary"] = { fg = p.accent1 },
		["@keyword.directive"] = { fg = p.accent3 },
		["@keyword.directive.define"] = { fg = p.accent3 },

		-- --------------------------- treesitter: punctuation & comments
		["@punctuation.delimiter"] = { fg = p.muted },
		["@punctuation.special"] = { fg = p.accent2 }, -- f-string braces

		-- Brackets. Neovim has no built-in capture that tells (, [ and {
		-- apart, so after/queries/<lang>/highlights.scm adds the three
		-- .round/.square/.curly captures below. Unknown captures fall back
		-- down the dot-chain, so any language without an override file just
		-- lands on @punctuation.bracket.
		["@punctuation.bracket"] = { fg = p.bracket, bold = false },
		["@punctuation.bracket.round"] = { fg = p.bracket_round, bold = false },
		["@punctuation.bracket.square"] = { fg = p.bracket_square, bold = false },
		["@punctuation.bracket.curly"] = { fg = p.bracket_curly, bold = false },
		["@comment"] = { fg = p.faint, italic = true },
		["@comment.documentation"] = { fg = p.muted, italic = true },
		["@comment.error"] = { fg = p.bg0, bg = p.error, bold = true },
		["@comment.warning"] = { fg = p.bg0, bg = p.warning, bold = true },
		["@comment.todo"] = { fg = p.bg0, bg = p.accent3, bold = true },
		["@comment.note"] = { fg = p.bg0, bg = p.accent2, bold = true },

		-- ------------------------------------------ treesitter: markup/tags
		["@tag"] = { fg = p.accent1 },
		["@tag.builtin"] = { fg = p.accent1 },
		["@tag.attribute"] = { fg = p.accent3 },
		["@tag.delimiter"] = { fg = p.muted },
		["@diff.plus"] = { fg = p.success },
		["@diff.minus"] = { fg = p.error },
		["@diff.delta"] = { fg = p.warning },
		["@error"] = { fg = p.error },

		["@markup.heading.1.markdown"] = { fg = p.accent1, bold = true },
		["@markup.heading.2.markdown"] = { fg = p.accent2, bold = true },
		["@markup.heading.3.markdown"] = { fg = p.accent3, bold = true },
		["@markup.heading.4.markdown"] = { fg = p.accent4, bold = true },
		["@markup.heading.5.markdown"] = { fg = p.success, bold = true },
		["@markup.heading.6.markdown"] = { fg = p.muted, bold = true },
		["@markup.strong"] = { fg = p.accent1, bold = true },
		["@markup.italic"] = { fg = p.accent3, italic = true },
		["@markup.strikethrough"] = { fg = p.faint, strikethrough = true },
		["@markup.underline"] = { underline = true },
		["@markup.raw"] = { fg = p.accent4 },
		["@markup.raw.block"] = { fg = p.text },
		["@markup.link"] = { fg = p.accent2 },
		["@markup.link.url"] = { fg = p.accent2, underline = true },
		["@markup.link.label"] = { fg = p.accent3 },
		["@markup.list"] = { fg = p.accent1 },
		["@markup.list.checked"] = { fg = p.success },
		["@markup.list.unchecked"] = { fg = p.muted },
		["@markup.quote"] = { fg = p.muted, italic = true },
		["@markup.math"] = { fg = p.accent2 },

		-- --------------------------------------------- render-markdown.nvim
		RenderMarkdownH1 = { fg = p.accent1, bold = true },
		RenderMarkdownH2 = { fg = p.accent2, bold = true },
		RenderMarkdownH3 = { fg = p.accent3, bold = true },
		RenderMarkdownH4 = { fg = p.accent4, bold = true },
		RenderMarkdownH5 = { fg = p.success, bold = true },
		RenderMarkdownH6 = { fg = p.muted, bold = true },
		-- Only visible if you re-enable heading.backgrounds in the plugin spec.
		RenderMarkdownH1Bg = { fg = p.accent1, bg = p.bg3 },
		RenderMarkdownH2Bg = { fg = p.accent2, bg = p.bg2 },
		RenderMarkdownH3Bg = { fg = p.accent3, bg = p.bg2 },
		RenderMarkdownH4Bg = { fg = p.accent4, bg = p.bg2 },
		RenderMarkdownH5Bg = { fg = p.success, bg = p.bg2 },
		RenderMarkdownH6Bg = { fg = p.muted, bg = p.bg2 },
		RenderMarkdownCode = { bg = p.bg0 },
		RenderMarkdownCodeInline = { fg = p.accent4, bg = p.bg2 },
		RenderMarkdownBullet = { fg = p.accent1 },
		RenderMarkdownDash = { fg = p.line },
		RenderMarkdownQuote = { fg = p.muted },
		RenderMarkdownTableHead = { fg = p.accent2 },
		RenderMarkdownTableRow = { fg = p.muted },
		RenderMarkdownLink = { fg = p.accent2 },
		RenderMarkdownChecked = { fg = p.success },
		RenderMarkdownUnchecked = { fg = p.muted },
		RenderMarkdownTodo = { fg = p.warning },
		RenderMarkdownInfo = { fg = p.accent2 },
		RenderMarkdownSuccess = { fg = p.success },
		RenderMarkdownHint = { fg = p.accent3 },
		RenderMarkdownWarn = { fg = p.warning },
		RenderMarkdownError = { fg = p.error },

		-- ------------------------------------------------------- neo-tree
		NeoTreeNormal = { fg = p.text, bg = "NONE" },
		NeoTreeNormalNC = { fg = p.text, bg = p.unfocus_bg },
		NeoTreeEndOfBuffer = { fg = p.bg1 },
		NeoTreeWinSeparator = { fg = p.line, bg = "NONE" },
		NeoTreeRootName = { fg = p.accent1, bold = true },
		NeoTreeDirectoryName = { fg = p.accent4 },
		NeoTreeDirectoryIcon = { fg = p.accent2 },
		NeoTreeFileName = { fg = p.text },
		NeoTreeFileNameOpened = { fg = p.accent3 },
		NeoTreeIndentMarker = { fg = p.line },
		NeoTreeExpander = { fg = p.faint },
		NeoTreeCursorLine = { bg = p.bg2 },
		NeoTreeTitleBar = { fg = p.bg0, bg = p.accent1, bold = true },
		NeoTreeGitAdded = { fg = p.success },
		NeoTreeGitModified = { fg = p.warning },
		NeoTreeGitDeleted = { fg = p.error },
		NeoTreeGitUntracked = { fg = p.muted },
		NeoTreeGitConflict = { fg = p.error, bold = true },
		NeoTreeGitIgnored = { fg = p.faint },

		-- ------------------------------------------------------ telescope
		TelescopeNormal = { fg = p.text, bg = p.bg1 },
		TelescopeBorder = { fg = p.line, bg = p.bg1 },
		TelescopeTitle = { fg = p.bg0, bg = p.accent1, bold = true },
		TelescopePromptNormal = { fg = p.text, bg = p.bg2 },
		TelescopePromptBorder = { fg = p.bg2, bg = p.bg2 },
		TelescopePromptTitle = { fg = p.bg0, bg = p.accent1, bold = true },
		TelescopePromptPrefix = { fg = p.accent1 },
		TelescopeResultsNormal = { fg = p.muted, bg = p.bg1 },
		TelescopePreviewNormal = { fg = p.text, bg = p.bg1 },
		TelescopePreviewTitle = { fg = p.bg0, bg = p.success, bold = true },
		TelescopeSelection = { fg = p.text, bg = p.bg3 },
		TelescopeSelectionCaret = { fg = p.accent1, bg = p.bg3 },
		TelescopeMatching = { fg = p.accent3, bold = true },

		-- ------------------------------------------------------- blink.cmp
		BlinkCmpMenu = { fg = p.text, bg = p.bg2 },
		BlinkCmpMenuBorder = { fg = p.line, bg = p.bg2 },
		BlinkCmpMenuSelection = { bg = p.bg3 },
		BlinkCmpLabel = { fg = p.text },
		BlinkCmpLabelMatch = { fg = p.accent1, bold = true },
		BlinkCmpLabelDeprecated = { fg = p.faint, strikethrough = true },
		BlinkCmpKind = { fg = p.accent3 },
		BlinkCmpSource = { fg = p.faint },
		BlinkCmpDoc = { fg = p.text, bg = p.bg2 },
		BlinkCmpDocBorder = { fg = p.line, bg = p.bg2 },
		BlinkCmpSignatureHelp = { fg = p.text, bg = p.bg2 },

		-- ---------------------------------------------------------- fidget
		FidgetTitle = { fg = p.accent2, bold = true },
		FidgetTask = { fg = p.muted },

		-- ------------------------------------------------- nand2tetris HDL
		-- One hue per pin name, so a signal can be picked out of a wall of
		-- near-identical Mux/And/Or parts. Derived wires inherit the hue of
		-- the pin they start from (aAndNsel -> a, notSel -> sel); see
		-- syntax/hdl.vim for which names land in which bucket.
		hdlPinA = { fg = p.bracket_round }, -- a
		hdlPinB = { fg = p.bracket }, -- b
		hdlPinC = { fg = p.bracket_square }, -- c
		hdlPinD = { fg = p.bracket_curly }, -- d
		hdlPinSel = { fg = p.accent1 }, -- sel
		hdlPinIn = { fg = p.accent3 }, -- in
		hdlPinOut = { fg = p.accent2 }, -- out
		hdlPinCtrl = { fg = p.warning }, -- load, reset, inc, address
		hdlPinAlu = { fg = p.success }, -- x, y, zx, nx, ... zr, ng
		hdlPinCpu = { fg = p.accent4 }, -- instruction, inM, outM, pc, ...
		hdlPin = { fg = p.text }, -- any pin name not in a bucket
		-- recessive on purpose: the pin names either side should carry the eye
		hdlEquals = { fg = p.faint },
	}

	for name, opts in pairs(groups) do
		vim.api.nvim_set_hl(0, name, opts)
	end

	-- Let plugins that cache colors (lualine, bufferline) recompute.
	vim.api.nvim_exec_autocmds("ColorScheme", { pattern = "synthwave-pro" })
end

M.apply()

return M
