return {
  "rcarriga/nvim-notify",
  lazy = false,
  keys = {
    {
      "<leader>un",
      function()
        require("notify").dismiss({ silent = true, pending = true })
      end,
      desc = "Dismiss All Notifications",
    },
  },
  opts = {
    level = 2,
    minimum_width = 50,
    stages = "fade_in_slide_out", -- "fade"
    timeout = 3000,
    top_down = true,
    render = "default",
    background_colour = "#181825", -- transparent background
  },
}
