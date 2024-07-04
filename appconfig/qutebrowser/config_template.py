# theme
import catppuccin

# load your autoconfig, use this if the rest of your config is empty!
config.load_autoconfig()

# set the flavour you'd like to use
# valid options are 'mocha', 'macchiato', 'frappe', and 'latte'
catppuccin.setup(c, 'latte')

##################

# autoplay
c.content.autoplay = True

## Adblock Plus AND hosts blocking
c.content.blocking.adblock.lists = ['https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts']
c.content.javascript.enabled = False

c.content.geolocation = True

## Display PDFs within qutebrowser
c.content.pdfjs = True

c.qt.force_platform = 'xcb'
c.auto_save.session = True

c.scrolling.bar = 'always'
c.zoom.default = '90%'

c.completion.shrink = True
c.completion.scrollbar.width = 0
c.completion.scrollbar.padding = 0

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
config.bind('yl', 'hint links yank-primary')
config.bind('<Ctrl-=>', 'zoom-in')
config.bind('<Ctrl-->', 'zoom-out')

config.bind('tj', 'tab-prev')
config.bind('tt', 'tab-next')
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


## Note: 'gvim.bat' works but 'gvim' does not work
c.editor.command = ['vim', '-f', '{file}', '-c', 'normal {line}G{column0}l']

## I like my start page(s) and default page to be blank
c.url.start_pages = ["about:blank"]
c.url.default_page = "about:blank"

## I like to save web pages in MHTML format
## ,sm to do that
config.bind(',sm', 'cmd-set-text :download --mhtml')
c.downloads.location.directory = '~/Downloads/2024-Q3'
c.downloads.location.suggestion = 'both'
c.downloads.remove_finished = 1
c.confirm_quit = ['downloads']

## ,ya “yank asciidoc-formatted link”
config.bind(',ya', 'yank inline {url:pretty}[{title}]')

## ,ym “yank markdown-formatted link”
## ym (without a leading comma) also works because it is built-in
config.bind(',ym', 'yank inline [{title}]({url:pretty})')

config.bind(',m', 'spawn mpv {url}')
config.bind(',M', 'hint links spawn mpv {hint-url}')
config.bind(';M', 'hint --rapid links spawn mpv {hint-url}')

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

c.fonts.default_family = '"JetBrainsMono Nerd Font Mono", monospace'

mono = '10pt monospace'
small_mono = '9pt monospace'
c.fonts.completion.entry = mono
c.fonts.completion.category = 'bold ' + mono
c.fonts.debug_console = mono
c.fonts.downloads = mono
c.fonts.prompts = mono
c.fonts.contextmenu = mono

c.fonts.hints = 'bold 10pt monospace'
c.fonts.keyhint = small_mono
c.fonts.tooltip = small_mono
c.fonts.messages.error = small_mono
c.fonts.messages.info = small_mono
c.fonts.messages.warning = small_mono
c.fonts.statusbar = mono
c.fonts.tabs.selected = mono
c.fonts.tabs.unselected = mono

config.bind(',P', 'open -b -- {primary}')
config.bind(',X', 'spawn -dv mpv --profile=no-term {url}')
config.bind(',p', 'open -b -- {clipboard}')
config.bind(',x', 'hint all spawn -dv mpv --profile=no-term {hint-url}')
