---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["gh"] = { "<Home>", "Move cursor beginning of line" },
    ["gl"] = { "<End>", "Move cursor end of line" },
    ["<leader>."] = { "<cmd> cd %:p:h<CR>:pwd <CR>", "Change workspace onto current location" },
  },
  v = {
    [">"] = { ">gv", "indent"},
  },
}

-- more keybinds!

M.truezen = {
  n = {
    ["<leader>ta"] = { "<cmd> TZAtaraxis<CR>", "Good ol' zen mode" },
    ["<leader>tf"] = { "<cmd> TZFocus<CR>", "Focus current window" },
    ["<leader>tm"] = { "<cmd> TZMinimalist<CR>", "Disable UI components" },
    ["<leader>tn"] = { "<cmd> TZNarrow<CR>", "Narrow text region for better focus" },
  },
  v = {
    ["<leader>tn"] = { "<cmd> '<,'>TZNarrow<CR>", "Narrow text region for better focus" },
  },
}

return M
