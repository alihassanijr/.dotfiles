"""
Ali's kitty tab bar.
Started off of @zzhaolei's:
https://github.com/kovidgoyal/kitty/discussions/4447
"""

import datetime
import subprocess
import re
import json

from typing import (
    Any,
    Callable,
    Dict,
    List,
    NamedTuple,
    Optional,
    Sequence,
    Tuple,
    Union,
)


from kitty.typing import PowerlineStyle

from kitty.fast_data_types import Screen, get_options, add_timer
from kitty.tab_bar import (DrawData, ExtraData, TabBarData, as_rgb,
                           draw_title)
from kitty.utils import color_as_int
from kitty.rgb import Color

opts = get_options()

ICON: int = "    "
ICON_LENGTH: int = len(ICON)
ICON_FG: int = as_rgb(color_as_int(opts.background))
ICON_BG: int = as_rgb(color_as_int(opts.foreground))

CLOCK_FG = ICON_FG 
DATE_FG  = ICON_FG 
CLOCK_BG = ICON_BG 
DATE_BG  = ICON_BG 

DEFAULT_BG: int = as_rgb(color_as_int(opts.color0))

CUSTOM_FG: int = as_rgb(color_as_int(opts.color15))
CUSTOM_BG: int = as_rgb(color_as_int(opts.color8))

MUSIC_FG: int = as_rgb(color_as_int(opts.color22))
MUSIC_BG: int = as_rgb(color_as_int(opts.color10))

timer_id = None
REFRESH_TIME = 10
timer_cells = []

music_playing = False
playing = False
title = ""
artist = ""

def _draw_icon(screen: Screen, index: int) -> int:
    if index != 1:
        return screen.cursor.x

    fg, bg, bold, italic = (
        screen.cursor.fg,
        screen.cursor.bg,
        screen.cursor.bold,
        screen.cursor.italic,
    )
    screen.cursor.bold, screen.cursor.italic, screen.cursor.fg, screen.cursor.bg = (
        True,
        False,
        ICON_FG,
        ICON_BG,
    )
    screen.draw(ICON)
    # set cursor position
    screen.cursor.x = ICON_LENGTH
    # restore color style
    screen.cursor.fg, screen.cursor.bg, screen.cursor.bold, screen.cursor.italic = (
        fg,
        bg,
        bold,
        italic,
    )
    return screen.cursor.x


powerline_symbols: Dict[PowerlineStyle, Tuple[str, str]] = {
    'slanted': ('', '╱'),
    'round': ('', '')
}


def _draw_left_status(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:

    if draw_data.leading_spaces:
        screen.draw(" " * draw_data.leading_spaces)

    # draw tab title
    draw_title(draw_data, screen, tab, index)

    trailing_spaces = min(max_title_length - 1, draw_data.trailing_spaces)
    max_title_length -= trailing_spaces
    extra = screen.cursor.x - before - max_title_length
    if extra > 0:
        screen.cursor.x -= extra + 1
        # Don't change `ICON`
        screen.cursor.x = max(screen.cursor.x, ICON_LENGTH)
        screen.draw("…")
    if trailing_spaces:
        screen.draw(" " * trailing_spaces)

    screen.cursor.bold = screen.cursor.italic = False
    screen.cursor.fg = 0
    if not is_last:
        screen.cursor.bg = as_rgb(color_as_int(draw_data.inactive_bg))
        screen.draw(draw_data.sep)
    screen.cursor.bg = DEFAULT_BG
    return screen.cursor.x


def _draw_right_status(screen: Screen, is_last: bool) -> int:
    if not is_last:
        return screen.cursor.x
    global music_playing
    global playing
    global title
    global artist
    cells = []
    #if music_playing:
    #    music_status_icon = "" if playing else ""
    #    cells.append((MUSIC_FG, MUSIC_BG, False, False, f"   {music_status_icon} {title}  | {artist} "))
    try:
        battery_pct = int(re.split(r'\t+', subprocess.getoutput("pmset -g batt").split("%")[0])[1])
    except:
        battery_pct = -1

    if battery_pct < 0:
        status = ""
    else:
        status = f"{battery_pct}% {''[battery_pct // 10]}"
    cells.append((CUSTOM_FG, CUSTOM_BG, True , False, f" {status} "))

    cells += [
        (CLOCK_FG , CLOCK_BG , True , False, datetime.datetime.now().strftime(" %I:%M %p ")),
        (DATE_FG  , DATE_BG  , False,  True, datetime.datetime.now().strftime(" %Y/%m/%d ")),
    ]

    right_status_length = 0
    for _, _, _, _, cell in cells:
        right_status_length += len(cell)

    draw_spaces = screen.columns - screen.cursor.x - right_status_length
    if draw_spaces > 0:
        screen.draw(" " * draw_spaces)

    for fg, bg, bold, italic, cell in cells:
        screen.cursor.bold = bold 
        screen.cursor.italic = italic
        screen.cursor.fg = fg
        screen.cursor.bg = bg
        screen.draw(cell)
    screen.cursor.fg = 0
    screen.cursor.bg = 0

    screen.cursor.x = max(screen.cursor.x, screen.columns - right_status_length)
    return screen.cursor.x

def _update_timer_cells(_):
    global music_playing
    global playing
    global title
    global artist
    nowplaying_out = subprocess.getoutput("/Users/alih/.binz/nowplaying-cli")
    music_playing = "{" in nowplaying_out
    if music_playing:
        playing = "PlaybackRate" in nowplaying_out or "playbackrate" in nowplaying_out
        title = nowplaying_out.split("kMRMediaRemoteNowPlayingInfoTitle")[1].split(";")[0].replace("=", "").replace('"', "").replace("'", "").strip();
        artist = nowplaying_out.split("kMRMediaRemoteNowPlayingInfoArtist")[1].split(";")[0].replace("=", "").replace('"', "").replace("'", "").strip();


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    global timer_id
    if timer_id is None:
        timer_id = add_timer(_update_timer_cells, REFRESH_TIME, True)
    _draw_icon(screen, index)
    # Set cursor to where `left_status` ends, instead `right_status`,
    # to enable `open new tab` feature
    end = _draw_left_status(
        draw_data,
        screen,
        tab,
        before,
        max_title_length,
        index,
        is_last,
        extra_data,
    )
    _draw_right_status(
        screen,
        is_last,
    )
    return end
