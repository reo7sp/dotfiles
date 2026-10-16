from datetime import datetime
from time import time

from kitty.fast_data_types import add_timer, get_boss
from kitty.tab_bar import as_rgb, draw_tab_with_separator

_timer = None


def draw_tab(draw_data, screen, tab, before, max_tab_length, index, is_last, extra_data):
    global _timer

    if not extra_data.for_layout and _timer is None:
        _timer = add_timer(_refresh, 60 - time() % 60, False)

    tab_manager = get_boss().os_window_map.get(tab.os_window_id)
    active_tab = tab_manager.active_tab if tab_manager else None
    layout_name = active_tab.current_layout.name if active_tab else tab.layout_name

    clock = datetime.now().strftime("%I:%M %p").lstrip("0")
    status = f" L:{layout_name}  {clock} "

    available = screen.columns - before - len(status)
    show_status = is_last and not extra_data.for_layout and available > 1
    if show_status:
        max_tab_length = min(max_tab_length, available)
    end = draw_tab_with_separator(draw_data, screen, tab, before, max_tab_length, index, is_last, extra_data)
    if show_status:
        screen.cursor.fg = as_rgb(int(draw_data.inactive_fg))
        screen.cursor.bg = as_rgb(int(draw_data.default_bg))
        screen.draw(" " * (screen.columns - screen.cursor.x - len(status)))
        screen.draw(status)

    return end


def _refresh(timer_id):
    global _timer

    _timer = None

    for tab_manager in get_boss().os_window_map.values():
        tab_manager.mark_tab_bar_dirty()
