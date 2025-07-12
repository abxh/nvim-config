-- local linters = {
--   "cpplint"
-- }
--
-- local formatters = {
--   "stylua",
--   "black",
--   "shfmt",
-- }

-- require("mason-null-ls").setup({
--   ensure_installed = {}, -- vim.list_extend(linters, formatters),
--   handlers = {},
-- })

local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.black,
    -- null_ls.builtins.formatting.shfmt,
    -- require("none-ls.diagnostics.cpplint"),
  },
})
