"Faster <Esc> to normal mode
imap jk <Esc>
imap jj <Esc>

"Record with qq, play with Q
nmap Q @q

"Remap j and k intuitively
nmap j gj
nmap k gk
"A more intuitive bol/eol navigation
nmap H ^
nmap L $

"Make K similar to J to join to above line
nmap K kJ

"Make `Y` yank to end of line (like `C` and `D`)
nmap Y y$
"Yank into clipboard
nmap gy "*y
vmap gy "*y
nmap gY "*y$
vmap gY "*y$
"Swap v and V
nmap V v
nmap v V
"Reselect visual selection after indenting
vmap < <gv
vmap > >gv

"Quick :nohl
nmap <C-h> :nohl<CR>
imap <C-h> <Esc>:nohl<CR>a
