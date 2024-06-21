require "autocmds"
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

	-- override plugin configs
	{
		"williamboman/mason.nvim",
    config = function()
      require "configs.mason"
    end,
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
		"nvim-tree/nvim-tree.lua",
		lazy = false,
	},

	{
		"MunifTanjim/nui.nvim",
		lazy = false,
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
		"stevearc/conform.nvim",
		--  for users those who want auto-save conform + lazyloading!
		-- event = "BufWritePre"
		config = function()
			require("configs.conform")
		end,
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
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			-- add any options here
		},
		config = function()
			require("noice").setup({
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
					signature = {
						enabled = false,
					},
					hover = {
						enabled = false,
					},
				},
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = true, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = false, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = false, -- add a border to hover docs and signature help
				},
			})
		end,
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
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

  {
    "epwalsh/obsidian.nvim",
    version = "*",  -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    --   "BufReadPre path/to/my-vault/**.md",
    --   "BufNewFile path/to/my-vault/**.md",
    -- },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",

      -- see the full list of optional dependencies
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/vaults/personal",
        },
        {
          name = "work",
          path = "~/vaults/work",
          -- Optional, override certain settings.
          overrides = {
            notes_subdir = "notes",
          },
        },
      },

      daily_notes = {
        -- Optional, if you keep daily notes in a separate directory.
        folder = "notes/dailies",
        -- Optional, if you want to change the date format for the ID of daily notes.
        date_format = "%Y-%m-%d",
        -- Optional, if you want to change the date format of the default alias of daily notes.
        alias_format = "%B %-d, %Y",
        -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
        template = nil
      },

      templates = {
        subdir = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        -- A map for custom variables, the key should be the variable and the value a function
        substitutions = {},
      },

      -- see full list of options
    },
  }

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
