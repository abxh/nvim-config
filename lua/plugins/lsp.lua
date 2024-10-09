local keymaps = require("keymaps")
local lsp_servers = {
  -- try installing npm and cargo externally to install the following using mason:
  "lua_ls",
  "jsonls",  -- requires npm
  "yamlls",  -- requires npm
  "pyright", -- requires npm
  "clangd",
}
local lsp_servers_manual = {
  "hls",
}
local diagnostic_opts = {
  header = false,
  border = "none",
  focusable = true,
  prefix = " ",
  close_events = { "CursorMoved", "InsertEnter", "FocusLost" },
  source = "always",
  scope = "cursor",
}
local lsp_signature_opts = {
  bind = true,
  handler_opts = {
    header = false,
    border = "none",
    focusable = true,
    prefix = " ",
    close_events = { "CursorMoved", "InsertEnter", "FocusLost" },
    source = "always",
    scope = "cursor",
  },
  hint_enable = false,
  -- assuming these are reasonable defaults and putting them here..
  -- move_cursor_key = "K",
  keymaps = { { "j", "<C-o>j" }, { "k", "<C-o>k" }, { "h", "<C-o>h" }, { "l", "<C-o>l" } },
}

vim.diagnostic.config({ float = diagnostic_opts })
for _, v in pairs(keymaps.diagnostic) do
  vim.keymap.set(v[1], v[2], vim.diagnostic[v[3]], {})
end

require("neodev").setup({ library = { plugins = { "nvim-dap-ui" }, types = true } })
require("neoconf").setup()

local lsp_zero = require("lsp-zero")
lsp_zero.on_attach(function(_, bufnr)
  for _, v in pairs(keymaps.lsp) do
    vim.keymap.set(v[1], v[2], vim.lsp.buf[v[3]], { buffer = bufnr })
  end
  require("lsp_signature").on_attach(lsp_signature_opts, bufnr)
end)

require("mason-lspconfig").setup({
  ensured_installed = lsp_servers,
  handlers = {
    lsp_zero.default_setup,
  },
})

local lspconfig = require("lspconfig")
for _, server_name in pairs(vim.list_extend(lsp_servers, lsp_servers_manual)) do
  local specified, opts = pcall(require, "lspconfigs." .. server_name)
  if specified then
    lspconfig[server_name].setup(opts)
  else
    lspconfig[server_name].setup({})
  end
  lspconfig[server_name].capabilities = lsp_zero.get_capabilities()
end
lsp_zero.set_sign_icons({ error = "󰅚", warn = "󰀪", hint = "󰌶", info = "" })
