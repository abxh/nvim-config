return {
  {
    -- auto pairs: {{{
    {
      dependencies = { "hrsh7th/nvim-cmp" },
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      init = require("plugins.integrations").autopairs_cmp,
    },
    -- }}}

    -- colorscheme: {{{
    {
      "sainnhe/gruvbox-material",
      priority = 1000,
      init = function()
        vim.opt.termguicolors = true
        vim.cmd("colorscheme gruvbox-material")
        local hl_overrides = {
          NormalFloat = { bg = "#3a3735" },
          FloatBorder = { bg = "#3a3735" },
          MiniFilesTitle = { bg = "#3a3735", fg = "#ebdbb2" },
          MiniFilesTitleFocused = { bg = "#3a3735", fg = "#ebdbb2", bold = true },
        }
        for key, value in pairs(hl_overrides) do
          vim.api.nvim_set_hl(0, key, value)
        end
      end,
    },
    -- }}}

    -- comment lines: {{{
    {
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        { "JoosepAlviste/nvim-ts-context-commentstring", opts = { enable_autocmd = false } },
      },
      "numToStr/Comment.nvim",
      opts = require("keymaps").comment,
      config = function(_, opts)
        require("Comment").setup(vim.tbl_deep_extend("keep", opts, {
          pre_hook = require("plugins.integrations").comment_treesitter(),
        }))
      end,
      event = "VeryLazy",
    },
    -- }}}

    -- git support: {{{
    {
      "tpope/vim-fugitive",
      event = "VeryLazy",
      init = function()
        for _, value in pairs(require("keymaps").fugitive) do
          vim.keymap.set(unpack(vim.list_extend(value, { noremap = true })))
        end
      end,
    },
    {
      "lewis6991/gitsigns.nvim",
      opts = {
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
        on_attach = function(bufnr)
          local m = require("gitsigns")
          for _, v in pairs(require("keymaps").gitsigns) do
            vim.keymap.set(v[1], v[2], m[v[3]], { buffer = bufnr })
          end
          require("plugins.integrations").gitsigns_keymap(bufnr)
        end,
      },
    },
    -- }}}

    -- lsp, cmp and friends: {{{
    {
      "VonHeikemen/lsp-zero.nvim",
      branch = "v3.x",
      dependencies = {
        { "williamboman/mason.nvim", opts = {} },
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",

        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-cmdline",
        "petertriho/cmp-git",
        "paopaol/cmp-doxygen",

        "nvim-neotest/nvim-nio",
        "jay-babu/mason-nvim-dap.nvim",
        "mfussenegger/nvim-dap",
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",

        { "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
        "rafamadriz/friendly-snippets",
        "saadparwaiz1/cmp_luasnip",

        "onsails/lspkind.nvim",
        "ray-x/lsp_signature.nvim",

        "jay-babu/mason-null-ls.nvim",
        "nvimtools/none-ls.nvim",

        "folke/neoconf.nvim",
        "folke/neodev.nvim",

        "b0o/schemastore.nvim",
        { "microsoft/python-type-stubs", cond = false },
      },
      config = function()
        require("plugins.lsp")
        require("plugins.cmp")
        require("plugins.null-ls")
        require("plugins.dap")
      end,
    },
    -- }}}

    -- mini.files: {{{
    {
      "echasnovski/mini.files",
      opts = {
        mappings = require("keymaps").mini_files,
      },
      init = function()
        vim.keymap.set(unpack(require("keymaps").special.mini_files_toggle(require("mini.files").open)))
      end,
    },
    -- }}}

    -- surround text: {{{
    {
      "kylechui/nvim-surround",
      version = "*",
      event = "VeryLazy",
      opts = { keymaps = require("keymaps").comment },
    },
    -- }}}

    -- telescope: {{{
    {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.4",
      dependencies = { "nvim-lua/plenary.nvim" },
      opts = {
        defaults = {
          borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        },
      },
      init = function()
        local m = require("telescope.builtin")
        for _, v in pairs(require("keymaps").telescope_builtin) do
          vim.keymap.set(v[1], v[2], m[v[3]], {})
        end
      end,
      event = "VeryLazy",
    },
    -- }}}

    -- treesitter: {{{
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        require("plugins.treesitter")
      end,
      dependencies = {
        "nvim-treesitter/nvim-treesitter-refactor",
        "nvim-treesitter/nvim-treesitter-textobjects",
      },
    },
    -- }}}

    -- others: {{{
    "tpope/vim-sleuth",
    {
      "ton/vim-bufsurf",
      init = function()
        for _, value in pairs(require("keymaps").bufsurf) do
          vim.keymap.set(unpack(value))
        end
      end,
    },
    {
      "boltlessengineer/bufterm.nvim",
      init = function()
        for _, value in pairs(require("keymaps").bufterm) do
          vim.keymap.set(unpack(value))
        end
      end,
      config = true,
    },
    {
      "mbbill/undotree",
      init = function()
        vim.keymap.set(unpack(require("keymaps").special.undotree_toggle(vim.cmd.UndotreeToggle)))
      end,
    },
    -- }}}

    -- nonessential: {{{

    -- filetype syntax support: {{{
    "kovetskiy/sxhkd-vim",
    "Fymyte/rasi.vim",
    -- }}}

    -- show html colors and etc.: {{{
    {
      "norcalli/nvim-colorizer.lua",
      priority = 0,
      config = function()
        require("colorizer").setup()
      end,
    },
    -- }}}

    -- pretty bar: {{{
    {
      "nvim-lualine/lualine.nvim",
      opts = {
        options = {
          theme = "gruvbox-material",
          section_separators = "",
          component_separators = "|",
        },
        sections = {
          lualine_x = { "filetype" },
        },
      },
      init = function()
        vim.opt.showmode = false
      end,
    },
    -- }}}

    -- pretty icons: {{{
    {
      "nvim-tree/nvim-web-devicons",
      opts = {
        color_icons = false, -- use default icons color.
      },
      init = function()
        require("nvim-web-devicons").set_default_icon("", "#d4be98", 95)
      end,
    },
    -- }}}

    -- pretty folds: {{{
    {
      "anuvyklack/pretty-fold.nvim",
      opts = {
        sections = {
          left = {
            "content",
          },
          right = {
            " ",
            "number_of_folded_lines",
            " ",
            function(config)
              return config.fill_char:rep(3)
            end,
          },
        },
        fill_char = "-",
      },
    },
    -- }}}

    -- pretty indentation: {{{
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
    -- }}}

    -- pretty diagnostics: {{{
    {
      "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
      init = function()
        vim.diagnostic.config({ virtual_text = false, virtual_lines = false })

        if require("keymaps").lsp_lines_toggle ~= nil then
          vim.keymap.set(unpack(require("keymaps").special.lsp_lines_toggle(require("lsp_lines").toggle)))
        end
      end,
      opts = {},
      event = "VeryLazy",
    },
    -- }}}

    -- pretty notifications: {{{
    {
      "rcarriga/nvim-notify",
      init = function()
        vim.opt.termguicolors = true
        vim.notify = require("notify")
      end,
      config = function()
        require("notify").setup({ render = "wrapped-compact" })
      end,
    },
    -- }}}

    -- }}}
  },
  { install = { colorscheme = { "gruvbox-material" } } },
}

-- vim: fdm=marker
