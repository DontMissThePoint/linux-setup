#!/bin/sh

/usr/bin/python3 - <<EOF
import math, decimal, datetime, shutil
import pytz

# lunar calculation: high precision
decimal.getcontext().prec = 28
dec = decimal.Decimal

# Emoji for each phase
EMOJIS = {
    0: "🌕",  # New Moon
    1: "🌖",  # Waxing Crescent
    2: "🌗",  # First Quarter
    3: "🌘",  # Waxing Gibbous
    4: "🌑",  # Full Moon
    5: "🌒",  # Waning Gibbous
    6: "🌓",  # Last Quarter
    7: "🌔",  # Waning Crescent
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
LUNAR_CYCLE_DAYS = 29.53

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
    return "[" + "░" * empty + "█" * filled + "]"

def format_time_delta(seconds):
    minutes, sec = divmod(int(seconds), 60)
    hours, minutes = divmod(minutes, 60)
    days, hours = divmod(hours, 24)
    return f"{days} days {hours} hrs {minutes} min"

def main():
    now = datetime.datetime.now()
    pos = position(now)
    idx = phase_index(pos)
    name, color = PHASES[idx]
    emoji = EMOJIS[idx]
    rounded = round(float(pos), 1)

    # full
    delta_days = (0.5 - float(pos)) % 1 * LUNAR_CYCLE_DAYS
    next_full = now + datetime.timedelta(days=delta_days)

    # countdown / date
    seconds_left = (next_full - now).total_seconds()
    countdown = format_time_delta(seconds_left)
    next_full_str = next_full.strftime("%B %d %Y, %-I:%M%p")

    # bar
    bar = progress_bar(float(pos))
    phase_text = f"{emoji} {name} {bar} {rounded}"
    columns = shutil.get_terminal_size().columns

    # output
    print(color + phase_text.rjust(columns) + RESET)
    print(f"[ Full moon ]  {countdown}  |  {next_full_str}")

if __name__ == "__main__":
    main()
EOF
