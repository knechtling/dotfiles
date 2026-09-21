"""Small Kitty actions needed for faithful tmux-style pane management."""

from kitty.boss import Boss


TMUX_LAYOUTS = (
    "horizontal",              # even-horizontal
    "vertical",                # even-vertical
    "fat",                     # main-horizontal
    "fat:mirrored=true",       # main-horizontal-mirrored
    "tall",                    # main-vertical
    "tall:mirrored=true",      # main-vertical-mirrored
    "grid",                    # tiled
)


def main(args: list[str]) -> None:
    pass


from kittens.tui.handler import result_handler


@result_handler(no_ui=True)
def handle_result(
    args: list[str], answer: str, target_window_id: int, boss: Boss
) -> None:
    action = args[1] if len(args) > 1 else ""
    window = boss.window_id_map.get(target_window_id)
    tab = window.tabref() if window is not None else boss.active_tab
    if tab is None:
        return

    if action == "select-pane":
        def focus(selected_tab, selected_window) -> None:
            if selected_tab is not None and selected_window is not None:
                selected_tab.set_active_window(selected_window)

        # Include the active pane so Kitty displays labels even when there are
        # only two panes. The builtin focus_visible_window skips it and would
        # immediately toggle focus instead of showing tmux-like pane indexes.
        boss.visual_window_select_action(tab, focus, "Select pane")
    elif action == "next-layout":
        current = tab.current_layout.full_name
        try:
            next_index = (TMUX_LAYOUTS.index(current) + 1) % len(TMUX_LAYOUTS)
        except ValueError:
            next_index = 0
        tab.goto_layout(TMUX_LAYOUTS[next_index])
