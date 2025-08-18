-- options -------------------------------------------------------------------------------------------------------------

vim.opt.wrap = false
vim.opt.number = true
vim.opt.numberwidth = 2
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.undofile = true
vim.opt.writebackup = false
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.viewoptions = "folds,cursor,"
vim.opt.viewdir = "/tmp/view//"

-- vim.opt.ignorecase = true
-- vim.opt.smartcase = true

vim.opt.updatetime = 50
vim.opt.isfname:append("@-@")

-- vim.opt.winborder = "rounded"

-- keymaps ------------------------------------------------------------------------------------------------------------

local KEYMAP_OPTS = { silent = true, noremap = true }

vim.g.mapleader = ","
vim.g.maplocalleader = vim.g.mapleader

-- remap <Esc>
vim.keymap.set("n", "<Esc>", function()
  -- close floating windows
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative == "win" then
      vim.api.nvim_win_close(win, false)
    end
  end
  -- clear search
  if vim.bo.modifiable then
    vim.cmd("nohlsearch")
  end
end, KEYMAP_OPTS)
vim.keymap.set("i", "<C-c>", "<Esc>", KEYMAP_OPTS)

-- paste as usual
vim.keymap.set("x", "p", '"_dP', KEYMAP_OPTS)

-- move text
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", KEYMAP_OPTS)
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", KEYMAP_OPTS)

-- fix cursor at position while doing these actions
vim.keymap.set("n", "J", "mzJ`z", KEYMAP_OPTS)
vim.keymap.set("v", "<", "<gv^", KEYMAP_OPTS)
vim.keymap.set("v", ">", ">gv^", KEYMAP_OPTS)

-- stay in the middle while doing these actions
vim.keymap.set("n", "<PageUp>", "<C-u>zz", KEYMAP_OPTS)
vim.keymap.set("n", "<PageDown>", "<C-d>zz", KEYMAP_OPTS)
vim.keymap.set("n", "n", "nzzzv", KEYMAP_OPTS)
vim.keymap.set("n", "N", "Nzzzv", KEYMAP_OPTS)

-- access global clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', KEYMAP_OPTS)
vim.keymap.set("n", "<leader>Y", '"+Y', KEYMAP_OPTS)
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', KEYMAP_OPTS)
vim.keymap.set("n", "<leader>p", '"+p', KEYMAP_OPTS)
vim.keymap.set("v", "<leader>p", 'c<Esc>"+p', KEYMAP_OPTS)

-- terminal
vim.keymap.set("n", "<A-S-t>", function()
  vim.api.nvim_command(":split")
  for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
    local buffer_name = vim.api.nvim_buf_get_name(buffer)

    if string.sub(buffer_name, 1, 7) == "term://" then
      vim.api.nvim_win_set_buf(0, buffer)
      vim.api.nvim_feedkeys("i", "n", false)
      return
    end
  end
  vim.api.nvim_command(":terminal")
  vim.api.nvim_feedkeys("i", "n", false)
end, KEYMAP_OPTS)
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>:hide<CR>", KEYMAP_OPTS)

-- windows split / close
vim.keymap.set("n", "<A-v>", ":vsplit<CR>", KEYMAP_OPTS)
vim.keymap.set("n", "<A-b>", ":split<CR>", KEYMAP_OPTS)
vim.keymap.set("n", "<A-S-q>", ":q!<CR>", KEYMAP_OPTS)

-- window navigation
vim.keymap.set("n", "<A-k>", "<C-w>k", KEYMAP_OPTS)
vim.keymap.set("n", "<A-j>", "<C-w>j", KEYMAP_OPTS)
vim.keymap.set("n", "<A-h>", "<C-w>h", KEYMAP_OPTS)
vim.keymap.set("n", "<A-l>", "<C-w>l", KEYMAP_OPTS)

-- window resize
vim.keymap.set("n", "<A-S-k>", ":resize +2<CR>", KEYMAP_OPTS)
vim.keymap.set("n", "<A-S-j>", ":resize -2<CR>", KEYMAP_OPTS)
vim.keymap.set("n", "<A-S-h>", ":vertical resize -2<CR>", KEYMAP_OPTS)
vim.keymap.set("n", "<A-S-l>", ":vertical resize +2<CR>", KEYMAP_OPTS)

-- some lsp related keybinds
vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, KEYMAP_OPTS)
vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, KEYMAP_OPTS)
vim.keymap.set('n', '<C-w>d', vim.diagnostic.open_float, KEYMAP_OPTS)

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { buffer = event.buf })
    vim.keymap.set({ "n", "x" }, "<F3>", function()
      require("conform").format({ async = true })
    end, { buffer = event.buf })
    vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, { buffer = event.buf })

    -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = event.buf })
    vim.keymap.set({ "i", "s" }, "<C-s>", vim.lsp.buf.signature_help, { buffer = event.buf })

    vim.keymap.set("n", "grr", vim.lsp.buf.references, { buffer = event.buf })
    vim.keymap.set("n", "gri", vim.lsp.buf.implementation, { buffer = event.buf })
    vim.keymap.set("n", "gO", vim.lsp.buf.document_symbol, { buffer = event.buf })
  end,
})

local plugin_keymaps = {}

plugin_keymaps.toggle = {
  ["mini.files"] = function(cmd)
    return { "n", "<leader>m", cmd, KEYMAP_OPTS }
  end,
  ["undotree"] = function(cmd)
    return { "n", "<leader>u", cmd, KEYMAP_OPTS }
  end,
  ["git_diff"] = function(cmd)
    return { "n", "<leader>gd", cmd, KEYMAP_OPTS }
  end,
  ["dapui"] = function(cmd)
    return { "n", "<leader>d", cmd, KEYMAP_OPTS }
  end,
  ["dap_breakpoint"] = function(cmd)
    return { "n", "<leader>b", cmd, KEYMAP_OPTS }
  end,
}

plugin_keymaps["telescope"] = {
  { "n", "<leader>ff", "find_files", KEYMAP_OPTS },
  { "n", "<leader>fr", "oldfiles", KEYMAP_OPTS },
  { "n", "<leader>fg", "live_grep", KEYMAP_OPTS },
  { "n", "<leader>gf", "git_files", KEYMAP_OPTS },
}

plugin_keymaps["mini.files"] = {
  close = "<Esc>",
  go_in = "l",
  go_in_plus = "L",
  go_out = "h",
  go_out_plus = "H",
  reset = "<BS>",
  reveal_cwd = "@",
  show_help = "g?",
  synchronize = "=",
  trim_left = "<",
  trim_right = ">",
}

plugin_keymaps["nvim-surround"] = {
  insert = "<C-g>s",
  insert_line = "<C-g>S",
  normal = "ys",
  normal_cur = "yss",
  normal_line = "yS",
  normal_cur_line = "ySS",
  visual = "S",
  visual_line = "gS",
  delete = "ds",
  change = "cs",
  change_line = "cS",
}

plugin_keymaps["Comment"] = {
  toggler = {
    line = "gcc",
    block = "gbc",
  },
  opleader = {
    line = "gc",
    block = "gb",
  },
  extra = {
    above = "gcO",
    below = "gco",
    eol = "gcA",
  },
}
plugin_keymaps["blink.cmp"] = {
  ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
  ["<C-e>"] = { "hide", "fallback" },
  ["<CR>"] = { "accept", "fallback" },
  ["<Tab>"] = {
    function(cmp)
      if cmp.snippet_active() then
        return cmp.accept()
      else
        return cmp.select_next()
      end
    end,
    "snippet_forward",
    "fallback",
  },
  ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
  ['<Up>'] = { 'select_prev', 'fallback' },
  ['<Down>'] = { 'select_next', 'fallback' },

  -- use mouse instead of:
  -- ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
  -- ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
}

plugin_keymaps.treesitter = {}

plugin_keymaps.treesitter["incremental_selection"] = {
  init_selection = "<S-l>",
  node_incremental = "<S-l>",
  -- scope_incremental = "grc",
  node_decremental = "<S-h>",
}

plugin_keymaps.treesitter["navigation"] = {
  goto_definition = "gnd",
  list_definitions = "gnD",
  -- list_definitions_toc = "gO",
  goto_next_usage = "gnn",
  goto_previous_usage = "gnN",
}

plugin_keymaps.treesitter.textobjects = {}

plugin_keymaps.treesitter.textobjects["select"] = {
  keymaps = {
    -- You can use the capture groups defined in textobjects.scm
    ["af"] = { query = "@function.outer", desc = "around a function" },
    ["if"] = { query = "@function.inner", desc = "inner part of a function" },
    ["ac"] = { query = "@class.outer", desc = "around a class" },
    ["ic"] = { query = "@class.inner", desc = "inner part of a class" },
    ["ai"] = { query = "@conditional.outer", desc = "around an if statement" },
    ["ii"] = { query = "@conditional.inner", desc = "inner part of an if statement" },
    ["al"] = { query = "@loop.outer", desc = "around a loop" },
    ["il"] = { query = "@loop.inner", desc = "inner part of a loop" },
    ["ap"] = { query = "@parameter.outer", desc = "around parameter" },
    ["ip"] = { query = "@parameter.inner", desc = "inside a parameter" },
  },
  selection_modes = {
    ["@parameter.outer"] = "v", -- charwise
    ["@parameter.inner"] = "v", -- charwise
    ["@function.outer"] = "v", -- charwise
    ["@conditional.outer"] = "V", -- linewise
    ["@loop.outer"] = "V", -- linewise
    ["@class.outer"] = "<c-v>", -- blockwise
  },
}

plugin_keymaps.treesitter.textobjects["move"] = {
  goto_previous_start = {
    ["[f"] = { query = "@function.outer", desc = "Previous function" },
    ["[c"] = { query = "@class.outer", desc = "Previous class" },
    ["[p"] = { query = "@parameter.inner", desc = "Previous parameter" },
  },
  goto_next_start = {
    ["]f"] = { query = "@function.outer", desc = "Next function" },
    ["]c"] = { query = "@class.outer", desc = "Next class" },
    ["]p"] = { query = "@parameter.inner", desc = "Next parameter" },
  },
}

plugin_keymaps.treesitter.textobjects["swap"] = {
  swap_next = {
    ["<leader>a"] = "@parameter.inner",
  },
  swap_previous = {
    ["<leader>A"] = "@parameter.inner",
  },
}

-- autocommands --------------------------------------------------------------------------------------------------------

-- close terminal on `:wqall`.
-- based on: https://github.com/Olical/conjure/issues/644
vim.api.nvim_create_autocmd("ExitPre", {
  pattern = "*",
  callback = function(_)
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_get_option_value("buftype", { buf = buf }) == "terminal" then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end,
})

-- higlight selection on yank.
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Don't continue comments after newline
-- source: https://superuser.com/a/271024
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- save/remember view - which includes folds and cursor position.
-- source: https://stackoverflow.com/a/54739345
vim.cmd([[
augroup remember_view
    autocmd!
    autocmd BufWinLeave ?* mkview 1
    autocmd BufWinEnter ?* silent! loadview 1
augroup END
]])

-- neovim terminal autocmd - for BufTermOpen instead of TermOpen
-- source: https://stackoverflow.com/a/63909865
vim.cmd([[
augroup neovim_terminal
    autocmd!
    " Allows Ctrl-c on terminal window
    autocmd TermOpen * nnoremap <buffer> <C-c> i<C-c>
    " Disables number lines on terminal buffers
    autocmd TermEnter * :set nonumber norelativenumber
augroup END
]])

-- Setup plugins -------------------------------------------------------------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { out, "WarningMsg" } }, true, {})
    return -- stop processing config file any further
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(unpack(require("plugins")(plugin_keymaps)))

-- Setup LSP -----------------------------------------------------------------------------------------------------------

vim.lsp.config("*", {
  root_markers = { ".git" },
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      },
    },
  },
})

local lsp_dir = vim.fn.stdpath("config") .. "/lsp"
local lsp_servers = {}
if vim.fn.isdirectory(lsp_dir) == 1 then
  for _, file in ipairs(vim.fn.readdir(lsp_dir)) do
    if file:match("%.lua$") and file ~= "init.lua" then
      local server_name = file:gsub("%.lua$", "")
      table.insert(lsp_servers, server_name)
    end
  end
end
vim.lsp.enable(lsp_servers)

vim.diagnostic.config({
  signs = {
    active = true,
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚",
      [vim.diagnostic.severity.WARN] = "󰀪",
      [vim.diagnostic.severity.HINT] = "󰌶",
      [vim.diagnostic.severity.INFO] = "",
    },
  },
  virtual_lines = { current_line = true },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    header = "",
    border = "none",
    focusable = true,
    prefix = " ",
    close_events = { "CursorMoved", "InsertEnter", "FocusLost" },
    source = true,
    scope = "cursor",
  },
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})
