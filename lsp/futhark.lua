return {
  cmd = { "futhark", "lsp" },
  filetypes = { "futhark" },
  root_markers = { ".git" },
  single_file_support = true,
  on_init = function(client)
    client.server_capabilities.semanticTokensProvider = nil
  end,
  on_attach = function(client, _)
    client.server_capabilities.semanticTokensProvider = nil
  end,
}
