local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
autocmd("VimResized", {
  pattern = "*",
  command = "tabdo wincmd =",
})

-- Unset guicursor whenever it is changed
vim.cmd[[autocmd OptionSet * noautocmd set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
		  \,a:blinkwait750-blinkoff150-blinkon175-Cursor/lCursor
		  \,sm:block-blinkwait175-blinkoff150-blinkon175]]

-- Status
if vim.fn.exists('$TMUX') then
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
