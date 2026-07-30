-- leader must be set before lazy.nvim loads
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

-- ui
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.termguicolors = true
opt.showmode = false -- lualine shows it
opt.scrolloff = 8
opt.splitright = true
opt.splitbelow = true
opt.list = false -- matches Cursor "renderWhitespace": "none"

-- editing (matches Cursor: tabSize 2)
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.wrap = false

-- search
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split" -- live preview for :s

-- files
opt.undofile = true
opt.swapfile = false
opt.updatetime = 250

-- clipboard: use system clipboard for yank/paste
opt.clipboard = "unnamedplus"

-- completion
opt.completeopt = { "menu", "menuone", "noselect" }
