local cmp_sources = {
  {
    { name = "nvim_lsp" },
    { name = "luasnip" },
  },
  {
    { name = "path" },
  },
  -- {
  -- { name = 'buffer' },
  -- }
}

local cmp = require("cmp")
local cmp_action = require("lsp-zero").cmp_action()
local cmp_keymaps = {}

for _, value in pairs(require("keymaps").lsp_zero_cmp_actions) do
  cmp_keymaps[value[1]] = cmp_action[value[2]](value[3])
end

for _, value in pairs(require("keymaps").cmp) do
  cmp_keymaps[value[1]] = cmp.mapping[value[2]](value[3])
end

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  sources = cmp.config.sources(unpack(cmp_sources)),
  mapping = cmp.mapping.preset.insert(cmp_keymaps),
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },

  -- borders:
  window = {
    completion = { border = "none" },
    documentation = { border = "single" },
  },

  -- lspkind:
  formatting = {
    fields = { "abbr", "kind", "menu" },
    format = require("lspkind").cmp_format({
      mode = "symbol", -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters
      ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
    }),
  },

  -- disable completion in comments:
  enabled = function()
    local context = require("cmp.config.context")
    -- keep command mode completion enabled when cursor is in a comment
    if vim.api.nvim_get_mode().mode == "c" then
      return true
    else
      return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
    end
  end,

  -- ghost text:
  -- experimental = { ghost_text = { hl_group = "NonText" } },
})

-- Use git and buffer source for `gitcommit`
cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({ { name = "cmp_git" } }, { { name = "buffer" } }),
})

-- Use buffer source for `/`
cmp.setup.cmdline("/", {
  sources = { { name = "buffer" } },
  mapping = cmp.mapping.preset.cmdline(),
})

-- Use cmdline & path source for ':'
cmp.setup.cmdline(":", {
  sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
  mapping = cmp.mapping.preset.cmdline(),
})

-- friendly-snippets - enable standardized comments snippets
require("luasnip").filetype_extend("typescript", { "tsdoc" })
require("luasnip").filetype_extend("javascript", { "jsdoc" })
require("luasnip").filetype_extend("lua", { "luadoc" })
require("luasnip").filetype_extend("python", { "pydoc" })
require("luasnip").filetype_extend("rust", { "rustdoc" })
require("luasnip").filetype_extend("cs", { "csharpdoc" })
require("luasnip").filetype_extend("java", { "javadoc" })
require("luasnip").filetype_extend("c", { "cdoc" })
require("luasnip").filetype_extend("cpp", { "cppdoc" })
require("luasnip").filetype_extend("php", { "phpdoc" })
require("luasnip").filetype_extend("kotlin", { "kdoc" })
require("luasnip").filetype_extend("ruby", { "rdoc" })
require("luasnip").filetype_extend("sh", { "shelldoc" })

-- neogen:
require("neogen").setup({
  enabled = true,
  input_after_comment = true,
  snippet_engine = "luasnip",
})
vim.api.nvim_set_keymap(unpack(require("keymaps").special.neogen_func(":lua require('neogen').generate({ type = 'func' })<CR>")))
