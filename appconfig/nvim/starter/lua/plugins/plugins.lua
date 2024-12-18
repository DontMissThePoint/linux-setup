---@type NvPluginSpec[]

local plugins = {

	-- Override plugin definition options
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("nvchad.configs.lspconfig")
			require("configs.lspconfig")
		end, -- Override to setup mason-lspconfig
	},

  {
    "nvim-telescope/telescope.nvim",
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
		"nvim-treesitter/nvim-treesitter",
		opts = {
      ensure_installed = {"vim", "html", "bash"},
			auto_install = true,
		},
	},

	{
		"williamboman/mason.nvim",
	},

	-- Install a plugin

	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup()
		end,
	},

  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
  },

	{
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPre", "BufNewFile" },
	},

	{
		"stevearc/conform.nvim",
		--  for users those who want auto-save conform + lazyloading!
		-- event = "BufWritePre"
		config = function()
			require("configs.conform")
		end,
	},

  {
    "uga-rosa/ccc.nvim",
    cmd = { "CccHighlighterToggle", "CccConvert", "CccPick" },
    opts = {
      [[vim.opt.termguicolors = true]],
    },
		config = function()
			require("ccc").setup({
        highlighter = {
          auto_enable = true,
          lsp = true,
        },
      })
		end,
  },

  {
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
    keys = { -- load the plugin only when using it's keybinding:
      { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", desc = "undotree" },
    },
  },

  {
    'cameron-wags/rainbow_csv.nvim',
    config = true,
    ft = {
        'csv',
        'tsv',
        'csv_semicolon',
        'csv_whitespace',
        'csv_pipe',
        'rfc_csv',
        'rfc_semicolon'
    },
    cmd = {
        'RainbowDelim',
        'RainbowDelimSimple',
        'RainbowDelimQuoted',
        'RainbowMultiDelim'
    },
  },

	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here
			})
		end,
	},

  {
    "nacro90/numb.nvim",
    event = "BufRead",
    config = function()
      require("numb").setup {
        show_numbers = true, -- Enable 'number' for the window while peeking
        show_cursorline = true, -- Enable 'cursorline' for the window while peeking
        hide_relativenumbers = true, -- Enable turning off 'relativenumber' for the window while peeking
        number_only = false, -- Peek only when the command is only a number instead of when it starts with a number
        centered_peeking = true, -- Peeked line will be centered relative to window
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
    config = function ()
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
    end
  },

	{
		"sindrets/diffview.nvim",
		event = "VeryLazy",
		config = function()
			require("diffview").setup()
		end,
	},

  {
    "ibhagwan/fzf-lua",
		event = "VeryLazy",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- calling `setup` is optional for customization
      -- run `:FzfLua setup_fzfvim_cmds` and use :Files, :Rg, etc.
      require("fzf-lua").setup({{"fzf-native","fzf-tmux"},winopts={preview={default="bat"}}})
    end
  },

  {
    "m4xshen/hardtime.nvim",
		event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      require('hardtime').setup({ enabled = true })
    end,
  },

  {
    "chrisgrieser/nvim-spider",
    lazy = true,
  },

  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {
      -- add any custom options here
    }
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" },
        function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" },
        function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o",
        function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" },
        function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },
        function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

	{
		"rcarriga/nvim-notify",
		lazy = false,
		config = function()
			require("notify").setup({
				stages = "fade_in_slide_out",
				background_colour = "FloatShadow",
				timeout = 3000,
			})
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
       require("Navigator").setup({
       auto_save = 'current',
       disable_on_zoom = false,
       mux = 'auto',
     })
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
      flake = {'*', '.'},
      minutesUntilRest = 20
    }
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
