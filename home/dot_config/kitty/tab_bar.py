from ctypes import CDLL, CFUNCTYPE, c_bool, c_char_p, c_long, c_uint32, c_void_p, create_string_buffer
from datetime import datetime
from time import time

from kitty.constants import is_macos
from kitty.fast_data_types import add_timer, get_boss
from kitty.tab_bar import as_rgb, draw_tab_with_separator


class KeyboardLayoutWidget:
    def __init__(self):
        carbon = CDLL("/System/Library/Frameworks/Carbon.framework/Carbon")
        core = CDLL("/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation")

        carbon.TISCopyCurrentKeyboardInputSource.argtypes = ()
        carbon.TISCopyCurrentKeyboardInputSource.restype = c_void_p
        carbon.TISGetInputSourceProperty.argtypes = (c_void_p, c_void_p)
        carbon.TISGetInputSourceProperty.restype = c_void_p

        core.CFArrayGetCount.argtypes = (c_void_p,)
        core.CFArrayGetCount.restype = c_long
        core.CFArrayGetValueAtIndex.argtypes = (c_void_p, c_long)
        core.CFArrayGetValueAtIndex.restype = c_void_p
        core.CFStringGetCString.argtypes = (c_void_p, c_char_p, c_long, c_uint32)
        core.CFStringGetCString.restype = c_bool
        core.CFRelease.argtypes = (c_void_p,)
        core.CFRelease.restype = None

        notification_callback = CFUNCTYPE(None, c_void_p, c_void_p, c_void_p, c_void_p, c_void_p)
        core.CFNotificationCenterGetDistributedCenter.argtypes = ()
        core.CFNotificationCenterGetDistributedCenter.restype = c_void_p
        core.CFNotificationCenterAddObserver.argtypes = (
            c_void_p, c_void_p, notification_callback, c_void_p, c_void_p, c_long,
        )
        core.CFNotificationCenterAddObserver.restype = None
        core.CFNotificationCenterRemoveObserver.argtypes = (c_void_p, c_void_p, c_void_p, c_void_p)
        core.CFNotificationCenterRemoveObserver.restype = None

        self._carbon = carbon
        self._core = core
        self._input_source_languages = c_void_p.in_dll(carbon, "kTISPropertyInputSourceLanguages")
        self._label = ""

        input_source_changed = c_void_p.in_dll(carbon, "kTISNotifySelectedKeyboardInputSourceChanged")
        boss = get_boss()
        center = core.CFNotificationCenterGetDistributedCenter()
        observer = id(boss)

        # Replace the observer on reload and keep its C callback alive on the boss.
        core.CFNotificationCenterRemoveObserver(center, observer, input_source_changed, None)
        boss.tab_bar_input_source_callback = notification_callback(self._on_change)
        deliver_immediately = 4  # CFNotificationSuspensionBehaviorDeliverImmediately
        core.CFNotificationCenterAddObserver(
            center, observer, boss.tab_bar_input_source_callback, input_source_changed, None, deliver_immediately,
        )

        self._label = self._current_label()

    def text(self):
        return "" if self._label == "EN" else self._label

    def _current_label(self):
        source = self._carbon.TISCopyCurrentKeyboardInputSource()
        if not source:
            return ""

        try:
            languages = self._carbon.TISGetInputSourceProperty(source, self._input_source_languages)
            if not languages or not self._core.CFArrayGetCount(languages):
                return ""

            language = self._core.CFArrayGetValueAtIndex(languages, 0)
            buffer = create_string_buffer(64)
            utf8 = 0x08000100  # kCFStringEncodingUTF8
            if self._core.CFStringGetCString(language, buffer, len(buffer), utf8):
                return buffer.value.decode("utf-8").partition("-")[0].upper()
            return ""
        finally:
            self._core.CFRelease(source)

    def _on_change(self, *_):
        label = self._current_label()
        if label != self._label:
            self._label = label
            _redraw_tab_bars()


class ClockWidget:
    def __init__(self):
        self._timer = None

    def text(self, for_layout):
        if not for_layout and self._timer is None:
            self._timer = add_timer(self._refresh, 60 - time() % 60, False)

        now = datetime.now()
        period = "AM" if now.hour < 12 else "PM"
        return f"{now.hour % 12 or 12}:{now.minute:02d} {period}"

    def _refresh(self, timer_id):
        self._timer = None
        _redraw_tab_bars()


class TabLayoutWidget:
    def text(self, tab):
        tab_manager = get_boss().os_window_map.get(tab.os_window_id)
        active_tab = tab_manager.active_tab if tab_manager else None
        layout_name = active_tab.current_layout.name if active_tab else tab.layout_name
        return f"L:{layout_name}"


_clock = ClockWidget()
_tab_layout = TabLayoutWidget()
_keyboard_layout = None


def draw_tab(draw_data, screen, tab, before, max_tab_length, index, is_last, extra_data):
    global _keyboard_layout

    if is_macos and not extra_data.for_layout and _keyboard_layout is None:
        _keyboard_layout = KeyboardLayoutWidget()

    clock = _clock.text(extra_data.for_layout)
    layout = _tab_layout.text(tab)
    keyboard = _keyboard_layout.text() if _keyboard_layout else ""
    status = " " + "  ".join(filter(None, (keyboard, layout, clock))) + " "

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


def _redraw_tab_bars():
    for tab_manager in get_boss().os_window_map.values():
        tab_manager.mark_tab_bar_dirty()
