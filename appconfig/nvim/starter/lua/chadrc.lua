---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require("highlights")

M.ui = {
	transparency = true,
	theme = "tokyodark",
	theme_toggle = { "tokyodark", "one_light" },

	-- Dashboard
	nvdash = {
		load_on_startup = true,
	},

	hl_override = {
		NvDashAscii = {
			bg = "none",
			fg = "nord_blue",
		},
		NvDashButtons = {
			bg = "none",
			fg = "light_grey",
		},
	},
	-- hl_override = highlights.override,
	hl_add = highlights.add,
}

-- M.plugins = "plugins"

-- check core.mappings for table structure
-- M.mappings = require("mappings")

return M
