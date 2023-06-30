"""
Copied from: 
https://sw.kovidgoyal.net/kitty/kittens/custom/#using-kittens-to-script-kitty-without-any-terminal-ui
Slightly altered
"""

from typing import List
from kitty.boss import Boss
from kittens.tui.handler import result_handler


def main(args: List[str]) -> str:
    pass


@result_handler(no_ui=True)
def handle_result(args: List[str], answer: str, target_window_id: int, boss: Boss) -> None:
    tab = boss.active_tab
    if tab is not None:
        if tab.current_layout.name == "stack":
            tab.set_enabled_layouts(["splits"])
            tab.goto_layout("splits")
        else:
            tab.set_enabled_layouts(["stack"])
            tab.goto_layout("stack")
