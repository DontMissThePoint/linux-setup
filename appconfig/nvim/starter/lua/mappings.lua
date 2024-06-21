require "nvchad.mappings"

-- more keybinds!
local map = vim.keymap.set

-- general
map("n", ";", ":", {desc = "Enter command mode"})
map("n", "gh", "<Home>", {desc = "move cursor beginning of line"})
map("n", "gl", "<End>", {desc = "move cursor end of line"})
map("n", "<leader>.", ":cd %:p:h<CR>:pwd <cr>", {desc = "change workspace onto current location"})

--  fzf-lua
map("n", "<C-p>", function() require("fzf-lua").files({ cwd = '~/' }) end, {desc = "fzf-lua files"})
map("n", "<leader>fe", function() require("fzf-lua").files({ cwd = '~/' }) end, {desc = "fzf-lua files"})
map("n", "<leader><leader>", function() require("fzf-lua").command_history() end, {desc = "FZF"})

-- conform
map("n", "<leader>fm", function() require("conform").format() end, {desc = "formatting"})

-- toggler
map("n", "<leader>i", function() require("nvim-toggler").toggle() end, {desc = "toggler"})
map("v", "<leader>i", function() require("nvim-toggler").toggle() end, {desc = "toggler"})

-- trouble
map("n", "<leader>tr", ":TroubleToggle<CR>", { desc = "trouble - toggle" })
map("n", "<leader>wd", ":TroubleToggle workspace_diagnostics<CR>", { desc = "trouble - workspace Diagnostics" })
map("n", "<leader>cq", "<CMD>TroubleToggle quickfix<CR>", { desc = "trouble - quickfix" })
map("n", "<leader>td", "<CMD>TodoTrouble<CR>", { desc = "trouble - todo" })
map("n", "gd", "<CMD>Trouble lsp_definitions<CR>", { desc = "trouble - definition" })
map("n", "gi", "<CMD>Trouble lsp_implementations<CR>", { desc = "trouble - implementations" })
map("n", "gD", "<CMD>Trouble lsp_type_definitions<CR>", { desc = "trouble - type definition" })

-- pomodoro timer
local ok, pomo = pcall(require, "pomo")
if not ok then
  return
end
local function start_new_timer()
  local timer = pomo.get_first_to_finish()
  if timer then
    vim.notify("a Timer is already running", vim.log.levels.INFO)
    return
  end
  pomo.start_timer(25 * 60, "work")
end

-- track milestones
map("n", "<leader>pm", function()
  start_new_timer()
end, { desc = "Pomo - Start new Timer", noremap = true, silent = true })
map("n", "<leader>ps", function()
  pomo.stop_timer()
end, { desc = "Pomo - Stop Timer", noremap = true, silent = true })

-- myeyes
map("n", "<leader>ms", function()
  require("myeyeshurt").start()
end, {desc = "myeyes start break"})
map("n", "<leader>mx", function()
  require("myeyeshurt").stop()
end, {desc = "myeyes stop flakes"})

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
