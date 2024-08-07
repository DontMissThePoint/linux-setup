# theme
import catppuccin

# load your autoconfig, use this if the rest of your config is empty!
config.load_autoconfig()

# set the flavour you'd like to use
# valid options are 'mocha', 'macchiato', 'frappe', and 'latte'
catppuccin.setup(c, 'macchiato')

# colors
c.colors.webpage.darkmode.enabled = False
c.colors.webpage.darkmode.policy.images = 'never'
c.colors.webpage.darkmode.threshold.foreground = 150
c.colors.webpage.darkmode.threshold.background = 205

##################

## Media
c.content.autoplay = False
c.content.pdfjs = True
c.qt.highdpi = True
c.content.media.audio_video_capture = False
c.content.media.video_capture = False

## Adblock Plus AND hosts blocking
c.content.javascript.enabled = False
c.content.blocking.adblock.lists = ['https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts']
c.content.blocking.method = 'both'

# js
config.set('content.javascript.enabled', True, '*://*.mail.google.com')

c.content.geolocation = True
c.qt.force_platform = 'xcb'
c.auto_save.session = True

# Status bar
c.statusbar.show = 'in-mode'
c.scrolling.bar = 'when-searching'
c.scrolling.smooth = False
c.zoom.default = '90%'

c.editor.command = ["vim {}"]
c.content.headers.do_not_track = True
c.completion.shrink = True
c.completion.scrollbar.width = 0
c.completion.scrollbar.padding = 0

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

# hint
config.bind('f', 'hint')
config.bind('td', 'hint links download')
config.bind('tf', 'hint --rapid links tab-bg')
config.bind('tr', 'hint links right-click')
config.bind('F', 'hint links tab-fg')
# config.bind('dl', 'hint links download')
config.bind('yl', 'hint links yank')
config.bind('<Ctrl-=>', 'zoom-in')
config.bind('<Ctrl-->', 'zoom-out')

config.unbind('d')
config.bind('tj', 'tab-prev')
config.bind('tt', 'tab-next')
config.bind('dd', 'tab-close')
config.bind('xx', 'tab-close')

config.bind('gl', 'tab-focus last')

# tabs
c.tabs.title.format = '{audio}{private}{index}: {current_title}'
c.tabs.background = False
c.tabs.favicons.scale = 0.9
c.tabs.select_on_remove = 'prev'
c.tabs.mode_on_change = 'restore'
c.tabs.position = 'right'
c.tabs.show = 'switching'
c.tabs.last_close = 'close'
c.tabs.padding = {'bottom': 3, 'left': 5, 'right': 5, 'top': 2}
c.tabs.indicator.width = 0
c.tabs.pinned.frozen = False

c.new_instance_open_target = 'tab-silent'
c.new_instance_open_target_window = 'last-focused'

# userscripts
config.bind('gr', 'spawn --userscript ~/.config/qutebrowser/userscripts/readability-js')
config.bind('sd', 'spawn --userscript ~/.config/qutebrowser/userscripts/open_download')
config.bind('ps', 'spawn --userscript ~/.config/qutebrowser/userscripts/password_fill')

## start page(s) and default page blank
c.url.start_pages = ["about:blank"]
c.url.default_page = "about:blank"

## save web pages in MHTML format
## ,sm to do that
config.bind(',sm', 'cmd-set-text :download --mhtml')
c.downloads.location.directory = '~/Downloads/2024-Q3'
c.downloads.location.suggestion = 'both'
c.downloads.remove_finished = 60000
c.confirm_quit = ['downloads']

c.completion.height = "33%"
c.messages.timeout = 5000

## ,yc “yank asciidoc-formatted link”
config.bind(',yc', 'yank inline {url:pretty}[{title}]')

## ,ym “yank markdown-formatted link”
## ym (without a leading comma) also works because it is built-in
config.bind(',ym', 'yank inline [{title}]({url:pretty})')
config.bind('ys', 'yank selection')

config.bind(',P', 'open -b -- {primary}')
config.bind(',p', 'open -b -- {clipboard}')

# gallery-dl
config.bind('yi', 'hint images spawn -dv mvi {hint-url} --input-ipc-server=/tmp/mpvsocket')

# mpv
config.bind('ya', 'hint links spawn -dv ~/.scripts/fillplaylist.sh push {hint-url}')
config.bind('yp', 'spawn -dv ~/.scripts/fillplaylist.sh play')
config.bind('yx', 'hint links spawn -dv mpv {hint-url} --input-ipc-server=/tmp/mpvsocket')

## JavaScript code to a key shortcut
# config.bind(',hw', "jseval alert('Hello World')")
c.content.dns_prefetch = False

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

# fonts in pixels
c.fonts.default_family = '"JetBrainsMono Nerd Font Mono", monospace'
c.fonts.default_size = '15px'

mono = '14px monospace'
small_mono = '13px monospace'
c.fonts.completion.entry = mono
c.fonts.completion.category = 'bold ' + mono
c.fonts.debug_console = mono
c.fonts.downloads = mono
c.fonts.prompts = mono
c.fonts.contextmenu = mono

c.fonts.hints = '13px monospace'
c.fonts.keyhint = mono
c.fonts.tooltip = small_mono
c.fonts.messages.error = small_mono
c.fonts.messages.info = 'bold ' + mono
c.fonts.messages.warning = small_mono
c.fonts.statusbar = 'bold ' + '14px monospace'
c.fonts.tabs.selected = 'bold 10pt monospace'
c.fonts.tabs.unselected = mono
