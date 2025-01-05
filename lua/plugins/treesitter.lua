require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "c",
    "lua",
    "vim",
    "vimdoc",
    "query",
    "json",
    "jsonc",
    "yaml",
    "bash",
    "python",
    "markdown",
    "nasm",
    "cpp",
    "zig",
    "glsl",
  },
  highlight = {
    enable = true,
    disable = { "lua" },
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = require("keymaps").treesitter_incremental_selection,
  },
  refactor = {
    highlight_definitions = {
      enable = true,
      -- Set to false if you have an `updatetime` of ~100.
      clear_on_cursor_move = true,
    },
    navigation = {
      enable = true,
      keymaps = require("keymaps").treesitter_navigation,
    },
  },
  -- todo: custom treesitter objects.
})

-- treesitter fold as default
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
