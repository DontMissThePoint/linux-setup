local autocmd = vim.api.nvim_create_autocmd
local create_cmd = vim.api.nvim_create_user_command
local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group

-----------------------------------------------------------
-- General settings
-----------------------------------------------------------

-- Highlight on yank
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    vim.highlight.on_yank { higroup = "Visual", timeout = "1000" }
  end,
})

-- Remove whitespace on save
autocmd("BufWritePre", {
  pattern = "",
  command = ":%s/\\s\\+$//e",
})

-- Don't auto commenting new lines
autocmd("BufEnter", {
  pattern = "",
  command = "set fo-=c fo-=r fo-=o",
})

-----------------------------------------------------------
-- Settings for filetypes
-----------------------------------------------------------

-- Disable line length marker
augroup("setLineLength", { clear = true })
autocmd("Filetype", {
  group = "setLineLength",
  pattern = { "text", "markdown", "html", "xhtml", "javascript", "typescript" },
  command = "setlocal cc=0",
})

-- Set indentation to 2 spaces
augroup("setIndent", { clear = true })
autocmd("Filetype", {
  group = "setIndent",
  pattern = { "xml", "html", "xhtml", "css", "scss", "javascript", "typescript", "yaml", "lua" },
  command = "setlocal shiftwidth=2 tabstop=2",
})

autocmd("BufWritePost", {
  pattern = { "*.sh", "*.py" },
  callback = function()
    local file = vim.fn.expand "<afile>"
    if vim.fn.getline(1):match "^#!" then
      vim.fn.jobstart({ "chmod", "+x", file }, {
        detach = true,
        on_exit = function()
          vim.schedule(function()
            vim.notify("chmod +x " .. file, vim.log.levels.INFO, { title = "Saved!" })
          end)
        end,
      })
    end
  end,
  desc = "Auto chmod +x script",
})

-- close some filetypes with <q>
autocmd("FileType", {
  group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-----------------------------------------------------------
-- Terminal settings
-----------------------------------------------------------

-- Open a Terminal on the right tab
autocmd("CmdlineEnter", {
  command = "command! Term :botright vsplit term://$SHELL",
})

-- Enter insert mode when switching to terminal
autocmd("TermOpen", {
  command = "setlocal listchars= nonumber norelativenumber nocursorline",
})

autocmd("TermOpen", {
  pattern = "",
  command = "startinsert",
})

-- Close terminal buffer on process exit
autocmd("BufLeave", {
  pattern = "term://*",
  command = "stopinsert",
})

-- Auto resize panes when resizing nvim window
autocmd("VimResized", {
  pattern = "*",
  command = "tabdo wincmd =",
})

-- Screen cast 
autocmd("VimEnter", {
  pattern = "",
  command = "Screenkey",
})

-- Unset guicursor whenever it is changed
vim.cmd [[autocmd OptionSet * noautocmd set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
		  \,a:blinkwait750-blinkoff150-blinkon175-Cursor/lCursor
		  \,sm:block-blinkwait175-blinkoff150-blinkon175]]

-- Status
if vim.fn.exists "$TMUX" then
  vim.cmd [[
        augroup TmuxStatusToggle
            autocmd VimEnter,FocusGained,BufEnter,VimResume * silent !tmux setw status off
            autocmd VimLeave,VimSuspend * silent !tmux setw status on
        augroup end
    ]]
end

-- Formatting
if client.resolved_capabilities.document_formatting then
  vim.cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()"
end

-- Fix libuv
autocmd({ "VimLeave" }, {
  callback = function()
    vim.cmd "sleep 10m"
  end,
})

-- opening a buffer
-- at the last position
autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- toggle relative number on the basis of mode
local ngroup = augroup("numbertoggle", {})

autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
  pattern = "*",
  group = ngroup,
  callback = function()
    if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
      vim.opt.relativenumber = true
    end
  end,
})

autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
  pattern = "*",
  group = ngroup,
  callback = function()
    if vim.o.nu then
      vim.opt.relativenumber = false
      vim.cmd "redraw"
    end
  end,
})

-- to make border as same as neovim ColorScheme
autocmd({ "UIEnter", "ColorScheme" }, {
  callback = function()
    local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
    if not normal.bg then
      return
    end
    io.write(string.format("\027Ptmux;\027\027]11;#%06x\007\027\\", normal.bg))
    io.write(string.format("\027]11;#%06x\027\\", normal.bg))
  end,
})

autocmd("UILeave", {
  callback = function()
    io.write "\027Ptmux;\027\027]111;\007\027\\"
    io.write "\027]111\027\\"
  end,
})
