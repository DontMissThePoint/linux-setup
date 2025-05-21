---@type NvPluginSpec[]

local plugins = {

  -- Override plugin definition options

  {
    "mason-org/mason.nvim"
  },

  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    config = function()
      require("mason-lspconfig").setup {
        automatic_installation = true,
        ensure_installed = {
          "rust_analyzer", "pyright", "ts_ls", "bashls", "lua_ls",
        },
      }
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "Myzel394/jsonfly.nvim",
    },
    keys = {
      {
        "<leader>fj",
        "<cmd>Telescope jsonfly<cr>",
        desc = "Open json(fly)",
        ft = { "json", "xml", "yaml" },
        mode = "n",
      },
    },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = {
          height = 0.9,
          prompt_position = "bottom",
          vertical = {
            mirror = true,
            preview_cutoff = 0,
          },
        },
      },
    },
  },

  {
    "nvchad/base46",
    lazy = true,
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  "nvchad/volt", -- optional, needed for theme switcher
  -- or just use Telescope themes

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "regex",
        "lua",
        "bash",
        "markdown",
        "markdown_inline",
        "html",
        "json",
        "yaml",
      },
      auto_install = true,
    },
  },

  -- Install a plugin
  {
    "nvchad/ui",
    config = function()
      require "nvchad"
    end,
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    -- -@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = false },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
  },

  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  {
    "ggandor/leap.nvim",
    config = function()
      require("leap").add_default_mappings()
    end,
    lazy = false,
  },

  {
    "ggandor/flit.nvim",
    config = function()
      require("flit").setup {}
    end,
    lazy = false,
  },

  {
    "sustech-data/wildfire.nvim",
    enabled = false,
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("wildfire").setup()
    end,
  },

  {
    "michaelb/sniprun",
    branch = "master",
    build = "sh install.sh",
    -- force compile locally requires Rust >= 1.65
    lazy = false,
    config = function()
      require("sniprun").setup {
        display = {
          "VirtualTextOk",
          "LongTempFloatingWindow",
          -- "NvimNotify",
        },
      }
    end,
  },

  {
    "lukas-reineke/virt-column.nvim",
    enabled = false,
    opts = {
      char = "│",
      highlight = "VertSplit",
    },
  },

  {
    "dstein64/nvim-scrollview",
    setup = function()
      require("scrollview").setup {
        excluded_filetypes = { "nerdtree" },
        current_only = true,
        base = "buffer",
        column = 80,
        signs_on_startup = { "all" },
        diagnostics_severities = { vim.diagnostic.severity.ERROR },
      }
    end,
    event = "VeryLazy",
  },

  {
    "RRethy/vim-illuminate",
    setup = function()
      require("illuminate").setup {}
    end,
    event = "VeryLazy",
  },

  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
  },

  {
    "lowitea/aw-watcher.nvim",
    event = "VimEnter",
    opts = { -- required, but can be empty table: {}
      -- add any options here
      -- for example:
      aw_server = {
        host = "127.0.0.1",
        port = 5600,
      },
    },
  },

  {
    "azabiong/vim-highlighter",
    event = "VeryLazy",
    init = function()
      -- settings
    end,
  },

  {
    "mhanberg/output-panel.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("output_panel").setup {
        max_buffer_size = 5000, -- default
      }
    end,
    cmd = { "OutputPanel" },
    keys = {
      {
        "<leader>o",
        vim.cmd.OutputPanel,
        mode = "n",
        desc = "Toggle the output panel",
      },
    },
  },

  {
    "stevearc/conform.nvim",
    --  for users those who want auto-save conform + lazyloading!
    -- event = "BufWritePre"
    config = function()
      require "configs.conform"
    end,
  },

  {
    "willothy/savior.nvim",
    dependencies = { "j-hui/fidget.nvim" },
    event = { "FileChangedShellPost", "TextChanged" },
    config = true,
  },

  {
    "lukas-reineke/lsp-format.nvim",
    event = { "InsertLeavePre", "CursorMoved" },
    config = function()
      require("lsp-format").setup {}
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
          require("lsp-format").on_attach(client, args.buf)
        end,
      })
    end,
  },

  {
    "uga-rosa/ccc.nvim",
    cmd = { "CccHighlighterToggle", "CccConvert", "CccPick" },
    opts = {
      [[vim.opt.termguicolors = true]],
    },
    config = function()
      require("ccc").setup {
        highlighter = {
          auto_enable = true,
          lsp = true,
        },
      }
    end,
  },

  {
    "gennaro-tedesco/nvim-jqx",
    event = { "BufReadPost" },
    ft = { "json", "yaml" },
  },

  {
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
    keys = { -- load the plugin only when using it's keybinding:
      { "<leader>uu", "<cmd>lua require('undotree').toggle()<cr>", desc = "undotree" },
    },
  },

  {
    "cameron-wags/rainbow_csv.nvim",
    config = true,
    ft = {
      "csv",
      "tsv",
      "csv_semicolon",
      "csv_whitespace",
      "csv_pipe",
      "rfc_csv",
      "rfc_semicolon",
    },
    cmd = {
      "RainbowDelim",
      "RainbowDelimSimple",
      "RainbowDelimQuoted",
      "RainbowMultiDelim",
    },
  },

  {
    enabled = true,
    "denstiny/styledoc.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = true,
    ft = "markdown",
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    opts = {},
  },

  {
    "Kicamon/markdown-table-mode.nvim",
    ft = "markdown",
    config = function()
      require("markdown-table-mode").setup {
        insert = true,              -- when typing "|"
        insert_leave = true,        -- when leaving insert
        pad_separator_line = false, -- add space in separator line
        alig_style = "default",     -- default, left, center, right
      }
    end,
  },

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {
        -- Configuration here
      }
    end,
  },

  {
    "nacro90/numb.nvim",
    event = "BufRead",
    config = function()
      require("numb").setup {
        show_numbers = true,         -- Enable 'number' for the window while peeking
        show_cursorline = true,      -- Enable 'cursorline' for the window while peeking
        hide_relativenumbers = true, -- Enable turning off 'relativenumber' for the window while peeking
        number_only = false,         -- Peek only when the command is only a number instead of when it starts with a number
        centered_peeking = true,     -- Peeked line will be centered relative to window
      }
    end,
  },

  {
    "nguyenvukhang/nvim-toggler",
    config = function()
      require("nvim-toggler").setup {
        inverses = {
          ["disable"] = "enable",
        },
      }
    end,
  },

  {
    "zeioth/garbage-day.nvim",
    dependencies = "neovim/nvim-lspconfig",
    event = "VeryLazy",
    opts = {
      aggressive_mode = false,
      excluded_lsp_clients = { "copilot" },
      grace_period = 60 * 30,
      wakeup_delay = 0,
    },
  },

  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup()
    end,
  },

  {
    "cappyzawa/trim.nvim",
    event = "VeryLazy",
    config = function()
      require("trim").setup()
    end,
  },

  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function()
      require("Comment").setup()
    end,
  },

  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = true,
  },

  {
    "ibhagwan/fzf-lua",
    event = "VeryLazy",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- run `:FzfLua setup_fzfvim_cmds` and use :Files, :Rg, etc.
      require("fzf-lua").setup { { "fzf-native", "fzf-tmux" }, winopts = { preview = { default = "bat" } } }
    end,
  },

  {
    "m4xshen/hardtime.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      require("hardtime").setup { enabled = true }
    end,
  },

  {
    "chrisgrieser/nvim-spider",
    lazy = true,
  },

  {
    "rmagatti/auto-session",
    lazy = false,
    opts = {
      suppressed_dirs = { "$GIT_PATH", "~/VirtualMachines/*", "/" },
      -- log_level = 'debug',
    },
    config = function()
      require("auto-session").setup {
        auto_restore_last_session = vim.loop.cwd() == vim.loop.os_homedir(),
      }
    end,
  },

  {
    "folke/trouble.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
    },
  },

  {
    "numToStr/Navigator.nvim",
    event = "VeryLazy",
    config = function()
      require("Navigator").setup {
        auto_save = "current",
        disable_on_zoom = false,
        mux = "auto",
      }
    end,
  },

  {
    "wildfunctions/myeyeshurt",
    event = "BufReadPre",
    opts = {
      initialFlakes = 1,
      flakeOdds = 20,
      maxFlakes = 750,
      nextFrameDelay = 175,
      useDefaultKeymaps = true,
      flake = { "*", "." },
      minutesUntilRest = 20,
    },
  },

  {
    "Wansmer/symbol-usage.nvim",
    enabled = false,
    event = "LspAttach",
    opts = {
      hl = { link = "NonText" },
      references = { enabled = true, include_declaration = false },
      definition = { enabled = true },
      implementation = { enabled = true },
    },
  },

  -- To make a plugin not be loaded

  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

  -- All NvChad plugins are lazy-loaded by default
  -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
  -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
  -- {
  --   "mg979/vim-visual-multi",
  --   lazy = false,
  -- }
}

return plugins
