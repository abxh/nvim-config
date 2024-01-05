require("autocmds")
vim.cmd("source " .. vim.fn.stdpath("config") .. "/lua/autocmds.vim")

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
local handle = io.popen("xdg-user-dir DESKTOP")
if (handle ~= nil) then
  local result = handle:read("*l")
  handle:close()
  o.undodir = result .. "/.undodir"
end

o.writebackup = false
o.backup = false
o.swapfile = false
o.viewoptions = "folds,cursor,"
o.viewdir = "/tmp/view//"

o.ignorecase = true
o.smartcase = true

o.updatetime = 50
o.isfname:append("@-@")

local keymaps = require("keymaps")
local opts = { noremap = true, silent = true }
if keymaps.leaderkey ~= nil then
  vim.keymap.set("", keymaps.leaderkey, "<Nop>", opts)
  vim.g.mapleader = keymaps.leaderkey
  vim.g.maplocalleader = keymaps.leaderkey
end
for _, value in pairs(keymaps.core) do
  vim.keymap.set(unpack(vim.list_extend(value, opts)))
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup(unpack(require("plugins")))
