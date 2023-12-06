local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
autocmd("VimResized", {
  pattern = "*",
  command = "tabdo wincmd =",
})

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
