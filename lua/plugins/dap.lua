-- require("mason-nvim-dap").setup({
--   ensure_installed = { "cppdbg" },
-- })

vim.g.dap_virtual_text = true

vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "red", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "yellow", linehl = "", numhl = "" })

local dap = require("dap")

dap.adapters.cppdbg = {
  id = "cppdbg",
  type = "executable",
  command = vim.fn.stdpath("data") .. "/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
}

dap.configurations.c = {
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

dap.configurations.cpp = dap.configurations.c
dap.configurations.nasm = dap.configurations.c

require("dapui").setup()
require("nvim-dap-virtual-text").setup()

local keymaps = require("keymaps")
for _, v in pairs(keymaps.dap) do
  vim.keymap.set(v[1], v[2], dap[v[3]])
end

local dapui = require("dapui")
for _, v in pairs(keymaps.dapui) do
  vim.keymap.set(v[1], v[2], dapui[v[3]])
end

dapui.setup({
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
})
