# Kyria Halcyon — Loïc's QMK keymap

Cheatsheet for the keymap living in `~/dev/perso/qmk_userspace/keyboards/splitkb/halcyon/kyria/keymaps/loic/`. Source of truth: `keymap.c` + `config.h`. Companion `readme.md` in that folder has per-layer ASCII diagrams. Keep all three (`keymap.c`, the QMK readme, this file) in sync after every change.

## Layer map

10 layers, columnar stagger, home-row mods (CAGS), thumb layer-taps, OSM mods on hold-layers, two arcane (repeat / magic) keys.

| # | Name | Activation |
|---|---|---|
| 0 | ALPHA | Default |
| 1 | NAV_L | Hold **left Space** — arrows on left hand (S/D/F/G) |
| 2 | NAV_R | Hold **right Space** — arrows on right hand (H/J/K/L) |
| 3 | NUMPAD | Hold **Esc** (left thumb) |
| 4 | SYM_L | Hold **`:`** (right thumb outer) |
| 5 | SYM_R | Hold **`.`** (left thumb outer — tap = `.`) |
| 6 | MOUSE | TT × 2 — right pinky bottom (outer col) |
| 7 | MEDIA | TT × 2 — left pinky home (outer col) |
| 8 | GAMING | TT × 2 — left pinky bottom (outer col) |
| 9 | SETTINGS | TT × 2 — left pinky top (outer col) |

Extras: `TO(ALPHA)` on the outer-pinky top key of every non-base layer (force-return), `QK_LLCK` on an inner key of every hold-layer (lock the held layer), **Space + Space** combo toggles NAV_R from ALPHA.

## Home-row mods (CAGS)

| Left | Mod | | Right | Mod |
|---|---|---|---|---|
| A | Ctrl | | `;` | Ctrl |
| S | Alt | | L | Alt |
| D | Gui | | K | Gui |
| F | Shift | | J | Shift |

- **`CHORDAL_HOLD`** — only opposite-hand chords resolve as hold; same-hand chords tap. Exceptions: Ctrl (A) and Gui (D) can chord same-hand with `Z X C V B Q W E R T` so Cmd+V / Ctrl+C work normally.
- **Tapping term** — uniform 200ms for every home-row mod. `NUM_ESC` is 140ms for snappier numpad activation.
- **Flow tap term** — 80ms on every home-row mod. Default global is 150ms. `NUM_ESC`, `SYR_DOT`, `SYL_COL` disable flow tap (0). **`NAV_L_SPC` / `NAV_SPC` use 150ms** (= global default) to block rolling-typing NAV mis-fires while keeping NAV instantly available after a brief pause.
- **Quick tap** — 120ms: re-tapping within this window always taps (no accidental hold).

## Thumb cluster (ALPHA, both halves)

```
Left thumb (outer → inner):      LAG+Tab │ BOOT │ SYR/. │ NAV_L/Spc │ NUM/Esc
Right thumb (inner → outer):     Bksp    │ NAV_R/Spc │ SYL/: │ BOOT │ Mute
```

`SYR/.` = `LT(_SYM_R, KC_DOT)` — tap emits `.` (vim's repeat-last-change), hold activates SYM_R. The dot also lives on the alpha bot row and SYM_R col 1 (triple redundancy for vim's most-used primitive).

- `LAG+Tab` = `Cmd+Alt+Tab` (workspace back-and-forth in AeroSpace). Also the left-encoder click.
- `BOOT` = `QK_BOOT` — bootloader. Blocked (`KC_NO`) on every other layer to avoid accidents.
- Mute = right-encoder click as well.

## Combos

| Trigger | Output | Active on |
|---|---|---|
| D + F | Enter | ALPHA |
| J + K | Enter | ALPHA |
| LEFT + DOWN (J+K positions) | Enter | NAV_R |
| Space (L) + Space (R) | Toggle NAV_R | ALPHA / NAV_R |
| Z + `/` | **PANIC** — clear all mods, OSMs, weak mods, layers | All |
| Q + P | **MARK** — debug separator + full state to `qmk console` | All |

D+F / J+K require both keys to be tapped (`COMBO_MUST_TAP_PER_COMBO`) — if either is held, the home-row mod fires normally.

## Key overrides & special bindings

| Trigger | Output | Mechanism |
|---|---|---|
| Shift + Backspace | Delete | `key_override` |
| Shift + `-` | `-` (stays literal) | `key_override` for real Shift (held or OSM lock) **and** custom `caps_word_press_user` for Caps Word (key_override only sees real mods, not the weak mods Caps Word uses). `_` still reachable via the dedicated key on SYM_R (L position). |
| Shift + Esc | `~` | `process_record_user` (LT() so override doesn't match) |
| GUI + Esc | `` ` `` | `process_record_user` (GUI suspended around the tap) |
| Tap `:` outer right thumb (SYL_COL) | `:` literal | `process_record_user` (LT() tap → `tap_code16(KC_COLN)`) |

## Capitalization

| Trigger | Effect |
|---|---|
| Hold **F + J** (both shifts) | **Caps Word** — next word auto-uppercase, ends on space/punct, 5s idle timeout |
| **Space then Arcane** (any Space tap immediately followed by Arcane L or R) | **One-shot Shift** — next letter only. Word-initial caps: type previous word, tap Space, tap Arcane, type next letter capitalized |
| Tap OSM Shift × 3 | Lock shift (re-tap to unlock) — uses `ONESHOT_TAP_TOGGLE = 3` |
| `KC_CAPS` on MEDIA layer (position C, left bottom) | OS Caps Lock (sustained ALL CAPS) |

## Arcane keys (`ARCANE_L`, `ARCANE_R`)

Innermost-bottom positions (thumb-adjacent, just inside Tab). Behavior depends on what the **previous** key did:

| Previous key | Behavior on Arcane press |
|---|---|
| Emitted a Space (Space tap from any source) | **One-shot Shift** — next letter capitalized (flag is consumed) |
| Anything else | Same-hand = **Repeat**, cross-hand = **Alt-Repeat** (magic). Emitted as a single tap event — holding Arcane never triggers OS-level key auto-repeat (was the `u + magic = nnnnn` bug). |

Triggers for the Space rule: `KC_SPC` (GAMING) and the tap action of `NAV_L_SPC` / `NAV_SPC` (`record->tap.count > 0`). Holding Space (= NAV layer active) does **not** count — no Space was emitted, so the press falls through to repeat/magic.

### Alt-Repeat magic — SFB killers + bigrams

QWERTY columnar same-finger-bigram pairs. Press the first letter then tap the *opposite-hand* arcane to get the second:

| First | → | First | → | First | → |
|---|---|---|---|---|---|
| E | D | C | E | T | G |
| D | E | U | N | G | T |
| F | R | N | U | I | K |
| R | F | M | Y | K | I |
| H | N | Y | M | O | L |
| Q | U (always "qu") | | | L | O |

Plus: `Ctrl+Z ↔ Ctrl+Y`, `( ↔ )`, `< ↔ >`.

## Combined mod keys (NAV layers)

Hold to register multiple modifiers at once; release to clear all.

| Key | Mods | Use |
|---|---|---|
| `CK_LCA` | Ctrl + Alt | |
| `CK_LAG` | Alt + Gui | (= Cmd+Alt) AeroSpace workspace |
| `CK_LCAG` | Ctrl + Alt + Gui | AeroSpace focus |
| `CK_HYPR` | Ctrl + Alt + Gui + Shift | AeroSpace move/resize |

Layout:
- **NAV_L**: bottom-right home — `CK_HYPR, CK_LCAG, CK_LAG, CK_LCA` (under `HYPR LCAG LAG LCA` text)
- **NAV_R**: bottom-left home — `CK_LCA, CK_LAG, CK_LCAG, CK_HYPR`

## Tap Dance (MEDIA layer)

| Position | Tap | Double tap |
|---|---|---|
| `TD_F1_F11` (right bottom, M position) | F1 | F11 |
| `TD_F2_F12` (right bottom, `,` position) | F2 | F12 |

## Layer 1 — NAV_L (hold left Space)

| Row | A column | S | D | F | G |
|---|---|---|---|---|---|
| Top | HOME | PGUP | PGDN | END | — |
| Home | LEFT | UP | DOWN | RIGHT | — |
| Bottom | C-Z | C-X | C-C | C-V | C-Y |

Right half mirrors the OSM mods (CAGS): `OS_RSFT, OS_RGUI, OS_RALT, OS_RCTL` on J/K/L/`;`. Combined-mods bar (`CK_HYPR, CK_LCAG, CK_LAG, CK_LCA`) on M/`,`/`.`/`/`.

## Layer 2 — NAV_R (hold right Space)

| Row | U | I | O | P |
|---|---|---|---|---|
| Top | HOME | PGDN | PGUP | END |

Home row arrows: J=LEFT, K=DOWN, L=UP, `;`=RIGHT.
Bottom row right: Undo / Cut / Copy / Paste / Redo on N/M/`,`/`.`/`/`.
Left home row: OSMs `OS_CTL, OS_ALT, OS_GUI, OS_SFT` on A/S/D/F.
Left bottom: combined mods `CK_LCA, CK_LAG, CK_LCAG, CK_HYPR` on Z/X/C/V.

**Note**: HOME (U) and END (P) sit directly above LEFT (J) and RIGHT (`;`). Mis-curl of the index/pinky often triggers them — see debug below to confirm.

## Layer 3 — NUMPAD (hold Esc)

```
   Y(NumLk) U(7)   I(8)   O(9)   P(-)   \(/)
            J(4)   K(5)   L(6)   ;(+)   '(*)
            M(1)   ,(2)   .(3)   /(.)   (=)
```

`0` lives on the right thumb inner (SYL_COL position). OSMs again on the left home row.

## Layer 4 — SYM_L (hold `:` right thumb)

Left-hand symbols. Row themes (column groupings explained under [SYM coherence](#sym-coherence)):

| Row | Q | W | E | R | T | Theme |
|---|---|---|---|---|---|---|
| Top | `` ` `` | * | / | \\ | ? | text/code annotations & search direction |
| Home | [ | ( | ) | ] | ; | bracket pairs + statement terminator |
| Bottom | - | { | } | @ | ! | expression/writing ops + curly brace overflow |

The fast index-inner column (T/G/B) carries the expression triplet `? ; !`. Right half: OSMs `OS_RSFT, OS_RGUI, OS_RALT, OS_RCTL` on J/K/L/`;`.

## Layer 5 — SYM_R (hold `.` left thumb)

Right-hand symbols, **fully vim-coherent**:

| Row | Y | U | I | O | P | \\ | Theme |
|---|---|---|---|---|---|---|---|
| Top | % | < | \| | = | > | ~ | operators-with-count & non-line displacements |
| Home (H ; ') | 0 | ^ | - | _ | $ | + | line motions (FNB family) |
| Bottom (N , . /) | . | # | ; | , | * | & | "repeat last X" ops |

Index-inner col 1 (Y/H/N) stacks the three highest-value vim primitives: **`%` `0` `.`** (jump-to-bracket, start-of-line, repeat-last-change). Left home row: OSMs `OS_CTL, OS_ALT, OS_GUI, OS_SFT`.

### SYM coherence

Meta-rule for both symbol layers: **row-primary theming with controlled overflow that preserves column pairs** — saturated rows spill to an adjacent row but keep the sibling's column.

**SYM_R row scores**: 18/18 strict — no exceptions. Top = operators-with-count, Home = 100% line motions, Bot = 100% "repeat last X".

**SYM_L row scores**: 13/15 strict, 15/15 with overflow rule. Exception: `{ }` overflow from saturated home row to bot, keeping ring/middle columns (aligned with `( )` siblings).

Vim motion glossary used: **FNB** = First Non-Blank char of a line (where `^`, `_`, `+`, `-` land).

## Layer 6 — MOUSE (TT — right pinky bottom)

| Cluster | Mapping |
|---|---|
| Right home (HJKL `;`) | Cursor: ←  ↓  ↑  → |
| Right top (UIOP) | Scroll wheel: ←  ↓  ↑  → |
| Right bottom (J/K/L/`;`/`'`) | Btn1 / Btn2 / Btn3 / Btn4 / Btn5 |
| Left top (W E R) | Cursor speed: ACL2 / ACL1 / ACL0 |
| Left home (A S D F) | Plain mods (no OSM): LCtl / LAlt / LGui / LSft |
| Left thumb inner / Right thumb | Btn1 / Btn2 (left), Btn1 (right) |
| Encoders | L = Scroll H, R = Scroll V |

## Layer 7 — MEDIA (TT — left pinky home)

| Cluster | Mapping |
|---|---|
| Left top (W E R) | Vol- / Mute / Vol+ |
| Left home (A S D F) | Stop / Prev / Play / Next |
| Left bottom (Z X C) | CapsLock / `UC_NEXT` / `EE_CLR` |
| Right top (U I O) | F7 / F8 / F9 |
| Right home (J K L) | F4 / F5 / F6 |
| Right bottom (M `,` `.`) | F1 (TD F11) / F2 (TD F12) / F3 |
| Right thumb inner | F10 |
| Left encoder click | Play/Pause |
| Encoders | L = Prev/Next track, R = Vol -/+ |

## Layer 8 — GAMING (TT — left pinky bottom)

Plain QWERTY, **no home-row mods**. LSft and LCtl as regular keys on left outer pinky col. Thumb cluster simplified: `R / Space / Esc` (left) and `Bksp / Enter / Del` (right).

## Layer 9 — SETTINGS (TT — left pinky top)

| Cluster | Mapping |
|---|---|
| Left top (W E R) | RGB Speed- / Toggle / Speed+ |
| Left home (A S D F) | RGB Mode-, Hue-, Sat-, Val- |
| Right top (I) | Screen backlight up |
| Right home (J K L `;`) | RGB Val+, Sat+, Hue+, Mode+ |
| Left bottom (C) | `EE_CLR` — reset EEPROM |
| Right bottom (K) | Screen backlight down |

RGB Mode cycles between Solid, Reactive Simple, Reactive Multiwide (default), Reactive Multicross, Reactive Multinexus, Multisplash. RGB controls affect **per-key LEDs only** — the 12 underglow LEDs keep the per-layer indicator below.

## TFT display indicators (master half)

- **Layer number + name** — large digit + label at the top
- **Caps** — underlined / highlighted when **any** caps-style mode is active: OS Caps Lock, Caps Word, OSM Shift one-shot, OSM Shift locked. Off otherwise.
- **C A G S** mods row — current `get_mods()` (real held modifiers). Weak mods and OSMs are not shown here on purpose to avoid flicker during Caps Word typing.

The slave half runs Conway's Game of Life on the TFT.

## Underglow per-layer color

12 underglow LEDs (6 per half) show the active layer:

| Layer | Color |
|---|---|
| ALPHA | Muted indigo |
| NAV_L | Teal |
| NAV_R | Blue |
| NUMPAD | Green |
| SYM_L | Orange |
| SYM_R | Yellow |
| MOUSE | Cyan |
| MEDIA | Magenta |
| GAMING | Red |
| SETTINGS | White |

Respects `RGB_MATRIX_TIMEOUT` (2 min) and `RGB_MATRIX_SLEEP` (host sleep blanks LEDs).

## Encoders

| Layer | Left turn | Left click | Right turn | Right click |
|---|---|---|---|---|
| ALPHA | WS prev/next (LAG+←/→) | WS back-and-forth (LAG+Tab) | Scroll V | Mute |
| NAV_L | Focus win ↑/↓ (LCAG+↑/↓) | — | PgUp/PgDn | — |
| NAV_R | Focus win ↑/↓ | LCAG+→ | PgUp/PgDn | — |
| MOUSE | Scroll H | — | Scroll V | — |
| MEDIA | Prev/Next track | Play/Pause | Vol -/+ | Mute |
| NUMPAD, SYM_L, SYM_R, GAMING, SETTINGS | transparent | transparent | transparent | transparent |

ALPHA "Scroll V" emits `MS_WHLU/MS_WHLD` (mouse wheel). macOS routes wheel events to the window under the cursor, so the encoder always scrolls whatever sits under the pointer — **not** the focused window. The AeroSpace `on-focus-changed = ['move-mouse window-lazy-center']` workaround was tried and reverted (cursor-jump felt worse than the wrong-window-scroll). If you want focus-follows-scroll, the cleanest option is a separate scroll-router (e.g. a Hammerspoon shim) rather than moving the mouse on every focus change.

## Debug — `qmk console`

Two firmware-side prerequisites (both already set):
- `CONSOLE_ENABLE = yes` in `rules.mk`
- `debug_enable = true` in `keyboard_post_init_user` (without it `dprintf` is a silent no-op — common gotcha)

Run:

```bash
qmk console -l        # sanity check: lists detected devices, expect "splitkb.com Halcyon Kyria rev4"
qmk console -t        # live stream, -t adds host timestamps on every line
```

Streams from the master half (whichever has USB). Three event types:

| Format | Source |
|---|---|
| `KL:row,col,layer,keycode,pressed,tap_count,t_ms` | `process_record_user` — every press and release |
| `LAYER:state=0x...,top=N,t=...` | `layer_state_set_user` — every layer transition |
| `>>>>>> MARK t=... layer=N layer_state=0x... mods=0x... weak=0x... osm=0x... osm_locked=0x... <<<<<<` | `CK_MARK` (Q + P combo) — manual debug separator |

**Workflow** for "something weird happened": type normally → see the bug → **press Q + P** → look at the last ~30 lines before the MARK to correlate keypress timing with layer transitions.

## Continuous logging — `keystats.py` + launchd

`keystats.py` (in the keymap folder) parses `qmk console` output into `keylog.csv` for stats. A macOS launchd agent (`com.loic.qmk-heatmap`) runs the daemon continuously, restarting it whenever the keyboard reconnects (`KeepAlive=true`, `ThrottleInterval=5`).

```bash
cd ~/dev/perso/qmk_userspace/keyboards/splitkb/halcyon/kyria/keymaps/loic

# Install / refresh / remove the launchd agent
python3 keystats.py install
python3 keystats.py uninstall

# Inspect / analyse
launchctl list | grep qmk-heatmap        # agent + PID
tail -f heatmap-daemon.log               # daemon stdout (live)
python3 keystats.py analyse --input keylog.csv   # top keys / layers / positions

# Foreground capture (Ctrl-C to stop)
python3 keystats.py capture
python3 keystats.py live --interval 30   # capture + live summary every 30s
```

After each `flash.sh`, the keyboard re-enumerates → the daemon's `qmk console` subprocess dies → launchd respawns it within 5 s. No manual restart needed.

## Safety nets

| Trigger | Effect |
|---|---|
| **Z + `/` combo** | `CK_PANIC` — clear all mods, weak mods, OSMs, OSM locks, every locked layer |
| Triple-tap outer-pinky top of any non-base layer | `TO(ALPHA)` — force return to base |
| `QK_LLCK` on hold-layer inner key | Lock currently-held layer (still need PANIC if it gets weird) |
| `EE_CLR` (MEDIA layer, position C) | Reset EEPROM → next reboot applies `config.h` defaults |

## Build & flash

```bash
# From qmk_userspace root
./keyboards/splitkb/halcyon/kyria/keymaps/loic/flash.sh
```

Compiles both halves with `HLC_TFT_DISPLAY=1`, renames to `left_tft.uf2` / `right_tft.uf2`, copies to iCloud Drive root. Drag-drop each file onto the corresponding half in bootloader mode (double-tap reset or press a BOOT thumb key).

After flashing on a blank EEPROM, press `EE_CLR` (MEDIA, position C) once to apply the RGB defaults from `config.h`.

## Files

| Path | Purpose |
|---|---|
| `keymap.c` | Layers, custom keycodes, combos, key overrides, process_record_user, encoders |
| `config.h` | TAPPING_TERM, FLOW_TAP, CHORDAL_HOLD, OSM, RGB, Caps Word, combo opts |
| `rules.mk` | Feature toggles (combos, RGB, repeat key, console, tap dance, …) |
| `flash.sh` | Compile both halves + copy to iCloud |
| `readme.md` | Per-layer ASCII layout + firmware-side reference (in `~/dev/perso/qmk_userspace/keyboards/splitkb/halcyon/kyria/keymaps/loic/`) |

## Future / ideas to evaluate

Living TODO — things to try after enough usage data lands in `keylog.csv`.

| Idea | Why | How to test |
|---|---|---|
| Next-iteration design (FR/EN/ES, Arcane on thumbs) | Project-scope work — alpha layout choice, accents handling, SFB rescue expansion. | See [kyria-next.md](kyria-next.md) for the full spec, open decisions, and migration plan. |
| Promote `.` thumb tap usage | The new `SYR_DOT` makes `.` instant. Track if `(3,2) SYR` usage rises in stats — if not, it's underused and worth a reminder. | Compare `(3,2)` count over a week vs the alpha `.` at `(6,2)`. |
| Tune `NAV_L_SPC` / `NAV_SPC` flow tap | Currently 150 ms. Bump up if rolling-typing NAV mis-fires recur, down if NAV feels sluggish after typing. | Reproduce → `Q+P` mark → inspect 30 lines before in `qmk console`. |
