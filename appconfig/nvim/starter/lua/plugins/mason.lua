return {
  "mason-org/mason.nvim",
  cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")

    -- icons
    mason.setup({
      ui = {
        border = "rounded",
        icons = {
          package_installed = "",
          package_pending = "",
          package_uninstalled = "",
        },
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      automatic_installation = true,
      ensure_installed = {
        "ts_ls",
        "html",
        "cssls",
        "tailwindcss",
        "bashls",
        "svelte",
        "lua_ls",
        "graphql",
        "emmet_ls",
        "prismals",
        "pyright",
        "htmx",
        "gopls",
        "rust_analyzer",
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        -- you can turn off/on auto_update per tool
        { 'bash-language-server', auto_update = true },

        "lua-language-server",
        "vim-language-server",
        "prettier", -- prettier formatter
        "biome",    -- js formatter
        "isort",    -- python formatter
        "black",    -- python formatter
        "stylua",
        "pylint",
        "eslint_d",
        "luacheck",
        "shellcheck",
        "editorconfig-checker",
        "impl",
        "json-to-struct",
        "luacheck",
        "misspell",
        "revive",
        "shellcheck",
        "shfmt",
        "staticcheck",
        "vint",
      },
      auto_update = false,
    })
  end,
}
