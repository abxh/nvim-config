return function(keymaps)
  return {
    {
      -- comment motions: {{{
      {
        "numToStr/Comment.nvim",
        dependencies = {
          "nvim-treesitter/nvim-treesitter",
          { "JoosepAlviste/nvim-ts-context-commentstring", opts = { enable_autocmd = false } },
        },
        event = "VeryLazy",
        opts = keymaps["Comment"],
        config = function(_, opts)
          require("Comment").setup(vim.tbl_deep_extend("error", opts, {
            pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
          }))
        end,
      },
      -- }}}
      -- colorscheme: {{{
      {
        "sainnhe/gruvbox-material",
        priority = 1000,
        init = function()
          vim.opt.termguicolors = true
        end,
        config = function()
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
      -- mini file explorer: {{{
      {
        "echasnovski/mini.files",
        event = "VeryLazy",
        opts = {
          mappings = keymaps["mini.files"],
          options = { permanent_delete = false },
        },
        config = function(_, opts)
          local m = require("mini.files")
          m.setup(opts)
          vim.keymap.set(unpack(keymaps.toggle["mini.files"](function(...)
            if not m.close() then
              m.open(...)
            end
          end)))
        end,
      },
      -- }}}
      -- fuzzy finder: {{{
      {
        "nvim-telescope/telescope.nvim",
        event = "VeryLazy",
        tag = "0.1.4",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
          defaults = {
            borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
          },
        },
        config = function()
          local m = require("telescope.builtin")
          for _, v in pairs(keymaps.telescope) do
            vim.keymap.set(v[1], v[2], m[v[3]], v[4])
          end
        end,
      },
      -- }}}
      -- git support: {{{
      {
        "tpope/vim-fugitive",
        event = "VeryLazy",
        config = function()
          vim.keymap.set(unpack(keymaps.toggle["git_diff"](":Gvdiffsplit<CR>zR")))
        end,
      },
      {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        opts = {
          signs = {
            add = { text = "+" },
            change = { text = "~" },
            delete = { text = "_" },
            topdelete = { text = "‾" },
            changedelete = { text = "~" },
          },
          on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            -- don't override the built-in and fugitive keymaps
            vim.keymap.set({ "n", "v" }, "]c", function()
              if vim.wo.diff then
                return "]c"
              end
              vim.schedule(function()
                gs.next_hunk()
              end)
              return "<Ignore>"
            end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
            vim.keymap.set({ "n", "v" }, "[c", function()
              if vim.wo.diff then
                return "[c"
              end
              vim.schedule(function()
                gs.prev_hunk()
              end)
              return "<Ignore>"
            end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })

            -- todo?:
            -- vim.keymap.set("n", "<leader>hp", gs["preview_hunk"], { buffer = bufnr })
          end,
        },
      },
      -- }}}
      -- pretty bar: {{{
      {
        "nvim-lualine/lualine.nvim",
        dependencies = {
          "sainnhe/gruvbox-material",
        },
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
      -- surround mark motions: {{{
      {
        "kylechui/nvim-surround",
        version = "^3.0.0",
        event = "VeryLazy",
        opts = {
          keymaps = keymaps["nvim-surround"],
        },
      },
      -- }}}
      -- undo tree: {{{
      {
        "mbbill/undotree",
        event = "VeryLazy",
        config = function()
          vim.keymap.set(unpack(keymaps.toggle["undotree"](vim.cmd.UndotreeToggle)))
        end,
      },
      -- }}}

      -- treesitter: {{{
      {
        "nvim-treesitter/nvim-treesitter",
        version = false,
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
          "nvim-treesitter/nvim-treesitter-refactor",
          "nvim-treesitter/nvim-treesitter-textobjects",
        },
        opts = {
          ensure_installed = {
            "c",
            "lua",
            "query",
            "vim",
            "vimdoc",
            "json",
            "jsonc",
            "yaml",
            "markdown",
          },
          highlight = {
            enable = true,
            disable = function(lang, bufnr)
              local disabled_for = {
                -- "lua"
              }
              return disabled_for[lang] ~= nil or vim.api.nvim_buf_line_count(bufnr) > 2000
            end,
            additional_vim_regex_highlighting = { "latex" },
          },
          indent = {
            enable = true,
          },
          incremental_selection = {
            enable = true,
            keymaps = keymaps.treesitter.incremental_selection,
          },
          refactor = {
            highlight_definitions = {
              enable = true,
              clear_on_cursor_move = true, -- Set to false if you have an `updatetime` of ~100.
            },
            navigation = {
              enable = true,
              keymaps = keymaps.treesitter.navigation,
            },
          },
          textobjects = {
            select = vim.tbl_deep_extend("error", {
              enable = true,
              lookahead = true,
              include_surrounding_whitespace = false,
            }, keymaps.treesitter.textobjects.select),
            move = vim.tbl_deep_extend("error", {
              enable = true,
              set_jumps = true, -- whether to set jumps in the jumplist
            }, keymaps.treesitter.textobjects.move),
            swap = vim.tbl_deep_extend("error", {
              enable = true,
            }, keymaps.treesitter.textobjects.swap),
          },
        },
        config = function(_, opts)
          require("nvim-treesitter.configs").setup(opts)

          -- treesitter fold as default
          vim.opt.foldmethod = "expr"
          vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
        end,
      },
      -- }}}
      -- lsp related things {{{
      {
        "mason-org/mason-lspconfig.nvim",
        opts = {
          ensure_installed = { "lua_ls" },
        },
        dependencies = {
          { "mason-org/mason.nvim", opts = {} },
          "neovim/nvim-lspconfig",

          -- json schemas:
          -- "b0o/schemastore.nvim",
          -- python schemas:
          -- { "microsoft/python-type-stubs", cond = false },
        },
      },
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      {
        "stevearc/conform.nvim",
        opts = {
          formatters_by_ft = {
            c = { "clang_format" },
            cpp = { "clang_format" },
            lua = { "stylua" },
            python = { "isort", "black" },
            javascript = { "prettierd", "prettier", stop_after_first = true },
          },
          formatters = {
            clang_format = {
              prepend_args = { "--style=file", "--fallback-style=LLVM" },
            },
          },
        },
        config = function(_, opts)
          require("conform").setup(opts)
          vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
      },
      {
        "mfussenegger/nvim-lint",
        opts = {
          linters_by_ft = {},
        },
        config = function(_, opts)
          require("lint").linters_by_ft = opts.linters_by_ft
        end,
      },
      {
        "saghen/blink.cmp",
        dependencies = {
          { "L3MON4D3/LuaSnip", version = "v2.*" },
          "rafamadriz/friendly-snippets",
          "onsails/lspkind.nvim",
          "danymat/neogen",
        },
        version = "1.*",
        opts = {
          keymap = vim.tbl_deep_extend("error", {
            preset = "none",
          }, keymaps["blink.cmp"]),
          completion = {
            documentation = {
              window = { border = "none" },
              auto_show = true,
              auto_show_delay_ms = 500,
              treesitter_highlighting = true,
            },
            accept = { auto_brackets = { enabled = true } },
            list = { selection = { preselect = false, auto_insert = true } },
            menu = {
              border = "none",
              draw = {
                columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },

                -- use kind icons:
                -- source: https://cmp.saghen.dev/recipes.html#nvim-web-devicons-lspkind
                components = {
                  kind_icon = {
                    text = function(ctx)
                      local icon = ctx.kind_icon
                      if vim.tbl_contains({ "Path" }, ctx.source_name) then
                        local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                        if dev_icon then
                          icon = dev_icon
                        end
                      else
                        icon = require("lspkind").symbolic(ctx.kind, { mode = "symbol" })
                      end
                      return icon .. ctx.icon_gap
                    end,
                    highlight = function(ctx)
                      local hl = ctx.kind_hl
                      if vim.tbl_contains({ "Path" }, ctx.source_name) then
                        local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                        if dev_icon then
                          hl = dev_hl
                        end
                      end
                      return hl
                    end,
                  },
                },
              },
            },
          },
          signature = { enabled = true, window = { border = "none" } },
          sources = {
            default = { "lsp", "path", "snippets", "buffer" },
            per_filetype = {
              lua = { inherit_defaults = true, "lazydev" },
            },
            providers = {
              lazydev = {
                name = "LazyDev",
                module = "lazydev.integrations.blink",
                -- make lazydev completions top priority (see `:h blink.cmp`)
                score_offset = 100,
              },
            },
          },
          snippets = { preset = "luasnip" },
        },
        config = function(_, opts)
          require("blink.cmp").setup(opts)

          require("luasnip").filetype_extend("typescript", { "javascript" })
          require("luasnip.loaders.from_vscode").lazy_load()

          require("neogen").setup({
            enabled = true,
            input_after_comment = true,
            snippet_engine = "luasnip",
          })
        end,
      },
      {
        "rcarriga/nvim-dap-ui",
        dependencies = {
          "mfussenegger/nvim-dap",
          "nvim-neotest/nvim-nio",
          "theHamsta/nvim-dap-virtual-text",
        },
        opts = {
          icons = { expanded = "▾", collapsed = "▸" },
          expand_lines = vim.fn.has("nvim-0.7"),
          layouts = {
            {
              elements = {
                "scopes",
                "stacks",
                "console",
              },
              size = 0.3,
              position = "left",
            },
            {
              elements = {
                "repl",
                "breakpoints",
              },
              size = 0.3,
              position = "bottom",
            },
          },
          floating = {
            max_height = nil,
            max_width = nil,
            border = "single",
          },
          windows = { indent = 1 },
          render = {
            max_type_length = nil,
          },
        },
        config = function(_, opts)
          vim.g.dap_virtual_text = true

          vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "red", linehl = "", numhl = "" })
          vim.fn.sign_define("DapStopped", { text = "▶", texthl = "yellow", linehl = "", numhl = "" })

          local dap = require("dap")
          dap.adapters.cppdbg = {
            id = "cppdbg",
            type = "executable",
            command = vim.fn.stdpath("data") .. "/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
          }

          local cpptools_config = require("dap.cpptools")
          dap.configurations.c = cpptools_config
          dap.configurations.cpp = cpptools_config
          dap.configurations.nasm = cpptools_config
          dap.configurations.rust = cpptools_config

          require("nvim-dap-virtual-text").setup({ highlight_changed_variables = false, all_frames = false })

          local dapui = require("dapui")
          dapui.setup(opts)

          vim.keymap.set(unpack(keymaps.toggle["dap_breakpoint"](dap["toggle_breakpoint"])))
          vim.keymap.set(unpack(keymaps.toggle["dapui"](dapui["toggle"])))
        end,
      },
      -- }}}
      -- misc: {{{
      "tpope/vim-sleuth",
      {
        "pteroctopus/faster.nvim",
        opts = {
          behaviours = {
            bigfile = {
              features_disabled = { "lsp", "treesitter", "indent_blankline" },
              extra_patterns = {
                { filesize = 0.1, pattern = "*.h" },
              },
            },
          },
        },
      },
      -- }}}
      -- extra: {{{
      {
        "nvim-tree/nvim-web-devicons",
        opts = {
          color_icons = false, -- use default icons color.
        },
        init = function()
          require("nvim-web-devicons").set_default_icon("", "#d4be98", 95)
        end,
      },
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
      {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
      },
      {
        "goolord/alpha-nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = "Alpha",
        init = function()
          if vim.fn.argc() == 0 then
            require("alpha").setup(require("alpha.themes.startify").config)
          end
        end,
      },
      {
        "dstein64/vim-startuptime",
        cmd = "StartupTime",
        init = function()
          vim.g.startuptime_tries = 10
        end,
      },
      -- }}}
    },
    { install = { colorscheme = { "gruvbox-material" } } },
    { checker = { enabled = true } },
  }
end
-- vim: fdm=marker
