---@type MappingsTable
local M = {}

M.general = {
	n = {
		[";"] = { ":", "enter command mode", opts = { nowait = true } },
		["gh"] = { "<Home>", "Move cursor beginning of line" },
		["gl"] = { "<End>", "Move cursor end of line" },
		["gs"] = { "<cmd> AutosaveToggle <CR>", "Toggle autosave" },
		["<leader>."] = { "<cmd> cd %:p:h<CR>:pwd <CR>", "Change workspace onto current location" },
    ["<leader><leader>"] = { "<cmd> Telescope find_files<CR>", "Find files" },

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

M.truezen = {
	n = {
		["<leader>Za"] = { "<cmd> TZAtaraxis<CR>", "Zen mode" },
		["<leader>Zf"] = { "<cmd> TZFocus<CR>", "Focus current window" },
		["<leader>Zm"] = { "<cmd> TZMinimalist<CR>", "Disable UI components" },
		["<leader>Zn"] = { "<cmd> TZNarrow<CR>", "Narrow text region for better focus" },
	},
	v = {
		["<leader>Zn"] = { "<cmd> '<,'>TZNarrow<CR>", "Narrow text region for better focus" },
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
