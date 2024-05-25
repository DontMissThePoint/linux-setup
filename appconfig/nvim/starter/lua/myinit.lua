local autocmd = vim.api.nvim_create_autocmd
local create_cmd = vim.api.nvim_create_user_command

local set = vim.opt
set.fillchars:append({ diff = "╱" })

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
            autocmd VimEnter,BufEnter,VimResume * silent !tmux setw status off
            autocmd VimLeave,VimSuspend * silent !tmux setw status on
        augroup end
    ]])
end

-- Fix libuv
autocmd({ "VimLeave" }, {
	callback = function()
		vim.cmd("sleep 25m")
	end,
})

-- Autosave
create_cmd("AutosaveToggle", function()
  vim.g.autosave = not vim.g.autosave

  if vim.g.autosave then
    vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
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
