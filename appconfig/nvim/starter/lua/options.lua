require "nvchad.options"

-- add yours here!

local opt = vim.opt
local o = vim.o
local g = vim.g

-------------------------------------- globals -----------------------------------------
g.toggle_theme_icon = ""

-------------------------------------- options ------------------------------------------
o.laststatus = 3
o.showmode = false
o.title = true

o.clipboard = "unnamedplus"
o.cursorline = true
o.cursorlineopt = "number"

-- Indenting
o.expandtab = false
o.list = true
o.shiftwidth = 2
o.smartindent = true
o.tabstop = 2
o.softtabstop = 2

-- Numbers
o.number = true
o.numberwidth = 2
o.ruler = false
o.relativenumber = true
o.conceallevel = 2

-- disable nvim intro
opt.shortmess:append "sI"

opt.pumheight = 5
opt.completeopt = { "menuone", "noselect" } -- mostly just for cmp
opt.gcr = {
  "i-c-ci-ve:-block-TermCursor",
  "n-v:block-Curosr/lCursor",
  "o:hor50-Curosr/lCursor",
  "r-cr:hor20-Curosr/lCursor",
}

vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]

o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.timeoutlen = 400
o.undofile = true

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"
opt.fillchars:append { diff = "╱" }
