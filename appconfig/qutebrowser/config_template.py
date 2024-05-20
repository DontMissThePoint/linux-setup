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
#c.content.blocking.method = 'both'

c.content.geolocation = True

## Display PDFs within qutebrowser
c.content.pdfjs = True

c.scrolling.bar = 'always'
c.zoom.default = '90%'

## Aliases
c.aliases = {'q': 'quit --save', 'qa': 'quit',
           'w': 'session-save', 'wq': 'quit --save',
           'wqa': 'quit --save',
           'xa': 'quit --save',
           'mpv': 'spawn --userscript ~/.config/qutebrowser/userscripts/view_in_mpv'}

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
config.set('hints.chars', 'asdflothn')

# hint
config.bind('f', 'hint')
config.bind('tf', 'hint tab')
config.bind('F', 'hint --rapid links tab-bg')
config.bind('yl', 'hint links yank')
config.bind('<Ctrl-=>', 'zoom-in')
config.bind('<Ctrl-->', 'zoom-out')

config.bind('tT', 'tab-prev')
config.bind('tt', 'tab-next')
config.bind('xx', 'tab-close')

config.bind('gl', 'tab-focus last')

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
c.downloads.location.directory = '~/Downloads/2024-Q2'
# c.downloads.location.directory = '%USERPROFILE%\\Downloads-%YEARQUARTER%\\'

c.downloads.location.suggestion = 'both'
c.downloads.remove_finished = 1

## ,ya is my shortcut to “yank asciidoc-formatted link”
config.bind(',ya', 'yank inline {url:pretty}[{title}]')

## ,ym is my shortcut to “yank markdown-formatted link”
## ym (without a leading comma) also works because it is built-in
config.bind(',ym', 'yank inline [{title}]({url:pretty})')

config.bind(',m', 'spawn mpv {url}')
config.bind(',M', 'hint links spawn mpv {hint-url}')
config.bind(';M', 'hint --rapid links spawn mpv {hint-url}')

## JavaScript code to a key shortcut
# config.bind(',hw', "jseval alert('Hello World')")
c.content.dns_prefetch = False

## qutebrowser’s default
c.url.searchengines = {'DEFAULT': 'https://swisscows.com/en/web?query={}'}
#c.url.searchengines = {'DEFAULT': 'https://lite.qwant.com/?q={}'}
