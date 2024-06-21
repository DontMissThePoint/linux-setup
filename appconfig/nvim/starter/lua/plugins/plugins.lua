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
		"stevearc/conform.nvim",
		--  for users those who want auto-save conform + lazyloading!
		-- event = "BufWritePre"
		config = function()
			require("configs.conform")
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
      require("neoscroll").setup({})
    end,
  },

	{
		"cappyzawa/trim.nvim",
		lazy = false,
		config = function()
			require("trim").setup({})
		end,
	},

 {
    "numToStr/Comment.nvim",
		lazy = false,
    config = function()
      require("Comment").setup()
    end
  },

	{
		"sindrets/diffview.nvim",
		lazy = false,
		config = function()
			require("diffview").setup({})
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
      require("fzf-lua").setup({"fzf-tmux",winopts={preview={default="bat"}}})
    end
  },

  {
    "folke/twilight.nvim",
		lazy = false,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
    },
		config = function()
			require("twilight").setup()
		end,
  },

  {
    "folke/zen-mode.nvim",
		lazy = false,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
    },
		config = function()
			require("zen-mode").setup()
		end,
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
		"alexghergh/nvim-tmux-navigation",
    lazy = false,
		config = function()
			require("nvim-tmux-navigation").setup({
				disable_when_zoomed = true, -- defaults to false
			})
		end,
	},

  {
    "wildfunctions/myeyeshurt",
    lazy = false,
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
