#!/usr/bin/env python3
"""Insert > **Help:** line after the H1 title in cheatsheets/*.md (idempotent)."""

from pathlib import Path

CHEATSHEETS = Path(__file__).resolve().parents[1] / "cheatsheets"

# tool -> help access (when it exists)
HELP: dict[str, str] = {
    "arttime.md": "`?` in TUI · `arttime --help`",
    "atuin.md": "`Ctrl+R` then `?` / inspector · `atuin help`",
    "aerospace.md": "`aerospace --help` · [AeroSpace guide](https://nikitabobko.github.io/AeroSpace/guide)",
    "bat.md": "`bat --help` · `man bat`",
    "bottom.md": "`?` in TUI · `btm --help`",
    "btop.md": "`?` in TUI (Options) · `btop --help`",
    "clipboard.md": "macOS: Raycast Clipboard History · Linux: `greenclip print-history`",
    "delta.md": "`delta --help` · `man git-diff`",
    "difftastic.md": "`difft --help` · `git dft --help`",
    "dust.md": "`dust --help`",
    "eza.md": "`eza --help`",
    "fd.md": "`fd --help`",
    "fx.md": "`?` in TUI · `fx --help`",
    "fzf.md": "`fzf --help` · `man fzf`",
    "gitui.md": "`?` in TUI · `gitui --help`",
    "glab.md": "`glab help` · `glab <cmd> --help`",
    "glow.md": "`?` in TUI · `glow --help`",
    "glum.md": "`?` in viewer · `glum --help`",
    "markdown-reading.md": "`readmd file.md` · `readweb [dir]` · `cheat markdown-reading`",
    "mdfocus.md": "`readweb --help` via script · `npx mdfocus --help`",
    "go.md": "`go help` · `go help <cmd>`",
    "hyperfine.md": "`hyperfine --help`",
    "index.md": "`cheat` (fzf all sheets) · `cheat <name>`",
    "jq.md": "`jq --help` · `man jq`",
    "karakeep.md": "`cheat karakeep` · [docs](https://docs.karakeep.app/) · `just hoarder-sync-setup`",
    "just.md": "`just --help` · `just --list`",
    "keyboard-navigation.md": "This file · `cheat keyboard-navigation` · Neovim: `<leader>H`",
    "keymaps-hub.md": "This file · `cheat keymaps-hub` · Neovim: `<leader>H`",
    "kyria-next.md": "Design doc — production keymap: [kyria.md](kyria.md)",
    "kyria.md": "QMK: `docs/features/` in firmware tree · `readme.md` in keymap folder",
    "lazydocker.md": "`?` in TUI · `lazydocker --help`",
    "mise.md": "`mise --help` · `mise help <cmd>`",
    "mouseless.md": "`Tab` with overlay open → config editor · [docs](https://mouseless.click/docs/getting_started.html)",
    "neogit.md": "`?` in popup · `g?` in status · `:help neogit` in Neovim",
    "neovim-ide.md": "`:help` · `<leader>?` (all keymaps) · `Space` pause → which-key",
    "oil.md": "`g?` in oil buffer · `:help oil.nvim`",
    "ouch.md": "`ouch --help`",
    "posting.md": "`?` in TUI · `posting --help`",
    "procs.md": "`procs --help`",
    "raycast.md": "Raycast: select a command → shortcut hints · [docs](https://manual.raycast.com)",
    "ripgrep.md": "`rg --help` · `man rg`",
    "rofi.md": "`man rofi` · `rofi -show drun -help`",
    "sd.md": "`sd --help`",
    "session-recap.md": "`cheat` · browse [index.md](index.md)",
    "starship.md": "`starship explain` · `starship --help`",
    "tldr.md": "`tldr <command>` (this *is* the help) · `tldr --help`",
    "tokei.md": "`tokei --help`",
    "tridactyl.md": "`:help` in Tridactyl command line · [wiki](https://github.com/tridactyl/tridactyl/wiki)",
    "tui-guide.md": "`tui` (launcher) · then `?` inside the chosen TUI",
    "vim-fundamentals.md": "`:help` · `:help user-manual` · `:help {topic}`",
    "wezterm.md": "Copy mode: `/` or `?` search · [WezTerm docs](https://wezterm.org/config/keys.html)",
    "yazi.md": "`?` in TUI · `yazi --help`",
    "zed.md": "`Space` pause → which-key · `Cmd+Shift+P` command palette",
    "zellij.md": "`?` in TUI · `zellij --help`",
    "ghostty-lab.md": "`ghostty-lab` · [Ghostty docs](https://ghostty.org/docs)",
    "zoxide.md": "`zoxide --help`",
}

MARKER = "> **Help:**"


def patch(path: Path, help_text: str) -> bool:
    text = path.read_text()
    if MARKER in text:
        return False
    lines = text.splitlines(keepends=True)
    if not lines or not lines[0].startswith("#"):
        raise ValueError(f"{path.name}: expected markdown heading on line 1")
    out: list[str] = [lines[0]]
    if len(lines) > 1 and lines[1].strip() == "":
        out.append(lines[1])
    else:
        out.append("\n")
    out.append(f"{MARKER} {help_text}\n")
    out.append("\n")
    i = 1
    if i < len(lines) and lines[i].strip() == "":
        i += 1
    out.extend(lines[i:])
    path.write_text("".join(out))
    return True


def main() -> None:
    updated = []
    skipped = []
    missing = []
    for name, help_text in sorted(HELP.items()):
        path = CHEATSHEETS / name
        if not path.exists():
            missing.append(name)
            continue
        if patch(path, help_text):
            updated.append(name)
        else:
            skipped.append(name)
    extra = sorted(
        p.name
        for p in CHEATSHEETS.glob("*.md")
        if p.name not in HELP and p.name not in ("README.md",)
    )
    print(f"Updated {len(updated)} files")
    if skipped:
        print(f"Already had Help ({len(skipped)})")
    if missing:
        print("Missing paths:", missing)
    if extra:
        print("No HELP entry (add manually):", ", ".join(extra))


if __name__ == "__main__":
    main()
