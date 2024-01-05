---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"

M.ui = {
  transparency = true,
  theme = "tokyonight",
  theme_toggle = { "tokyonight", "one_light" },

  -- Dashboard
  nvdash = {
    load_on_startup = true
  },

  hl_override ={
    NvDashAscii = {
      bg ="none",
      fg ="cyan"
    },
    NvDashButtons ={
      bg ="none",
      fg ="light_grey"
    }
  },
  -- hl_override = highlights.override,
  hl_add = highlights.add,
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require "custom.mappings"

return M
