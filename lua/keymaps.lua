local M = {}

M.default_opts = { silent = true }

M.leaderkey = ","

M.core = {
  {
    "n",
    "<Esc>",
    function()
      -- close floating windows
      -- source: https://www.reddit.com/r/neovim/comments/1335pfc/comment/jiaagyi
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative == "win" then
          vim.api.nvim_win_close(win, false)
        end
      end
      if vim.bo.modifiable then
        -- clear search
        vim.cmd("nohlsearch")
      end
    end,
    M.default_opts,
  },

  -- alternate Esc
  { "i", "<C-c>", "<Esc>", M.default_opts },

  -- paste as usual
  { "x", "p", '"_dP', M.default_opts },

  -- move text
  { "v", "J", ":m '>+1<CR>gv=gv", M.default_opts },
  { "v", "K", ":m '<-2<CR>gv=gv", M.default_opts },

  -- fix cursor at position while doing these actions
  { "n", "J", "mzJ`z", M.default_opts },
  { "v", "<", "<gv^", M.default_opts }, -- stay in indent mode
  { "v", ">", ">gv^", M.default_opts },

  -- stay in the middle while doing these actions
  { "n", "<C-d>", "<C-d>zz", M.default_opts },
  { "n", "<C-u>", "<C-u>zz", M.default_opts },
  -- { "n", "n", "nzzzv", M.default_opts }, -- does not work for some reason. todo: fix this
  -- { "n", "N", "Nzzzv", M.default_opts },

  -- access global clipboard
  { { "n", "v" }, "<leader>y", '"+y', M.default_opts },
  { "n", "<leader>Y", '"+Y', M.default_opts },
  { { "n", "v" }, "<leader>d", '"_d', M.default_opts },
  { "n", "<leader>p", '"+p', M.default_opts },
  { "v", "<leader>p", 'c<Esc>"+p', M.default_opts },

  -- get out of / exit terminal
  { "t", "<Esc>", "<C-\\><C-n>", M.default_opts },
  { "t", "<A-S-q>", "<C-\\><C-n>:q!<CR>", M.default_opts },
  { "n", "<A-S-t>", ":split<CR>:terminal<CR>", M.default_opts },

  -- windows split / close
  { "n", "<A-v>", ":vsplit<CR>", M.default_opts },
  { "n", "<A-b>", ":split<CR>", M.default_opts },
  { "n", "<A-S-q>", ":q!<CR>", M.default_opts },

  -- window navigation
  { "n", "<A-k>", "<C-w>k", M.default_opts },
  { "n", "<A-j>", "<C-w>j", M.default_opts },
  { "n", "<A-h>", "<C-w>h", M.default_opts },
  { "n", "<A-l>", "<C-w>l", M.default_opts },

  -- window resize
  { "n", "<A-S-k>", ":resize +2<CR>", M.default_opts },
  { "n", "<A-S-j>", ":resize -2<CR>", M.default_opts },
  { "n", "<A-S-h>", ":vertical resize -2<CR>", M.default_opts },
  { "n", "<A-S-l>", ":vertical resize +2<CR>", M.default_opts },
}

M.bufsurf = {
  { "n", "<A-.>", ":BufSurfForward<CR>", M.default_opts },
  { "n", "<A-,>", ":BufSurfBack<CR>", M.default_opts },
}

M.bufterm = {
  { "n", "<A-t>", ":BufTermEnter<CR>", M.default_opts },
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
  { "n", "<leader>ff", "find_files", M.default_opts },
  { "n", "<leader>fr", "oldfiles", M.default_opts },
  { "n", "<leader>fg", "live_grep", M.default_opts },
  { "n", "<leader>fb", "buffers", M.default_opts },
  { "n", "<leader>fh", "help_tags", M.default_opts },
  { "n", "<leader>gf", "git_files", M.default_opts },
}

M.gitsigns = {
  { "n", "<leader>hp", "preview_hunk", M.default_opts },
}

M.lsp = {
  { "n", "gd", "definition", M.default_opts },
  { "n", "gD", "declaration", M.default_opts },
  { "n", "gi", "implementation", M.default_opts },
  { "n", "gt", "type_definition", M.default_opts },

  { "n", "gr", "references", M.default_opts },
  -- { "n", "<C-h>", "signature_help", M.default_opts }, -- never used this. todo: find out what this is.
  { "n", "<F2>", "rename", M.default_opts },
  { "n", "<F3>", "format", M.default_opts },
  { "n", "<F4>", "code_action", M.default_opts },
}

M.diagnostic = {
  { "n", "K", "open_float", M.default_opts },
  -- use <Esc> to get out of float.
  { "n", "[d", "goto_prev", M.default_opts },
  { "n", "]d", "goto_next", M.default_opts },
}

M.cmp = {
  -- `Enter` key to confirm completion
  { "<CR>", "confirm", { select = false }, M.default_opts },

  -- Ctrl+Space to trigger completion menu
  { "<C-Space>", "complete", nil, M.default_opts },

  -- Ctrl+e to abort completion. Useful while supertabbing.
  { "<C-e>", "abort", nil, M.default_opts },

  -- Scroll up and down in the completion documentation
  { "<PageUp>", "scroll_docs", -4, M.default_opts },
  { "<PageDown>", "scroll_docs", 4, M.default_opts },
}

M.lsp_zero_cmp_actions = {
  { "<Tab>", "luasnip_supertab", nil, M.default_opts },
  { "<S-Tab>", "luasnip_shift_supertab", nil, M.default_opts },
}

M.dap = {
  -- set breakpoint
  { "n", "<leader>b", "toggle_breakpoint", M.default_opts },
}

M.dapui = {
  -- launch debugger
  { "n", "<leader>d", "toggle", M.default_opts },
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
  { "n", "<leader>gd", ":Gvdiffsplit<CR>zR", M.default_opts },
}

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

M.special = {
  mini_files_toggle = function(rhs)
    return { "n", "<leader>m", rhs, M.default_opts }
  end,
  lsp_lines_toggle = function(rhs)
    return { "n", "<leader>l", rhs, M.default_opts }
  end,
  undotree_toggle = function(rhs)
    return { "n", "<leader>u", rhs, M.default_opts }
  end,
}

return M
