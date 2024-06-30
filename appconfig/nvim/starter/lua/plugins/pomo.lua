return {
  "epwalsh/pomo.nvim",
  version = "*", -- Recommended, use latest release instead of latest commit
  lazy = true,
  cmd = { "TimerStart", "TimerRepeat" },
  dependencies = {},
  config = function()
    require("pomo").setup {
      update_interval = 1000,

      notifiers = {
        {
          name = "Default",
          opts = {
            sticky = false,
            title_icon = "󱎫",
            text_icon = "󰄉",
          },
        },
        -- The "System" notifier sends a system notification when the timer is finished.
        -- Available on MacOS natively and Linux via the `libnotify-bin` package.
        -- Tracking: https://github.com/epwalsh/pomo.nvim/issues/3
        { name = "System" },
      },
      -- Override the notifiers for specific timer names.
      timers = {
        -- For example, use only the "System" notifier when you create a timer called "Break",
        -- e.g. ':TimerStart 2m Break'.
        Break = {
          { name = "System" },
        },
      },
    }
  end,
}
