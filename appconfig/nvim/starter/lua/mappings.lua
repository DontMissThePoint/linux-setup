require "nvchad.mappings"

-- more keybinds!
local map = vim.keymap.set

-- general
map("n", ";", ":", {desc = "Enter command mode"})
map("n", "gh", "<Home>", {desc = "move cursor beginning of line"})
map("n", "gl", "<End>", {desc = "move cursor end of line"})
map("n", "<leader>.", ":cd %:p:h<CR>:pwd <cr>", {desc = "change workspace onto current location"})
map("c", "q", "xa <cr>", {desc = "Quit"})

--  fzf-lua
map("n", "<leader><leader>", function()
  require('fzf-lua').files({ cwd = '~/' })
end, {desc = "FZF"})

-- conform
map("n", "<leader>fm", function()
  require("conform").format()
end, {desc = "formatting"})

-- autosave
map("n", "gs", "<cmd> AutosaveToggle <cr>", {desc = "autosave toggle"})
map("n", "<leader>s", "<cmd> AutosaveToggle <cr>", {desc = "autosave toggle"})

-- zen
map("n", "<leader>za", ":ZenMode <cr>", {desc = "zen mode"})
map("n", "<leader>zz", ":ZenMode | TwilightEnable <cr>", {desc = "better focus"})
map("n", "<leader>zf", ":Twilight <cr>", {desc = "lime light"})

map("v", "<leader>zf", ":'<,'>ZenMode <cr>", {desc = "narrow text region"})

-- tmuxnavigation
map("n", "<C-h>", "<cmd> NvimTmuxNavigateLeft <cr>", {desc = "Left"})
map("n", "<C-j>", "<cmd> NvimTmuxNavigateDown <cr>", {desc = "Down"})
map("n", "<C-k>", "<cmd> NvimTmuxNavigateUp <cr>", {desc = "Up"})
map("n", "<C-l>", "<cmd> NvimTmuxNavigateRight <cr>", {desc = "Right"})
map("n", "<C-\\>", "<cmd> NvimTmuxNavigateLastActive <cr>", {desc = "Last active"})
map("n", "<C-Space>", "<cmd> NvimTmuxNavigateNext <cr>", {desc = "Next"})
