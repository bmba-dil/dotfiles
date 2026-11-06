-- Synthwave Pro palette, ported from the Obsidian theme.
-- Source: ~/.config/nvim/reference/synthwave-pro.css
--   palettes  -> .theme-dark.swp-palette-*   (css:261-350)
--   depths    -> .theme-dark.swp-bg-*        (css:452-453)
--
-- To change the whole editor's look, edit the two lines marked SELECT below.
-- Everything downstream (highlights, lualine, bufferline, render-markdown)
-- reads from this file, so nothing else needs touching.

-- ---------------------------------------------------------------- SELECT --
-- "synthwave" | "outrun" | "miami" | "tokyo" | "soft"
local PALETTE = "miami"
-- "deep" | "medium" | "soft"
local DEPTH = "deep"
-- ---------------------------------------------------------------------------

local palettes = {
	-- Synthwave (default) -- magenta + cyan on indigo
	synthwave = {
		bgm1 = "#0c0a13",
		bg0 = "#14101f",
		bg1 = "#1a1530",
		bg2 = "#221a3d",
		bg3 = "#2c224d",
		bg4 = "#332858",
		line = "#3a2e63",
		text = "#ece6ff",
		muted = "#a89fcf",
		faint = "#6f6695",
		accent1 = "#ff3ec8", -- magenta
		accent2 = "#36e2ec", -- cyan
		accent3 = "#b56cff", -- purple
		accent4 = "#ffd23f", -- sun yellow
		success = "#5eead4",
		warning = "#ffb86b",
		error = "#ff6b9d",
		-- brackets: hues the palette doesn't already spend on syntax
		bracket = "#9dff6b", -- fallback, any language without a type override
		bracket_round = "#6ea8ff",
		bracket_square = "#ff7043",
		bracket_curly = "#ffe066",
	},

	-- Outrun -- orange + pink sunset
	outrun = {
		bgm1 = "#100913",
		bg0 = "#1a0f1f",
		bg1 = "#241324",
		bg2 = "#2e1a2e",
		bg3 = "#3b223a",
		bg4 = "#442842",
		line = "#4d2d4a",
		text = "#ffe8df",
		muted = "#d6a89f",
		faint = "#8a6160",
		accent1 = "#ff7a3d", -- orange
		accent2 = "#ff3e8c", -- hot pink
		accent3 = "#ffb547", -- amber
		accent4 = "#ff5577", -- red-pink
		success = "#7be0a7",
		warning = "#ffb86b",
		error = "#ff6b6b",
		-- palette is entirely warm, so cool brackets pop hardest
		bracket = "#a4e857",
		bracket_round = "#5ecfff",
		bracket_square = "#c58aff",
		bracket_curly = "#4de2c0",
	},

	-- Miami -- teal + hot pink
	miami = {
		bgm1 = "#08111a",
		bg0 = "#0d1b2a",
		bg1 = "#122438",
		bg2 = "#182f47",
		bg3 = "#1f3a57",
		bg4 = "#244262",
		line = "#2a4a6e",
		text = "#e6fbff",
		muted = "#8fc5d6",
		faint = "#5a7d8c",
		accent1 = "#ff4d8d",
		accent2 = "#2ee6c8",
		accent3 = "#5ec8ff",
		accent4 = "#ffe066",
		success = "#58e6b0",
		warning = "#ffc266",
		error = "#ff5d8d",
		bracket = "#a3f76b",
		bracket_round = "#c084fc",
		bracket_square = "#ffa14d",
		bracket_curly = "#ff5f5f",
	},

	-- Tokyo Night -- muted purple + blue
	tokyo = {
		bgm1 = "#0e0e13",
		bg0 = "#16161e",
		bg1 = "#1a1b26",
		bg2 = "#1f2030",
		bg3 = "#292e42",
		bg4 = "#323852",
		line = "#3b4261",
		text = "#c0caf5",
		muted = "#8089b3",
		faint = "#565f89",
		accent1 = "#bb9af7",
		accent2 = "#7aa2f7",
		accent3 = "#f7768e",
		accent4 = "#e0af68",
		success = "#9ece6a",
		warning = "#e0af68",
		error = "#f7768e",
		-- all canonical Tokyo Night colors
		bracket = "#b9f27c",
		bracket_round = "#7dcfff",
		bracket_square = "#2ac3de",
		bracket_curly = "#ff9e64",
	},

	-- Soft Reading -- desaturated, eye-comfort
	soft = {
		bgm1 = "#111018",
		bg0 = "#1c1a26",
		bg1 = "#232132",
		bg2 = "#2a283d",
		bg3 = "#353249",
		bg4 = "#3c3852",
		line = "#423e5c",
		text = "#e8e4f0",
		muted = "#a59cbd",
		faint = "#6e6688",
		accent1 = "#d18acb",
		accent2 = "#7bc4c9",
		accent3 = "#a48de0",
		accent4 = "#d6c279",
		success = "#8ec9b3",
		warning = "#d6a87a",
		error = "#d68a9c",
		-- kept desaturated so brackets don't break the eye-comfort intent
		bracket = "#9fd18a",
		bracket_round = "#8fb3e0",
		bracket_square = "#c9a37e",
		bracket_curly = "#bfa0d4",
	},
}

-- Background tracks each palette independently now, instead of being one hardcoded
-- block based on Miami
local depths = {
	deep = function(p)
		p.bg3, p.bg2, p.bg1, p.bg0 = p.bg2, p.bg1, p.bg0, p.bgm1
	end,
	medium = function(_) end,
	soft = function(p)
		p.bg0, p.bg1, p.bg2, p.bg3 = p.bg1, p.bg2, p.bg3, p.bg4
	end,
}

local base = palettes[PALETTE] or palettes.synthwave
local p = {}
for k, v in pairs(base) do
	p[k] = v
end
(depths[DEPTH] or depths.medium)(p)

p.name = PALETTE
p.depth = DEPTH

-- Background for NON-current windows. Normal stays bg = "NONE" so the terminal's opacity shows through the focused window -- an explicit bg on Normal becomes the screen default and every window inherits it.
p.unfocus_bg = p.bg0

-- Semantic aliases matching the CSS token map (css:219-230), so consumers can
-- read intent instead of guessing which accent does what.
p.code_keyword = p.accent1
p.code_function = p.accent2
p.code_property = p.accent3
p.code_string = p.accent4
p.code_value = p.success
p.code_operator = p.accent2
p.code_comment = p.faint
p.code_punctuation = p.muted

return p
