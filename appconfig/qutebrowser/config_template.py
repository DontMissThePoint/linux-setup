# theme
import catppuccin

# load your autoconfig, use this if the rest of your config is empty!
config.load_autoconfig()

# set the flavour you'd like to use
# valid options are 'mocha', 'macchiato', 'frappe', and 'latte'
catppuccin.setup(c, 'latte')

# colors
config.set('colors.webpage.darkmode.enabled', False)

##################

# autoplay
c.content.autoplay = True

## Adblock Plus AND hosts blocking
c.content.javascript.enabled = False
c.content.blocking.adblock.lists = ['https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts']
config.set('content.javascript.enabled', True, '*://*.mail.google.com')

c.content.geolocation = True
c.qt.force_platform = 'xcb'
c.auto_save.session = True

c.scrolling.bar = 'always'
c.zoom.default = '90%'

c.editor.command = ["urxvt -e nvim {}"]
c.content.headers.do_not_track = True
c.completion.shrink = True
c.completion.scrollbar.width = 0
c.completion.scrollbar.padding = 0

## Display PDFs
c.content.pdfjs = True

## Aliases
c.aliases = {'q': 'quit --save', 'qa': 'quit',
           'w': 'session-save', 'wq': 'quit --save',
           'wq': 'quit --save',
           'x': 'quit --save',
           'X': 'spawn --userscript ~/.config/qutebrowser/userscripts/view_in_mpv'}

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

## Keys
c.hints.auto_follow = 'always'
c.hints.auto_follow_timeout = 400
c.hints.mode = 'letter'
config.set('hints.chars', 'asdflothn')

# hint
config.bind('f', 'hint')
config.bind('tf', 'hint tab')
config.bind('F', 'hint --rapid links tab-bg')
# config.bind('dl', 'hint links download')
config.bind('yl', 'hint links yank-primary')
config.bind('<Ctrl-=>', 'zoom-in')
config.bind('<Ctrl-->', 'zoom-out')

config.unbind('d')
config.bind('tj', 'tab-prev')
config.bind('tt', 'tab-next')
config.bind('dd', 'tab-close')
config.bind('xx', 'tab-close')

config.bind('gl', 'tab-focus last')

# tabs
c.tabs.background = True
c.tabs.favicons.scale = 0.9
c.tabs.last_close = 'close'
c.tabs.padding = {'bottom': 3, 'left': 5, 'right': 5, 'top': 2}
c.tabs.mode_on_change = 'restore'
c.tabs.show = 'multiple'
c.tabs.indicator.width = 0

c.new_instance_open_target = 'tab-silent'
c.new_instance_open_target_window = 'last-focused'

# userscripts
config.bind('gr', 'spawn --userscript ~/.config/qutebrowser/userscripts/readability')
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
c.downloads.remove_finished = 1000
c.confirm_quit = ['downloads']

c.completion.height = "33%"
c.messages.timeout = 5000

## ,ya “yank asciidoc-formatted link”
config.bind(',ya', 'yank inline {url:pretty}[{title}]')
config.bind(',P', 'open -b -- {primary}')
config.bind(',p', 'open -b -- {clipboard}')

## ,ym “yank markdown-formatted link”
## ym (without a leading comma) also works because it is built-in
config.bind(',ym', 'yank inline [{title}]({url:pretty})')
config.bind('yc', 'yank pretty-url')

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
        'sc': 'https://swisscows.com/en/web?query={}',
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
