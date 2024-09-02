#!/bin/sh

# convert the url for any site
# encode qr-code

echo "$QUTE_URL" | qrencode --dpi 96 -o - | feh -x --title "QR-Code" -g +200+200 --scale-down -
