---@type MappingsTable
local M = {}

M.general = {
	n = {
		[";"] = { ":", "enter command mode", opts = { nowait = true } },
		["gh"] = { "<Home>", "Move cursor beginning of line" },
		["gl"] = { "<End>", "Move cursor end of line" },
		["<leader>."] = { "<cmd> cd %:p:h<CR>:pwd <CR>", "Change workspace onto current location" },
    ["<leader><leader>"] = { "<cmd> lua require('fzf-lua').files()<CR>", "FZF" },

		--  format with conform
		["<leader>fm"] = {
			function()
				require("conform").format()
			end,
			"formatting",
		},
	},
	v = {
		[">"] = { ">gv", "indent" },
	},
}

-- more keybinds!
M.autosave = {
	n = {
		["<leader>s"]  = { "<cmd> AutosaveToggle <CR>", "Toggle autosave" },
		["gs"] = { "<cmd> AutosaveToggle <CR>", "Toggle autosave" },
	},
}

M.zen = {
	n = {
		["<leader>za"] = { "<cmd> ZenMode<CR>", "Zen mode" },
		["<leader>zz"] = { "<cmd> ZenMode | TwilightEnable<CR>", "Distraction free coding" },
		["<leader>zf"] = { "<cmd> Twilight<CR>", "Lime Light" },
	},
	v = {
		["<leader>z"] = { "<cmd> '<,'>ZenMode<CR>", "Narrow text region for better focus" },
	},
}

M.tmuxnavigation = {
	n = {
		["<C-h>"] = { "<cmd> NvimTmuxNavigateLeft<CR>", "Left" },
		["<C-j>"] = { "<cmd> NvimTmuxNavigateDown<CR>", "Down" },
		["<C-k>"] = { "<cmd> NvimTmuxNavigateUp<CR>", "Up" },
		["<C-l>"] = { "<cmd> NvimTmuxNavigateRight<CR>", "Right" },
		["<C-\\>"] = { "<cmd> NvimTmuxNavigateLastActive<CR>", "Last active" },
		["<C-Space>"] = { "<cmd> NvimTmuxNavigateNext<CR>", "Next" },
	},
}

return M
