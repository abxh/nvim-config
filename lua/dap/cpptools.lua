-- taken from:
-- https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(gdb-via--vscode-cpptools)

return {
  {
    name = "Launch ./a.out",
    type = "cppdbg",
    request = "launch",
    program = "${workspaceFolder}/a.out",
    cwd = "${workspaceFolder}",
    stopAtEntry = true,
    miDebuggerArgs = "--quiet",

    -- these options might vary:
    targetArchitecture = "x64", -- https://github.com/microsoft/vscode-cpptools/issues/2376
    setupCommands = {
      {
        text = "-enable-pretty-printing",
        description = "enable pretty printing",
        ignoreFailures = false,
      },
    },
  },
  {
    name = "Specify executable file",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopAtEntry = true,
    miDebuggerArgs = "--quiet",

    -- these options might vary:
    targetArchitecture = "x64",
    setupCommands = {
      {
        text = "-enable-pretty-printing",
        description = "enable pretty printing",
        ignoreFailures = false,
      },
    },
  },
}
