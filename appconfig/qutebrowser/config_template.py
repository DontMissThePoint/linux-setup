# theme
import catppuccin

# load your autoconfig, use this if the rest of your config is empty!
config.load_autoconfig()

# set the flavour you'd like to use
# valid options are 'mocha', 'macchiato', 'frappe', and 'latte'
catppuccin.setup(c, 'mocha')

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

## Mode
c.bindings.commands['normal'] = {
# Commands
    ';': 'cmd-set-text :',
    'q;': 'cmd-set-text q:',
}

c.bindings.commands['hint'] = {
# Hints
    'x': 'tab-close',
}

# Hint
config.bind('f', 'hint')
config.bind('tf', 'hint tab')
config.bind('F', 'hint --rapid links tab-bg')
config.bind('yf', 'hint links yank')
config.bind('<Ctrl-=>', 'zoom-in')
config.bind('<Ctrl-->', 'zoom-out')

config.bind('tT', 'tab-prev')
config.bind('tt', 'tab-next')
config.bind('xx', 'tab-close')

## Note: 'gvim.bat' works but 'gvim' does not work
c.editor.command = ['vim', '-f', '{file}', '-c', 'normal {line}G{column0}l']

## I like my start page(s) and default page to be blank
c.url.start_pages = ["about:blank"]
c.url.default_page = "about:blank"

## I like to save web pages in MHTML format
## Thanks to the next key binding, I can use ,sm to do that
config.bind(',sm', 'cmd-set-text :download --mhtml')

## Next works on Windows
c.downloads.location.directory = '~/Downloads/2024-Q1'
# c.downloads.location.directory = '%USERPROFILE%\\Downloads-%YEARQUARTER%\\'

c.downloads.location.suggestion = 'both'

## ,ya is my shortcut to “yank asciidoc-formatted link”
config.bind(',ya', 'yank inline {url:pretty}[{title}]')

## ,ym is my shortcut to “yank markdown-formatted link”
## ym (without a leading comma) also works because it is built-in
config.bind(',ym', 'yank inline [{title}]({url:pretty})')

config.bind(',m', 'spawn umpv {url}')
config.bind(',M', 'hint links spawn umpv {hint-url}')
config.bind(';M', 'hint --rapid links spawn umpv {hint-url}')

## next is a note to self about how to bind JavaScript code to a key shortcut
# config.bind(',hw', "jseval alert('Hello World')")

c.content.dns_prefetch = False

c.url.searchengines = {'DEFAULT': 'https://duckduckgo.com/html?q={}'}
## Above is qutebrowser’s default, next is search engine I use
#c.url.searchengines = {'DEFAULT': 'https://lite.qwant.com/?q={}'}
