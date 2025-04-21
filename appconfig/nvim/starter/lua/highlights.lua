-- To find any highlight groups: "<cmd> Telescope highlights"
-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- base30 variable names can also be used as colors

local M = {}

---@type Base46HLGroupsList
M.override = {
	Comment = {
		italic = true,
	},
	Search = {
		bg = '#8bcd5b',
		fg = '#202020',
	},
	CursorLine = {
		bg = '#1A1A1F',
	},
	CursorColumn = {
		bg = '#1A1A1F',
	},
	Visual = {
		bg = '#103070',
	},
}

---@type HLTable
M.add = {
	NvimTreeOpenedFolderName = { fg = "green", bold = true },
}

return M
