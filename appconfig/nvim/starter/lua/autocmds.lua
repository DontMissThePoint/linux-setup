local autocmd = vim.api.nvim_create_autocmd
local create_cmd = vim.api.nvim_create_user_command
local augroup = vim.api.nvim_create_augroup   -- Create/get autocommand group

-----------------------------------------------------------
-- General settings
-----------------------------------------------------------

-- Highlight on yank
augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
  group = 'YankHighlight',
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = '1000' })
  end
})

-- Remove whitespace on save
autocmd('BufWritePre', {
  pattern = '',
  command = ":%s/\\s\\+$//e"
})

-- Don't auto commenting new lines
autocmd('BufEnter', {
  pattern = '',
  command = 'set fo-=c fo-=r fo-=o'
})

-----------------------------------------------------------
-- Settings for filetypes
-----------------------------------------------------------

-- Disable line length marker
augroup('setLineLength', { clear = true })
autocmd('Filetype', {
  group = 'setLineLength',
  pattern = { 'text', 'markdown', 'html', 'xhtml', 'javascript', 'typescript' },
  command = 'setlocal cc=0'
})

-- Set indentation to 2 spaces
augroup('setIndent', { clear = true })
autocmd('Filetype', {
  group = 'setIndent',
  pattern = { 'xml', 'html', 'xhtml', 'css', 'scss', 'javascript', 'typescript',
    'yaml', 'lua'
  },
  command = 'setlocal shiftwidth=2 tabstop=2'
})

-----------------------------------------------------------
-- Terminal settings
-----------------------------------------------------------

-- Open a Terminal on the right tab
autocmd('CmdlineEnter', {
  command = 'command! Term :botright vsplit term://$SHELL'
})

-- Enter insert mode when switching to terminal
autocmd('TermOpen', {
  command = 'setlocal listchars= nonumber norelativenumber nocursorline',
})

autocmd('TermOpen', {
  pattern = '',
  command = 'startinsert'
})

-- Close terminal buffer on process exit
autocmd('BufLeave', {
  pattern = 'term://*',
  command = 'stopinsert'
})

-- Auto resize panes when resizing nvim window
autocmd("VimResized", {
	pattern = "*",
	command = "tabdo wincmd =",
})

-- Unset guicursor whenever it is changed
vim.cmd([[autocmd OptionSet * noautocmd set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
		  \,a:blinkwait750-blinkoff150-blinkon175-Cursor/lCursor
		  \,sm:block-blinkwait175-blinkoff150-blinkon175]])

-- Status
if vim.fn.exists("$TMUX") then
	vim.cmd([[
        augroup TmuxStatusToggle
            autocmd VimEnter,FocusGained,BufEnter,VimResume * silent !tmux setw status off
            autocmd VimLeave,VimSuspend * silent !tmux setw status on
        augroup end
    ]])
end

-- Fix libuv
autocmd({ "VimLeave" }, {
	callback = function()
		vim.cmd("sleep 10m")
	end,
})

-- Autosave
autocmd({ "BufLeave", "FocusLost" }, {
  desc = "Auto save",
  group = vim.api.nvim_create_augroup("group", { clear = true }),
  callback = function()
    local file_path = vim.fn.expand("%") or ""
    if vim.bo.modifiable and vim.bo.buftype == "" and vim.bo.buflisted and vim.fn.filereadable(file_path) == 1 then
      vim.cmd([[silent noa up]]) -- save but without triggering autocmds (no format)
    end
  end,
})

create_cmd("AutosaveToggle", function()
  vim.g.autosave = not vim.g.autosave

  if vim.g.autosave then
    autocmd({ "InsertLeave", "TextChanged" }, {
      group = vim.api.nvim_create_augroup("Autosave", {}),
      callback = function()
        if vim.api.nvim_buf_get_name(0) and #vim.bo.buftype ==0 then
          vim.cmd "silent w"
          vim.api.nvim_echo(
            { { "󰄳", "LazyProgressDone" }, { " File autosaved at " .. os.date "%I:%M %p" } },
            false,
            {}
          )

          -- clear msg after 500ms
          vim.defer_fn(function()
            vim.api.nvim_echo({}, false, {})
          end, 800)
        end
      end,
    })
  else
    vim.api.nvim_del_augroup_by_name "Autosave"
  end

end, {})

-- Auto command for saving cursor position
vim.cmd [[autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]]
vim.cmd [[autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif]]
vim.cmd [[autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o]]
