# arttime — ASCII art clock & timer

> Cosmetic clock / timer with ASCII art and quotes. Pure aesthetic, zero work utility. Trial: drop if you don't open it within 2 weeks.

## Everyday usage

```bash
arttime                                    # default: clock view with art
arttime -t 25m                             # 25-minute pomodoro timer
arttime -t 5m -m "Break over"              # timer with end message
arttime -a random                          # random ASCII art
arttime -a list                            # list available art names
arttime -a "ANSI Shadow"                   # specific art
arttime --no-art                           # text-only clock
arttime --no-quote                         # skip quote line
```

## Useful flags

| Flag | Effect |
|------|--------|
| `-t DURATION` | timer (e.g. `25m`, `1h30m`, `45s`) |
| `-g HH:MM` | goal time (count down to a wall-clock time) |
| `-m MESSAGE` | message shown when timer ends |
| `-a NAME` | art pack name (or `random`, `list`) |
| `-d` / `--dim` | dim mode (less bright) |
| `-i` / `--interactive` | interactive UI (change art, etc.) |
| `-A` | aesthetics-only mode (no time displayed) |

## Useful combos

```bash
# Pomodoro with end notification on macOS
arttime -t 25m -m "Stop and stretch" && \
  osascript -e 'display notification "Break time" with title "Pomodoro"'

# Wall-clock countdown to a meeting
arttime -g 14:30 -m "Meeting now"

# Ambient mode during deep work
arttime -A -a "Mountain"
```

## Reality check

If you find yourself opening this for "productivity": that's the trap. Either use it for the ASCII art aesthetic (fine, that's its purpose) or drop it. For real pomodoro discipline, a system notification + your phone alarm work better.

## Links

- Repo: https://github.com/poetaman/arttime
