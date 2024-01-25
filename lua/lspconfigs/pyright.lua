return {
  python = {
    analysis = {
      -- https://github.com/microsoft/pyright/issues/4878
      stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs",
      autoSearchPaths = true,
      diagnosticMode = 'workspace',
      useLibraryCodeForTypes = true,
    },
  },
}
