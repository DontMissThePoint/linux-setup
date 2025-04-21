return {
    "sontungexpt/sttusline",
    branch = "table_version",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    event = { "BufEnter" },
    config = function()
        require("sttusline").setup {
        laststatus = 3,
        statusline_color = "StatusLine", -- colors follow active buffer
        disabled = {
            filetypes = {
                "NvimTree",
                "lazy",
                "mason",
            },
            buftypes = {
                "terminal",
            },
        },
        components = {
            "mode",
            "os-uname",
            "filename",
            "battery",
            "git-branch",
            "git-diff",
            "%=",
            "diagnostics",
            "lsps-formatters",
            "filesize",
            -- "copilot",
            -- "copilot-loading",
            "indent",
            "encoding",
            "pos-cursor",
            "pos-cursor-progress",
        },
    }
  end,
}
