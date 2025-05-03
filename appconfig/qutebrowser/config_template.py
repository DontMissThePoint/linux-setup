# theme
import catppuccin
from time import localtime, strftime

# Reassign to avoid lsp(ruff_lsp) errors
config = config  # noqa: F821
c = c  # noqa: F821

# load your autoconfig, use this if the rest of your config is empty!
config.load_autoconfig()

# User agent
config.set(
    "content.headers.user_agent",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36",
    "*",
)
c.backend = 'webengine'

# Variables
leader = " "
ss_dir = "~/Pictures/Screenshots/"
timestamp = strftime("%Y-%m-%d-%H-%M-%S", localtime())
terminal = "urxvt"
editor = "nvim"
homepage = "https://yandex.com"

# set the flavour you'd like to use
# valid options are 'mocha', 'macchiato', 'frappe', and 'latte'
catppuccin.setup(c, 'latte')

# Dark mode
c.colors.webpage.darkmode.enabled = False
c.colors.webpage.preferred_color_scheme = 'dark'
c.colors.webpage.darkmode.policy.images = 'always'
c.colors.webpage.darkmode.algorithm = "lightness-cielab"
c.colors.webpage.darkmode.threshold.foreground = 50
c.colors.webpage.darkmode.threshold.background = 105

# QT
c.content.plugins = True
c.qt.args = [
    'force-light-mode',
    'light-mode-settings',
    'disable-pinch',
    'ignore-gpu-blocklist',
    'enable-gpu-rasterization',
    'enable-accelerated-video-decode',
    'enable-quic',
    'enable-zero-copy',
    'enable-features=VaapiVideoDecoder,VaapiVideoEncoder'
]

# upgrade
c.changelog_after_upgrade = 'minor'

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
    "qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 #000000, stop:1 #111)"
)

c.colors.completion.category.border.bottom = accent
c.colors.completion.category.border.top = accent
c.colors.completion.category.fg = accent
c.colors.completion.even.bg = black
c.colors.completion.fg = white
c.colors.completion.item.selected.bg = accent
c.colors.completion.item.selected.fg = black
c.colors.completion.item.selected.match.fg = white
c.colors.completion.match.fg = accent
c.colors.completion.odd.bg = black
c.colors.completion.scrollbar.fg = white
c.colors.contextmenu.selected.fg = white
c.colors.contextmenu.selected.bg = accent
c.colors.downloads.bar.bg = black
c.colors.downloads.error.bg = red
c.colors.downloads.error.bg = white
c.colors.downloads.start.fg = white
c.colors.downloads.stop.fg = white
c.colors.downloads.start.bg = green
c.colors.downloads.stop.bg = green
c.colors.downloads.system.fg = 'rgb'
c.colors.hints.bg = black
c.colors.hints.fg = white
c.colors.hints.match.fg = green
c.colors.messages.info.bg = black
c.colors.statusbar.command.bg = black
c.colors.statusbar.insert.bg = black
c.colors.statusbar.insert.fg = white
c.colors.statusbar.normal.bg = black
c.colors.statusbar.passthrough.bg = purple
c.colors.statusbar.private.bg = yellow
c.colors.statusbar.url.fg = accent
c.colors.statusbar.url.warn.fg = yellow
c.colors.tabs.bar.bg = black
c.colors.tabs.even.bg = black
c.colors.tabs.odd.bg = black
c.colors.tabs.pinned.even.bg = blue
c.colors.tabs.pinned.odd.bg = blue
c.colors.tabs.pinned.selected.even.bg = accent
c.colors.tabs.pinned.selected.odd.bg = accent
c.colors.tabs.selected.even.bg = accent
c.colors.tabs.selected.odd.bg = accent

## Media
c.content.autoplay = False
c.content.pdfjs = True
c.qt.highdpi = True
c.content.media.audio_video_capture = False
c.content.media.video_capture = False

# Privacy
c.content.canvas_reading = True # Breaks 9gag, wolt if False
c.content.geolocation = False
c.content.webrtc_ip_handling_policy = "default-public-interface-only"
c.content.cookies.accept = "no-unknown-3rdparty"
# c.content.headers.user_agent = "Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101 Firefox/68.0"
c.content.headers.accept_language = "en-US,en;q=0.5"

# Adblock
c.content.javascript.enabled = False
c.content.blocking.adblock.lists = ['https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts']
c.content.blocking.method = 'both'

# js
try:
    with (config.configdir / 'js.sites').open() as js_file:
        js_sites = js_file.read().split("\n")
        js_file.close()

    for js_site in js_sites:
        if js_site != '':
            config.set('content.javascript.enabled', True, js_site)
except FileNotFoundError:
    print('js.sites not found')

# General
c.editor.command = [terminal, "-e", editor, "{}"]
c.auto_save.interval = 15000
c.auto_save.session = False

# completion
c.completion.shrink = True
c.completion.scrollbar.width = 0
c.completion.scrollbar.padding = 0
c.completion.height = "33%"
c.completion.delay = 0
c.completion.quick = True
c.completion.cmd_history_max_items = 100

c.messages.timeout = 5000
c.content.geolocation = 'ask'
c.qt.force_platform = 'xcb'
c.zoom.default = "82%"
c.window.hide_decoration = True
c.content.headers.do_not_track = True
c.content.headers.referer = 'same-domain'

# Status bar
c.statusbar.show = 'in-mode'
c.scrolling.bar = 'when-searching'
c.scrolling.smooth = False

# Spellcheck
c.spellcheck.languages = ['en-US']

## Aliases
c.aliases = {'q': 'quit --save', 'qa': 'quit',
           'w': 'session-save', 'wq': 'quit --save',
           'wq': 'quit --save',
           'x': 'quit --save',
           'X': 'spawn --userscript ~/.config/qutebrowser/userscripts/view_in_mpv',
           'reader' : 'spawn --userscript readability-js'}

## mode
c.bindings.commands['normal'] = {
# commands
    ';': 'cmd-set-text :',
    'q;': 'cmd-set-text q:',
}

c.bindings.commands['hint'] = {
# hints
    'x': 'tab-close',
    'jk': 'mode-leave',
    'jj': 'mode-leave',
}

c.bindings.commands['insert'] = {
# insert
    'jk': 'mode-leave',
    'jj': 'mode-leave',
}

## Hints
c.hints.auto_follow = 'always'
c.hints.auto_follow_timeout = 400
c.hints.mode = 'letter'
c.hints.chars = 'asdhfeiotr'
c.hints.border = '0px'

# hints
config.bind('f', 'hint')
config.bind('td', 'hint links download')
config.bind('tf', 'hint --rapid links tab-bg')
config.bind('tr', 'hint links right-click')
config.bind('F', 'hint links tab-fg')
config.bind('yl', 'hint links yank')

# navigation
config.bind('tj', 'tab-prev')
config.bind('tt', 'tab-next')
config.bind('xx', 'tab-close')
config.bind('gl', 'tab-focus last')

# zoom
config.bind('<Ctrl-=>', 'zoom-in')
config.bind('<Ctrl-->', 'zoom-out')

# Tabs
c.tabs.title.format = '{audio}{private}{index}: {current_title}'
c.tabs.title.format_pinned = c.tabs.title.format
c.tabs.pinned.frozen = False
c.tabs.pinned.shrink = False
c.tabs.background = False
c.tabs.favicons.scale = 0.9

c.tabs.select_on_remove = 'prev'
c.tabs.mode_on_change = 'restore'
c.tabs.position = 'right'
c.tabs.show = 'switching'
c.tabs.last_close = 'close'
c.tabs.padding = {'bottom': 3, 'left': 5, 'right': 5, 'top': 2}
c.tabs.indicator.width = 0

c.new_instance_open_target = 'tab-silent'
c.new_instance_open_target_window = 'last-focused'
c.content.dns_prefetch = False

# userscripts
config.bind('gr', 'spawn --userscript ~/.config/qutebrowser/userscripts/readability-js')
config.bind('sd', 'spawn --userscript ~/.config/qutebrowser/userscripts/open_download')
config.bind('ps', 'spawn --userscript ~/.config/qutebrowser/userscripts/password_fill')

## start page(s) and default page blank
c.url.start_pages = ["about:blank"]
c.url.default_page = "about:blank"

# downloads
c.downloads.location.directory = '~/Downloads'
c.downloads.location.suggestion = 'both'
c.downloads.remove_finished = 50000
c.downloads.position = "bottom"
c.confirm_quit = ['downloads']

## save web pages in MHTML format
## ,sm to do that
config.bind(',sm', 'cmd-set-text :download --mhtml')

## ,yc “yank asciidoc-formatted link”
config.bind(',yc', 'yank inline {url:pretty}[{title}]')

## ,ym “yank markdown-formatted link”
## ym (without a leading comma) also works because it is built-in
config.bind(',ym', 'yank inline [{title}]({url:pretty})')
config.bind('ys', 'yank selection')

config.bind(',P', 'open -b -- {primary}')
config.bind(',p', 'open -b -- {clipboard}')

# qrcode for website
config.bind(',q', 'spawn --userscript ~/.scripts/qrcode_url.sh')

# gallery-dl
config.bind(',i', 'hint images spawn -dv mvi {hint-url} --input-ipc-server=/tmp/mpvsocket')

# mpv
config.bind('ya', 'hint links spawn -dv ~/.scripts/fillplaylist.sh push {hint-url}')
config.bind('yp', 'spawn -dv ~/.scripts/fillplaylist.sh play')
config.bind('yx', 'hint links spawn -dv mpv {hint-url} --input-ipc-server=/tmp/mpvsocket')

# Home page
c.url.default_page = homepage
c.url.start_pages = homepage

## search
c.url.searchengines = {
        'DEFAULT': 'https://google.com/search?q={}',
        'qw': 'https://lite.qwant.com/?q={}',
        'dd': 'https://duckduckgo.com/?q={}',
        'ec': 'https://www.ecosia.org/search?q={}',
        'gi': 'https://github.com/search?q={}',
        'ji': 'http://jisho.org/search/{}',
        'ra': 'https://rateyourmusic.com/search?searchtype=a&searchterm={}',
        'wikt': 'https://en.wiktionary.org/wiki/Special:Search?search={}',
        'wi': 'https://en.wikipedia.org/wiki/Special:Search?search={}',
        'yo': 'https://youtube.com/results?search_query={}'
        }

# font
font_size = "14px"
font_family = "Hurmit Nerd Font Mono"
font = font_size + " " + font_family
small_font = "13px" + " " + font_family

c.fonts.default_size = font_size
c.fonts.default_family = font_family

c.fonts.contextmenu = font
c.fonts.completion.entry = font
c.fonts.completion.category = "bold " + font
c.fonts.debug_console = font
c.fonts.downloads = font
c.fonts.prompts = font

c.fonts.hints = small_font
c.fonts.keyhint = small_font
c.fonts.tooltip = small_font
c.fonts.messages.error = small_font
c.fonts.messages.info = "bold " + font
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
