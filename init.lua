vim.loader.enable() -- experimental neovim feature; cache neovim modules

local o = vim.opt

o.wrap = false
o.number = true
o.numberwidth = 2
o.relativenumber = true
o.signcolumn = "yes"
o.scrolloff = 8
o.sidescrolloff = 8
o.splitright = true
o.splitbelow = true

o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true

o.undofile = true
o.writebackup = false
o.backup = false
o.swapfile = false
o.viewoptions = "folds,cursor,"
o.viewdir = "/tmp/view//"

-- o.ignorecase = true
-- o.smartcase = true

o.updatetime = 50
o.isfname:append("@-@")
