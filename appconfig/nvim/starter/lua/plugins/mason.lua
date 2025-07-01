return {
  "mason-org/mason.nvim",
  -- cmd = { "Mason" },
  event = "VeryLazy",
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "mfussenegger/nvim-lint",
    "rshkarin/mason-nvim-lint",
  },
  config = function()
    -- import mason
    local mason = require "mason"

    -- import mason-lspconfig
    local mason_lspconfig = require "mason-lspconfig"

    -- import tool-installer
    local mason_tool_installer = require "mason-tool-installer"

    -- import lint
    local lint = require "lint"
    local mason_nvim_lint = require "mason-nvim-lint"

    -- icons
    mason.setup {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "",
          package_pending = "",
          package_uninstalled = "",
        },
      },
    }

    mason_lspconfig.setup {
      -- list of servers for mason to install
      automatic_installation = true,
      ensure_installed = {
        "ts_ls",
        "html",
        "cssls",
        "tailwindcss",
        "svelte",
        "lua_ls",
        "yamlls",
        "graphql",
        "emmet_ls",
        "prismals",
        "htmx",
        "gopls",
        "rust_analyzer",
      },
    }

    mason_tool_installer.setup {
      ensure_installed = {
        -- you can turn off/on auto_update per tool
        -- { "bash-language-server", auto_update = true },

        "lua-language-server",
        "vim-language-server",
        "yaml-language-server",
        "prettier", -- prettier formatter
        "biome", -- js formatter
        "isort", -- python formatter
        "black", -- python formatter
        "prettierd",
        "ltex-ls-plus",
        "beautysh",
        "pylint",
        "eslint_d",
        "shellcheck",
        "editorconfig-checker",
        "impl",
        "json-to-struct",
        "misspell",
        "revive",
        "shellharden",
        "shfmt",
        "staticcheck",
        "vint",
      },
      auto_update = false,
    }

    -- linters
    mason_nvim_lint.setup {
      -- ensure_installed = { "beautysh", "shellharden" },
      ignore_install = { "custom-linter" }, -- avoid trying to install an unknown linter
    }

    lint.linters_by_ft = {
      -- lua = { "luacheck" }, -- requires luarocks
      -- sh = { "shellcheck" },
      markdown = { "vale" },
      -- python = { "pylint", "vint" },
      -- haskell = { "hlint" },
    }

    lint.linters.luacheck.args = {
      "--globals",
      "love",
      "vim",
      "--formatter",
      "plain",
      "--codes",
      "--ranges",
      "-",
    }

    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
