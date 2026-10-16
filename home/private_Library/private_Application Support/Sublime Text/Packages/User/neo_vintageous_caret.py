import sublime_plugin


class NeoVintageousCaret(sublime_plugin.EventListener):
    def _update(self, view):
        try:
            from NeoVintageous.nv.settings import get_mode
        except ImportError:
            return

        mode = get_mode(view)
        if mode not in ("mode_normal", "mode_insert"):
            return

        style = "solid" if mode == "mode_normal" else "blink"
        if view.settings().get("caret_style") != style:
            view.settings().set("caret_style", style)

    def on_activated(self, view):
        self._update(view)

    def on_post_text_command(self, view, command_name, args):
        self._update(view)
