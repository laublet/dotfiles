# Albert — application launcher

Cross-platform launcher (macOS + Linux). Hotkey: `Ctrl+Space` (macOS, see `conf/albert/config-macos`) / `Super+Space` (Linux).

## Websearch triggers

| Trigger | Service |
|---------|---------|
| `k query` or free text | Kagi (default) |
| `tr texte` | DeepL Translate |
| `gh query` | GitHub |
| `yt query` | YouTube |
| `npm package` | NPM |
| `mdn topic` | MDN Web Docs |
| `maps lieu` | Google Maps |
| `wa calcul` | Wolfram Alpha |
| `ama product` | Amazon |

## Built-in commands

| Command | Action |
|---------|--------|
| `lock` | Lock screen |
| `sleep` | Sleep |
| `restart` | Restart |
| `shutdown` | Shutdown |
| `timer 5m` | Set timer |
| `md5 text` | Hash (also sha256, sha512) |
| `time` / `date` | Current time/date |

## Other features

- **Files**: Type filename to search (uses Spotlight index on macOS)
- **SSH**: Type hostname from `~/.ssh/config`
- **Obsidian**: Type note name to open
- **Homebrew**: `brew install ...` (macOS)

## Config locations

- **macOS**: `~/Library/Preferences/albert/config`
- **Linux**: `~/.config/albert/config`
- **Websearch engines**: `websearch/engines.json` in same folder

## Known issues (macOS)

- **Crash at launch / impossible to open**: the cask bundle is not self-contained; the **widgetsboxmodel** frontend links against **QtStateMachine** from Homebrew. If `qtscxml` is missing, Albert can **segfault immediately** (see `~/Library/Logs/DiagnosticReports/Albert-*.ips`). Fix: `brew install qtscxml`, then reopen Albert. After a Homebrew Qt upgrade, reinstall or `brew upgrade` Albert if it misbehaves.
- `applications` plugin crashes → disabled in `config-macos`
- `calculator_qalculate` plugin crashes → disabled in `config-macos`
- Message **"Albert has not been terminated properly"** after a crash: usually harmless; if it persists, quit Albert fully then delete `~/Library/Application Support/albert/state` (you lose window position / minor state only).

## Troubleshooting

- From a terminal: `/Applications/Albert.app/Contents/MacOS/Albert` — if it exits with code 139, check Diagnostic Reports and missing dylibs (`otool -L …/PlugIns/albert/widgetsboxmodel.dylib`).
- Ensure cask deps: `brew deps --missing --cask albert` (install anything listed).

## Related

- Clipboard: [clipboard.md](clipboard.md) (Maccy on macOS, Greenclip on Linux)
