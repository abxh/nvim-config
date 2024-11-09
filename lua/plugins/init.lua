return {
  {
    -- auto pairs: {{{
    {
      dependencies = { "hrsh7th/nvim-cmp" },
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = function()
        require("nvim-autopairs").setup()
        require("plugins.integrations").autopairs_cmp()
      end,
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
      config = function()
        for _, value in pairs(require("keymaps").fugitive) do
          vim.keymap.set(unpack(vim.list_extend(value, { noremap = true })))
        end
      end,
      event = "VeryLazy",
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
      event = "VeryLazy",
    },
    -- }}}

    -- lsp, cmp and friends: {{{
    {
      "neovim/nvim-lspconfig",
      dependencies = {
	{ "VonHeikemen/lsp-zero.nvim", branch = "v3.x", }, -- this plugin is key to simplifying your lsp config

        -- mason-related things:
        { "williamboman/mason.nvim", opts = {} },
        "williamboman/mason-lspconfig.nvim",
        -- "jay-babu/mason-nvim-dap.nvim",
        -- "jay-babu/mason-null-ls.nvim",

        -- general setup:
        "folke/neoconf.nvim",
        "folke/neodev.nvim",
        "nvim-neotest/nvim-nio",

        -- autocompletion related things: {{{
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-cmdline",
        -- "petertriho/cmp-git",
        -- "paopaol/cmp-doxygen",

        "b0o/schemastore.nvim",
        { "microsoft/python-type-stubs", cond = false },

        { "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
        "rafamadriz/friendly-snippets",
        "saadparwaiz1/cmp_luasnip",
        -- }}}

        -- formatting:
        "nvimtools/none-ls.nvim",

        -- debugging:
        "mfussenegger/nvim-dap",
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",

        -- shiny things:
        "onsails/lspkind.nvim",
        "ray-x/lsp_signature.nvim",
      },
      config = function()
        require("plugins.lsp")
        require("plugins.cmp")
        require("plugins.null-ls")
        require("plugins.dap")
      end,
      event = "VeryLazy",
    },
    -- }}}

    -- mini.files: {{{
    {
      "echasnovski/mini.files",
      opts = {
        mappings = require("keymaps").mini_files,
      },
      config = function()
        if require("keymaps").special.mini_files_toggle ~= nil then
          vim.keymap.set(unpack(require("keymaps").special.mini_files_toggle(require("mini.files").open)))
        end
      end,
      event = "VeryLazy",
    },
    -- }}}

    -- surround text: {{{
    {
      "kylechui/nvim-surround",
      version = "*",
      opts = { keymaps = require("keymaps").comment },
      event = "VeryLazy",
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
      config = function()
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
        "nvim-treesitter/nvim-treesitter-textobjects",
        "nvim-treesitter/nvim-treesitter-refactor",
      },
    },
    -- }}}

    -- others: {{{
    "tpope/vim-sleuth",
    {
      "ton/vim-bufsurf",
      config = function()
        for _, value in pairs(require("keymaps").bufsurf) do
          vim.keymap.set(unpack(value))
        end
      end,
    },
    {
      "boltlessengineer/bufterm.nvim",
      config = function()
        require("bufterm").setup()
        for _, value in pairs(require("keymaps").bufterm) do
          vim.keymap.set(unpack(value))
        end
      end,
    },
    {
      "mbbill/undotree",
      config = function()
        if require("keymaps").special.undotree_toggle ~= nil then
          vim.keymap.set(unpack(require("keymaps").special.undotree_toggle(vim.cmd.UndotreeToggle)))
        end
      end,
      event = "VeryLazy",
    },
    -- }}}

    -- nonessential: {{{

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
      "bbjornstad/pretty-fold.nvim",
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
    {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      opts = {},
    },
    -- }}}

    -- pretty diagnostics: {{{
    {
      "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
      init = function()
        vim.diagnostic.config({ virtual_text = false, virtual_lines = { only_current_line = true } })
      end,
      config = function()
        local lsp_lines = require("lsp_lines")
        lsp_lines.setup()

        if require("keymaps").special.lsp_lines_toggle ~= nil then
          vim.keymap.set(unpack(require("keymaps").special.lsp_lines_toggle(lsp_lines.toggle)))
        end
      end,
    },
    -- }}}

    -- pretty notifications: {{{
    {
      "rcarriga/nvim-notify",
      init = function()
        vim.opt.termguicolors = true
      end,
      config = function()
        local notify_custom = require("notify")
        notify_custom.setup({ render = "wrapped-compact" })
        vim.notify = notify_custom
      end,
      event = "VeryLazy",
    },
    -- }}}

    -- minimal startup screen: {{{
    {
      "goolord/alpha-nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      init = function()
        if vim.fn.argc() == 0 then
          require("alpha").setup(require("alpha.themes.startify").config)
        end
      end,
      cmd = "Alpha",
    },
    -- }}}

    -- measure startup time: {{{
    { "dstein64/vim-startuptime", cmd = "StartupTime" },
    -- }}}

    -- }}}
  },
  { install = { colorscheme = { "gruvbox-material" } } },
}

-- vim: fdm=marker
