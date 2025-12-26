return {
	"sontungexpt/witch-line",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("witch-line").setup {
			laststatus = 3,
			abstracts = {
				"battery", -- pre-register battery to use in win option
				-- require("your custom component"),
			},
			statusline = {
				global = {
					"mode",
					"file.modifier",
					"file.icon",
					"file.name",
					-- "battery",
					"git.branch",
					"git.diff.added",
					"git.diff.removed",
					"git.diff.modified",
					-- "os_uname",
					"%=",
					"diagnostic.error",
					"diagnostic.warn",
					"diagnostic.hint",
					"diagnostic.info",
					"lsp.clients",
					"file.size",
					"indent",
					-- "encoding",
					"cursor.pos",
					"cursor.progress",
					-- require("your custom component"),
				},

				win = function(winid)
					-- Only show battery in NvimTree window
					local buf = vim.api.nvim_win_get_buf(winid)
					local filetype = vim.bo[buf].filetype

					if filetype == "NvimTree" then
						return {
							"battery",
							"datetime",
							-- require("your custom component"),
						}
					end

					return nil
				end,

				cache = {
					enabled = true,
					notification = true,
					func_strip = false,
				},

				disabled = {
					filetypes = { "help", "TelescopePrompt", "lazy", "mason" },
					buftypes = { "nofile", "terminal" },
				},

				-- Toggle via :Witchline toggle_auto_theme
				auto_theme = true,
			},
		}
	end,
}
