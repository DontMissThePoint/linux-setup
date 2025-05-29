#!/bin/sh

/usr/bin/python3 - <<EOF
import math, decimal, datetime, shutil

dec = decimal.Decimal

# Emoji for each phase
EMOJIS = {
    0: "🌑",  # New Moon
    1: "🌒",  # Waxing Crescent
    2: "🌓",  # First Quarter
    3: "🌔",  # Waxing Gibbous
    4: "🌕",  # Full Moon
    5: "🌖",  # Waning Gibbous
    6: "🌗",  # Last Quarter
    7: "🌘",  # Waning Crescent
}

# Phase names and color codes
PHASES = {
    0: ("New Moon", "\033[1;30m"),         # Dark gray
    1: ("Waxing Crescent", "\033[0;37m"),  # Light gray
    2: ("First Quarter", "\033[1;37m"),    # White
    3: ("Waxing Gibbous", "\033[0;97m"),   # Bright white
    4: ("Full Moon", "\033[1;97m"),        # Bold bright white
    5: ("Waning Gibbous", "\033[0;97m"),   # Bright white
    6: ("Last Quarter", "\033[1;37m"),     # White
    7: ("Waning Crescent", "\033[0;37m"),  # Light gray
}
RESET = "\033[0m"

def position(now=None):
    if now is None:
        now = datetime.datetime.now()
    diff = now - datetime.datetime(2001, 1, 1)
    days = dec(diff.days) + (dec(diff.seconds) / dec(86400))
    lunations = dec("0.20439731") + (days * dec("0.03386319269"))
    return lunations % dec(1)

def phase_index(pos):
    return math.floor((pos * dec(8)) + dec("0.5")) & 7

def progress_bar(pos, width=20):
    filled = int(pos * width)
    empty = width - filled
    return "[" + "█" * filled + "░" * empty + "]"

def main():
    pos = position()
    idx = phase_index(pos)
    name, color = PHASES[idx]
    emoji = EMOJIS[idx]
    rounded = round(float(pos), 1)

    bar = progress_bar(float(pos))
    text = f"{emoji} {name} {bar} {rounded}"
    columns = shutil.get_terminal_size().columns
    print(color + text.rjust(columns) + RESET)

if __name__ == "__main__":
    main()
EOF
