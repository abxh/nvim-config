local M = {}

M.leaderkey = ","

M.core = {
  -- clear search
  { "n", "<Esc>", ":noh<CR>" },

  -- paste as usual
  { "x", "p", '"_dP' },

  -- alternate Esc
  { "i", "<C-c>", "<Esc>" },

  -- move text
  { "v", "J", ":m '>+1<CR>gv=gv" },
  { "v", "K", ":m '<-2<CR>gv=gv" },

  -- fix cursor at position while doing these actions
  { "n", "J", "mzJ`z" },
  { "v", "<", "<gv^" }, -- stay in indent mode
  { "v", ">", ">gv^" },

  -- stay in the middle while doing these actions
  { "n", "<C-d>", "<C-d>zz" },
  { "n", "<C-u>", "<C-u>zz" },
  -- { "n", "n", "nzzzv" }, -- does not work for some reason. todo: fix this
  -- { "n", "N", "Nzzzv" },

  -- access global clipboard
  { { "n", "v" }, "<leader>y", '"+y' },
  { "n", "<leader>Y", '"+Y' },
  { { "n", "v" }, "<leader>d", '"_d' },
  { "n", "<leader>p", '"+p' },
  { "v", "<leader>p", 'c<Esc>"+p' },

  -- windows split / close
  { "n", "<A-v>", ":vsplit<CR>" },
  { "n", "<A-b>", ":split<CR>" },
  { "n", "<A-S-q>", ":q!<CR>" },
  { "t", "<A-S-q>", "<C-\\><C-n>:q!<CR>" },

  -- window navigation
  { "n", "<A-k>", "<C-w>k" },
  { "n", "<A-j>", "<C-w>j" },
  { "n", "<A-h>", "<C-w>h" },
  { "n", "<A-l>", "<C-w>l" },

  -- window resize
  { "n", "<A-S-k>", ":resize +2<CR>" },
  { "n", "<A-S-j>", ":resize -2<CR>" },
  { "n", "<A-S-h>", ":vertical resize -2<CR>" },
  { "n", "<A-S-l>", ":vertical resize +2<CR>" },
}

M.bufsurf = {
  { "n", "<A-.>", ":BufSurfForward<CR>" },
  { "n", "<A-,>", ":BufSurfBack<CR>" },
}

M.bufterm = {
  { "n", "<A-t>", ":BufTermEnter<CR>" },
}

M.treesitter_incremental_selection = {
  init_selection = "<S-l>",
  node_incremental = "<S-l>",
  -- scope_incremental = "grc",
  node_decremental = "<S-h>",
}

M.treesitter_navigation = {
  -- goto_definition = "gnd",
  -- list_definitions = "gnD",
  -- list_definitions_toc = "gO",
  goto_next_usage = "gnn",
  goto_previous_usage = "gnN",
}

M.telescope_builtin = {
  { "n", "<leader>ff", "find_files" },
  { "n", "<leader>fg", "live_grep" },
  { "n", "<leader>fb", "buffers" },
  { "n", "<leader>fh", "help_tags" },
  { "n", "<leader>gf", "git_files" },
}

M.gitsigns = {
  { "n", "<leader>hp", "preview_hunk" },
}

M.lsp_lines_toggle = "<leader>l"

M.lsp = {
  { "n", "gd", "definition" },
  { "n", "gD", "declaration" },
  { "n", "gi", "implementation" },
  { "n", "gt", "type_definition" },

  { "n", "gr", "references" },
  -- { "n", "<C-h>", "signature_help" }, -- never used this. todo: find out what this is.
  { "n", "<F2>", "rename" },
  { "n", "<F3>", "format" },
  -- { "n", "<F4>", "code_action" }, -- never used this. todo: find out what this is.
}

M.diagnostic = {
  { "n", "K", "open_float" },
  -- use q to get out of float.
  { "n", "[d", "goto_prev" },
  { "n", "]d", "goto_next" },
}

M.cmp = {
  -- `Enter` key to confirm completion
  { "<CR>", "confirm", { select = false } },

  -- Ctrl+Space to trigger completion menu
  { "<C-Space>", "complete", nil },

  -- Ctrl+e to abort completion. Useful while supertabbing.
  { "<C-e>", "abort", nil },

  -- Scroll up and down in the completion documentation
  { "<PageUp>", "scroll_docs", -4 },
  { "<PageDown>", "scroll_docs", 4 },
}

M.lsp_zero_cmp_actions = {
  { "<Tab>", "luasnip_supertab", nil },
  { "<S-Tab>", "luasnip_shift_supertab", nil },
}

M.dap = {
  -- set breakpoint
  { "n", "<leader>b", "toggle_breakpoint" },
}

M.dapui = {
  -- launch debugger
  { "n", "<leader>d", "toggle" },
}

M.comment = {
  ---LHS of toggle mappings in NORMAL mode
  toggler = {
    ---Line-comment toggle keymap
    line = "gcc",
    ---Block-comment toggle keymap
    block = "gbc",
  },
  ---LHS of operator-pending mappings in NORMAL and VISUAL mode
  opleader = {
    ---Line-comment keymap
    line = "gc",
    ---Block-comment keymap
    block = "gb",
  },
  ---LHS of extra mappings
  extra = {
    ---Add comment on the line above
    above = "gcO",
    ---Add comment on the line below
    below = "gco",
    ---Add comment at the end of line
    eol = "gcA",
  },
}

M.surround = {
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

M.fugitive = {
  { "n", "<leader>gd", ":Gvdiffsplit<CR>zR" },
}

M.mini_files_toggle = "<leader>m"

M.mini_files = {
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

M.undotree_toggle = "<leader>u"

return M
