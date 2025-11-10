return {
  "neovim/nvim-lspconfig",
  lazy = true,
  event = { "BufWritePre", "BufNewFile" },
  dependencies = {
    {
      "SmiteshP/nvim-navbuddy",
      dependencies = {
        "SmiteshP/nvim-navic",
        "MunifTanjim/nui.nvim",
      },
      opts = { lsp = { auto_attach = true } },
    },
  },
  config = function()
    local on_attach = require("nvchad.configs.lspconfig").on_attach
    local capabilities = require("nvchad.configs.lspconfig").capabilities

    -- keymap helper
    local map = vim.keymap.set

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        opts.desc = "Show LSP references"
        map("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

        opts.desc = "Go to declaration"
        map("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Show LSP definitions"
        map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

        opts.desc = "Show LSP implementations"
        map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

        opts.desc = "Show LSP type definitions"
        map("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

        opts.desc = "See available code actions"
        map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Smart rename"
        map("n", "<leader>rn", vim.lsp.buf.rename, opts)

        opts.desc = "Show buffer diagnostics"
        map("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

        opts.desc = "Show line diagnostics"
        map("n", "<leader>d", vim.diagnostic.open_float, opts)

        opts.desc = "Show documentation for what is under cursor"
        map("n", "K", vim.lsp.buf.hover, opts)

        opts.desc = "Restart LSP"
        map("n", "<leader>rs", ":LspRestart<CR>", opts)
      end,
    })

    -- Use new API: define configs, then enable them
    local lsp = vim.lsp

    -- define server configurations

    -- clangd
    lsp.config("clangd", {
      capabilities = capabilities,
      on_attach = on_attach,
    })
    lsp.enable "clangd"

    -- matlab
    lsp.config("matlab_ls", {
      capabilities = capabilities,
      on_attach = on_attach,
    })
    lsp.enable "matlab_ls"

    -- yaml
    lsp.config("yamlls", {
      capabilities = capabilities,
      on_attach = on_attach,
    })
    lsp.enable "yamlls"

    -- htmx
    lsp.config("htmx", {
      capabilities = capabilities,
      on_attach = on_attach,
    })
    lsp.enable "htmx"

    -- bash
    lsp.config("bashls", {
      capabilities = capabilities,
      on_attach = on_attach,
    })
    lsp.enable "bashls"

    -- ltex-ls-plus (markdown etc.)
    lsp.config("ltex-ls-plus", {
      capabilities = capabilities,
      on_attach = on_attach,
    })
    lsp.enable "ltex-ls-plus"

    -- html
    lsp.config("html", {
      capabilities = capabilities,
      on_attach = on_attach,
    })
    lsp.enable "html"

    -- gopls
    lsp.config("gopls", {
      capabilities = capabilities,
      on_attach = on_attach,
      cmd = { "gopls" },
      filetypes = { "go", "gomod", "gowork", "gotmpl" },
      settings = {
        gopls = {
          completeUnimported = true,
          usePlaceholders = true,
          analyses = {
            unusedparams = true,
          },
        },
      },
    })
    lsp.enable "gopls"

    -- typescript server
    lsp.config("ts_ls", {
      capabilities = capabilities,
      on_attach = on_attach,
    })
    lsp.enable "ts_ls"

    -- css
    lsp.config("cssls", {
      capabilities = capabilities,
      on_attach = on_attach,
    })
    lsp.enable "cssls"

    -- tailwindcss
    lsp.config("tailwindcss", {
      capabilities = capabilities,
      on_attach = on_attach,
    })
    lsp.enable "tailwindcss"

    -- svelte
    lsp.config("svelte", {
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePost", {
          pattern = { "*.js", "*.ts" },
          callback = function(ctx)
            if client.name == "svelte" then
              client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
            end
          end,
        })
      end,
    })
    lsp.enable "svelte"

    -- prisma
    lsp.config("prismals", {
      capabilities = capabilities,
      on_attach = on_attach,
    })
    lsp.enable "prismals"

    -- graphql
    lsp.config("graphql", {
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
    })
    lsp.enable "graphql"

    -- emmet
    lsp.config("emmet_ls", {
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
    })
    lsp.enable "emmet_ls"

    -- python
    lsp.config("pyright", {
      capabilities = capabilities,
      on_attach = on_attach,
    })
    lsp.enable "pyright"

    -- lua
    lsp.config("lua_ls", {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          diagnostics = {
            enable = true,
            globals = { "vim" },
          },
          workspace = {
            library = {
              vim.fn.expand "$VIMRUNTIME/lua",
              vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
              vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
              vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
              "${3rd}/love2d/library",
            },
            maxPreload = 100000,
            preloadFileSize = 10000,
          },
        },
      },
    })
    lsp.enable "lua_ls"

    -- Diagnostics configuration
    vim.diagnostic.config {
      virtual_text = { prefix = "", suffix = "" },
      update_in_insert = true,
      underline = false,
      severity_sort = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    }

    -- Add border to LSP info windows if desired
    require("lspconfig.ui.windows").default_options.border = "single"
  end,
}
