from time import localtime, strftime

import catppuccin

# Reassign to avoid lsp(ruff_lsp) errors
config = config  # noqa: F821
c = c  # noqa: F821

# load your autoconfig, use this if the rest of your config is empty!
config.load_autoconfig()

# User agent
config.set(
    "content.headers.user_agent",
    "Mozilla/5.0 ({os_info}; rv:130.0) Gecko/20100101 Firefox/130",
    "*",
)
c.backend = "webengine"

### When to show a changelog after qutebrowser was upgraded.
## Type: String "major", "minor", "patch"
c.changelog_after_upgrade = "minor"

# Variables
leader = ","
ss_dir = "~/Pictures/Screenshots/"
timestamp = strftime("%Y-%m-%d-%H-%M-%S", localtime())
terminal = "/usr/bin/urxvtc"
editor = "/usr/bin/nvim"
homepage = "https://www.startpage.com"

# theme
# set the flavour you'd like to use
# valid options are 'mocha', 'macchiato', 'frappe', and 'latte'
catppuccin.setup(c, "frappe")

# Dark mode
c.colors.webpage.darkmode.enabled = False
c.colors.webpage.preferred_color_scheme = "auto"
c.colors.webpage.darkmode.policy.page = "smart"
c.colors.webpage.darkmode.policy.images = "smart"
c.colors.webpage.darkmode.algorithm = "lightness-cielab"
c.colors.webpage.darkmode.threshold.foreground = 50
c.colors.webpage.darkmode.threshold.background = 105

## Background color for webpages if unset (or empty to use the theme's
## color).
c.colors.webpage.bg = "white"

## Contrast for dark mode. This only has an effect when
## `colors.webpage.darkmode.algorithm` is set to `lightness-hsl` or
## `brightness-rgb`.
c.colors.webpage.darkmode.contrast = 0.0

# QT
c.qt.highdpi = True
c.qt.force_platform = "xcb"
c.qt.workarounds.remove_service_workers = False
c.qt.args = [
    "force-light-mode",
    "light-mode-settings",
    "disable-pinch",
    "ignore-gpu-blocklist",
    "enable-gpu-rasterization",
    "enable-accelerated-video-decode",
    "enable-quic",
    "enable-zero-copy",
    "enable-features=VaapiVideoDecoder,VaapiVideoEncoder",
]

# colors
accent = "#1688f0"
blue = "#0f1d91"
black = "#000000"
white = "#dddddd"
red = "#dd2206"
green = "#3ed500"
yellow = "#f1c200"
purple = "#390d91"

c.colors.completion.category.bg = (
    "qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 #888888, stop:1 #111)"
)

# completion
c.colors.completion.category.border.bottom = accent
c.colors.completion.category.border.top = accent
c.colors.completion.category.fg = accent
c.colors.completion.even.bg = "#333333"
c.colors.completion.fg = [white, "white", "white"]
c.colors.completion.item.selected.bg = accent
c.colors.completion.item.selected.fg = black
c.colors.completion.item.selected.border.bottom = "#bbbb00"
c.colors.completion.item.selected.border.top = "#bbbb00"
c.colors.completion.item.selected.match.fg = "#ff4444"
c.colors.completion.match.fg = accent
c.colors.completion.odd.bg = "#444444"
c.colors.completion.scrollbar.fg = "white"
c.colors.completion.scrollbar.bg = "#333333"

# context-menu
c.colors.contextmenu.selected.fg = "white"
c.colors.contextmenu.selected.bg = accent

# downloads
c.colors.downloads.bar.bg = black
c.colors.downloads.error.bg = red
c.colors.downloads.start.fg = "white"
c.colors.downloads.stop.fg = "white"
c.colors.downloads.start.bg = green
c.colors.downloads.stop.bg = green

## Color gradient interpolation
c.colors.downloads.system.bg = "rgb"
c.colors.downloads.system.fg = "rgb"

# hints
c.colors.hints.bg = "qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 rgba(255, 247, 133, 0.8), stop:1 rgba(255, 197, 66, 0.8))"
c.colors.hints.bg = black
c.colors.hints.fg = "white"
c.colors.hints.match.fg = green
c.colors.keyhint.suffix.fg = "darkslategray"

# error
c.colors.messages.info.bg = black
c.colors.messages.error.border = "#bb0000"
c.colors.messages.error.fg = "white"
c.colors.messages.info.fg = "white"
c.colors.messages.warning.bg = "darkorange"
c.colors.messages.warning.border = "#d47300"
c.colors.messages.warning.fg = black

# prompts
c.colors.prompts.bg = "#444444"
c.colors.prompts.border = "1px solid gray"
c.colors.prompts.fg = "white"

c.colors.prompts.selected.bg = "grey"
c.colors.prompts.selected.fg = "white"

# caret
c.colors.statusbar.caret.bg = "purple"
c.colors.statusbar.caret.fg = "white"
c.colors.statusbar.caret.selection.bg = "#a12dff"
c.colors.statusbar.caret.selection.fg = "white"

# statusbar
c.colors.statusbar.command.bg = black
c.colors.statusbar.command.fg = "white"
c.colors.statusbar.command.private.bg = "darkslategray"
c.colors.statusbar.command.private.fg = "white"
c.colors.statusbar.command.private.bg = "darkslategray"
c.colors.statusbar.command.private.fg = "white"
c.colors.statusbar.insert.bg = "darkgreen"
c.colors.statusbar.insert.fg = "white"
c.colors.statusbar.normal.bg = black
c.colors.statusbar.normal.fg = "white"
c.colors.statusbar.private.bg = "#666666"
c.colors.statusbar.private.fg = "white"
c.colors.statusbar.progress.bg = "white"
c.colors.statusbar.passthrough.bg = purple
c.colors.statusbar.url.error.fg = "orange"
c.colors.statusbar.url.fg = accent
c.colors.statusbar.url.warn.fg = yellow
c.colors.statusbar.url.hover.fg = "aqua"
c.colors.statusbar.url.success.http.fg = "white"
c.colors.statusbar.url.success.https.fg = "lime"

# tabs
c.colors.tabs.bar.bg = "#555555"
c.colors.tabs.even.bg = "darkgrey"
c.colors.tabs.even.fg = "white"
c.colors.tabs.odd.bg = "grey"
c.colors.tabs.odd.fg = "white"
c.colors.tabs.indicator.error = "#ff0000"
c.colors.tabs.indicator.start = "#0000aa"
c.colors.tabs.indicator.stop = "#00aa00"
c.colors.tabs.indicator.system = "rgb"
c.colors.tabs.pinned.even.bg = "darkseagreen"
c.colors.tabs.pinned.even.fg = "white"
c.colors.tabs.pinned.odd.bg = "seagreen"
c.colors.tabs.pinned.odd.fg = "white"
c.colors.tabs.pinned.selected.even.bg = black
c.colors.tabs.pinned.selected.even.fg = "white"
c.colors.tabs.pinned.selected.even.bg = accent
c.colors.tabs.pinned.selected.odd.bg = accent
c.colors.tabs.selected.even.bg = accent
c.colors.tabs.selected.odd.bg = accent

# tooltip
## Background color of tooltips. set to null, the Qt default is used.
c.colors.tooltip.bg = None
c.colors.tooltip.fg = None

## media
c.content.autoplay = False
c.content.pdfjs = True
c.content.images = True
c.content.media.audio_capture = "ask"
c.content.media.audio_video_capture = "ask"
c.content.media.video_capture = "ask"
c.content.hyperlink_auditing = False
c.content.mouse_lock = "ask"
c.content.mute = False
c.content.netrc_file = None
c.content.persistent_storage = "ask"
c.content.plugins = False
c.content.prefers_reduced_motion = False
c.content.print_element_backgrounds = True
c.content.private_browsing = False

# proxy
c.content.proxy = "system"
c.content.register_protocol_handler = "ask"
c.content.site_specific_quirks.enabled = True
c.content.site_specific_quirks.skip = []
c.content.tls.certificate_errors = "ask"
c.content.unknown_url_scheme_policy = "allow-from-user-interaction"
c.content.user_stylesheets = []

# notifications
c.content.notifications.enabled = "ask"
c.content.notifications.show_origin = True

# cookies
c.content.cookies.accept = "all"
c.content.cookies.store = True
c.content.default_encoding = "iso-8859-1"

# privacy
c.content.canvas_reading = True
c.content.geolocation = "ask"
c.content.desktop_capture = "ask"
c.content.fullscreen.overlay_timeout = 3000
c.content.fullscreen.window = False

# headers
c.content.headers.accept_language = "en-US,en;q=0.9"
c.content.headers.custom = {}
c.content.headers.do_not_track = True
c.content.headers.referer = "same-domain"
c.content.headers.user_agent = "Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {qt_key}/{qt_version} {upstream_browser_key}/{upstream_browser_version} Safari/{webkit_version}"

# webgl
c.content.webgl = True
c.content.xss_auditing = False
c.content.webrtc_ip_handling_policy = "all-interfaces"

# ads
c.content.blocking.adblock.lists = [
    "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts",
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
]
c.content.blocking.method = "auto"
c.content.blocking.enabled = True
c.content.blocking.hosts.block_subdomains = True

c.content.blocking.hosts.lists = [
    "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
]
c.content.blocking.whitelist = []
c.content.cache.size = None
c.content.canvas_reading = True

# javascript
c.content.javascript.alert = True
c.content.javascript.can_open_tabs_automatically = True
c.content.javascript.clipboard = "ask"
c.content.javascript.enabled = False
try:
    with (config.configdir / "js.sites").open() as js_file:
        js_sites = js_file.read().split("\n")
        js_file.close()

    for js_site in js_sites:
        if js_site != "":
            config.set("content.javascript.enabled", True, js_site)
except FileNotFoundError:
    print("js.sites not found")

c.content.javascript.legacy_touch_events = "never"
c.content.javascript.log = {
    "unknown": "debug",
    "info": "debug",
    "warning": "debug",
    "error": "debug",
}
c.content.javascript.log_message.excludes = {
    "userscript:_qute_stylesheet": [
        "*Refused to apply inline style because it violates the following Content Security Policy directive: *"
    ]
}
c.content.javascript.log_message.levels = {
    "qute:*": ["error"],
    "userscript:GM-*": [],
    "userscript:*": ["error"],
}
c.content.javascript.modal_dialog = False
c.content.javascript.prompt = True

# General
c.editor.command = [terminal, "-e", editor, "{}"]
c.auto_save.interval = 15000
c.auto_save.session = False

# completion
c.completion.shrink = False
c.completion.scrollbar.padding = 2
c.completion.scrollbar.width = 12
c.completion.show = "always"
c.completion.height = "56%"
c.completion.delay = 0
c.completion.quick = True
c.completion.cmd_history_max_items = 100
c.completion.min_chars = 1
c.completion.favorite_paths = []
c.completion.open_categories = [
    "searchengines",
    "quickmarks",
    "bookmarks",
    "history",
    "filesystem",
]
c.completion.timestamp_format = "%Y-%m-%d %H:%M"
c.completion.use_best_match = False
c.completion.web_history.exclude = []
c.completion.web_history.max_items = -1

c.content.geolocation = "ask"
c.window.hide_decoration = True
c.content.headers.do_not_track = True
c.content.headers.referer = "same-domain"

# Zoom
c.zoom.default = "85%"
c.zoom.mouse_divider = 512

# Scrolling
c.scrolling.smooth = False
c.scrolling.bar = "overlay"
c.scrolling.bar = "when-searching"

# search
c.search.wrap = True
c.search.incremental = True
c.search.wrap_messages = True
c.search.ignore_case = "smart"

# Status bar
c.statusbar.show = "in-mode"
c.statusbar.position = "bottom"
c.statusbar.padding = {"top": 1, "bottom": 1, "left": 0, "right": 0}


# Spellcheck
c.spellcheck.languages = ["en-US"]

## Aliases
c.aliases = {
    "q": "quit --save",
    "w": "session-save",
    "wq": "quit --save",
    "wq": "quit --save",
    "x": "quit --save",
    "X": "spawn --userscript ~/.config/qutebrowser/userscripts/view_in_mpv",
    "reader": "spawn --userscript readability-js",
}

## mode
c.bindings.commands["normal"] = {
    # commands
    ";": "cmd-set-text :",
    "q;": "cmd-set-text q:",
}

c.bindings.commands["hint"] = {
    # hints
    "x": "tab-close",
    "jk": "mode-leave",
    "jj": "mode-leave",
}

c.bindings.commands["insert"] = {
    # insert
    "jk": "mode-leave",
    "jj": "mode-leave",
}

# history
c.history_gap_interval = 30
c.input.escape_quits_reporter = True
c.input.forward_unbound_keys = "auto"

# input
c.input.insert_mode.auto_leave = True
c.input.insert_mode.auto_load = False
c.input.insert_mode.leave_on_load = True
c.input.insert_mode.plugins = False
c.input.links_included_in_focus_chain = True
c.input.match_counts = True
c.input.media_keys = True
c.input.mode_override = None
c.input.mouse.back_forward_buttons = True
c.input.mouse.rocker_gestures = False
c.input.partial_timeout = 0
c.input.spatial_navigation = False
c.keyhint.blacklist = []
c.keyhint.delay = 500
c.keyhint.radius = 6

# logging
c.logging.level.ram = "debug"

# messages
c.messages.timeout = 3000

# hints
c.hints.auto_follow = "unique-match"
c.hints.auto_follow_timeout = 0
c.hints.border = "1px solid #E3BE23"
c.hints.mode = "letter"
c.hints.chars = "asdhfeiotr"
c.hints.min_chars = 1
c.hints.dictionary = "/usr/share/dict/words"
c.hints.hide_unmatched_rapid_hints = True
c.hints.leave_on_load = False

config.bind("f", "hint")
config.bind("td", "hint links download")
config.bind("tf", "hint --rapid links tab-bg")
config.bind("tr", "hint links right-click")
config.bind("F", "hint links tab-fg")
config.bind("yl", "hint links yank")

# navigation
config.bind("tj", "tab-prev")
config.bind("tt", "tab-next")
config.bind("xx", "tab-close")
config.bind("gl", "tab-focus last")
config.bind("d", "scroll down")

# zoom
config.bind("<Ctrl-=>", "zoom-in")
config.bind("<Ctrl-->", "zoom-out")

# Tabs
c.tabs.title.format = "{audio}{private}{index}: {current_title}"
c.tabs.title.format_pinned = c.tabs.title.format
c.tabs.pinned.frozen = False
c.tabs.pinned.shrink = False
c.tabs.background = False
c.tabs.favicons.scale = 0.9

c.tabs.select_on_remove = "prev"
c.tabs.mode_on_change = "restore"
c.tabs.position = "right"
c.tabs.show = "switching"
c.tabs.last_close = "close"
c.tabs.padding = {"bottom": 3, "left": 5, "right": 5, "top": 2}
c.tabs.indicator.width = 0

c.tabs.wrap = True
c.tabs.width = "15%"

c.new_instance_open_target = "tab"
c.new_instance_open_target_window = "last-focused"

# prompt
c.prompt.filebrowser = True
c.prompt.radius = 8

# userscripts
config.bind("gr", "spawn --userscript ~/.config/qutebrowser/userscripts/readability-js")
config.bind("sd", "spawn --userscript ~/.config/qutebrowser/userscripts/open_download")
config.bind("ps", "spawn --userscript ~/.config/qutebrowser/userscripts/password_fill")

# editor
c.editor.command = ["nvim", "-f", "{file}", "-c", "normal {line}G{column0}l"]
c.editor.encoding = "utf-8"
c.editor.remove_file = True
c.fileselect.folder.command = ["urxvtc", "-e", "ranger", "--choosedir={}"]
c.fileselect.handler = "default"
c.fileselect.multiple_files.command = ["urxvtc", "-e", "ranger", "--choosefiles={}"]
c.fileselect.multiple_files.command = ["urxvtc", "-e", "ranger", "--choosefiles={}"]

## start page(s) and default page blank
c.url.start_pages = ["about:blank"]
c.url.default_page = "about:blank"

# downloads
c.downloads.location.directory = "~/Downloads"
c.downloads.location.suggestion = "both"
c.downloads.remove_finished = 50000
c.downloads.position = "bottom"
c.downloads.prevent_mixed_content = True
c.downloads.remove_finished = -1
c.confirm_quit = ["downloads"]

## save web pages in MHTML format
## ,sm to do that
config.bind("\\sm", "cmd-set-text :download --mhtml")

## ,yc “yank asciidoc-formatted link”
config.bind("\\yc", "yank inline {url:pretty}[{title}]")

## ,ym “yank markdown-formatted link”
## ym (without a leading comma) also works because it is built-in
config.bind("\\ym", "yank inline [{title}]({url:pretty})")
config.bind("ys", "yank selection")

config.bind("\\P", "open -b -- {primary}")
config.bind("\\p", "open -b -- {clipboard}")

# mpv
config.bind("ya", "hint links spawn -dv ~/.scripts/fillplaylist.sh push {hint-url}")
config.bind("yp", "spawn -dv ~/.scripts/fillplaylist.sh play")
config.bind(
    "yx", "hint links spawn -dv mpv {hint-url} --input-ipc-server=/tmp/mpvsocket"
)

# Home page
c.url.default_page = homepage
c.url.start_pages = homepage

## engine
c.url.searchengines = {
    "DEFAULT": "https://google.com/search?q={}",
    "qw": "https://lite.qwant.com/?q={}",
    "dd": "https://duckduckgo.com/?q={}",
    "ec": "https://www.ecosia.org/search?q={}",
    "gi": "https://github.com/search?q={}",
    "ji": "http://jisho.org/search/{}",
    "ra": "https://rateyourmusic.com/search?searchtype=a&searchterm={}",
    "wikt": "https://en.wiktionary.org/wiki/Special:Search?search={}",
    "wi": "https://en.wikipedia.org/wiki/Special:Search?search={}",
    "yo": "https://youtube.com/results?search_query={}",
}

# font
font_size = "12px"
font_family = "Monaspace Argon Frozen"
font = font_size + " " + font_family
small_font = "11px" + " " + "Monaspace Krypton Frozen"

c.fonts.default_size = font_size
c.fonts.default_family = font_family

c.fonts.contextmenu = font
c.fonts.completion.entry = font
c.fonts.completion.category = font
c.fonts.debug_console = font
c.fonts.downloads = font
c.fonts.prompts = font

c.fonts.hints = small_font
c.fonts.keyhint = small_font
c.fonts.tooltip = small_font
c.fonts.messages.error = small_font
c.fonts.messages.info = font
c.fonts.messages.warning = small_font
c.fonts.statusbar = "italic " + font
c.fonts.tabs.selected = "italic " + font
c.fonts.tabs.unselected = "italic " + small_font

# leader
config.bind(leader + "dd", "devtools")
config.bind(leader + "de", "edit-text")
config.bind(leader + "dc", "cmd-edit")
config.bind(leader + "df", "devtools-focus")
config.bind(leader + "dp", "screenshot " + ss_dir + "qute-" + timestamp + ".png")
config.bind(leader + "ds", "view-source --edit")

config.bind(leader + "fc", "hint links yank --rapid")
config.bind(leader + "fd", "hint links spawn " + terminal + "-e youtube-dl {hint-url}")
config.bind(leader + "ff", "hint links tab-bg --rapid")
config.bind(leader + "fi", "hint inputs")
config.bind(leader + "fo", "hint links window")
config.bind(leader + "fp", "hint links run :open -p {hint-url}")
config.bind(leader + "fv", "hint links spawn mpv {hint-url}")
config.bind(leader + "fy", "hint links yank")

config.bind(leader + "qc", "spawn --userscript ~/.scripts/qrcode_url.sh")
config.bind(
    leader + "qi",
    "hint images spawn -dv mvi {hint-url} --input-ipc-server=/tmp/mpvsocket",
)
config.bind(leader + "qd", "tab-close")
config.bind(leader + "qq", "close")
config.bind(leader + "qr", "restart")
config.bind(leader + "qs", "config-source")
config.bind(leader + "qt", "tab-only")
config.bind(leader + "qw", "window-only")

config.bind(leader + "ta", "bookmark-add")
config.bind(leader + "tb", "bookmark-list")
config.bind(leader + "tc", "tab-clone")
config.bind(leader + "td", "tab-clone -w")
config.bind(leader + "tg", "tab-give")
config.bind(leader + "th", "history")
config.bind(leader + "tm", "cmd-set-text -s :tab-move")
config.bind(leader + "tp", "tab-pin")
config.bind(leader + "tt", "cmd-set-text -s :tab-select")
config.bind(leader + "tu", "undo")
config.bind(leader + "tw", "cmd-set-text -s :tab-take")

config.bind(leader + "x", "quit --save")

# mouse
config.bind("Button1", "hint links spawn mpv {hint-url}", mode="normal")
config.bind("Button2", "cmd-repeat-last", mode="normal")
