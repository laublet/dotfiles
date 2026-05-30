# hyperfine — command-line benchmarking

> **Help:** `hyperfine --help`

> Statistical CLI benchmark tool. Runs commands multiple times, computes mean / median / stddev / min / max, and compares alternatives.

## Everyday usage

```bash
hyperfine 'node build.js'                  # single command, default 10 runs
hyperfine 'node build.js' 'bun build.ts'   # compare 2+ commands
hyperfine --warmup 3 'cmd'                 # warmup runs (caches, JIT)
hyperfine -m 50 'cmd'                      # at least 50 runs
hyperfine -N 'cmd'                         # bypass shell (no `sh -c`)
hyperfine --shell=none 'cmd'               # same, explicit
```

## Useful flags

| Flag | Effect |
|------|--------|
| `--warmup N` | discard first N runs before measuring (caches, JIT) |
| `--runs N` | force exactly N runs |
| `-m N` / `--min-runs N` | at least N runs (default 10) |
| `-M N` / `--max-runs N` | cap at N runs |
| `--prepare 'cmd'` | run before each measured command (e.g. clear cache) |
| `--cleanup 'cmd'` | run after each measured command |
| `--parameter-list var v1,v2,v3` | parameterize: `hyperfine -L size 1,10,100 'cmd {size}'` |
| `--parameter-scan var 1 5 -D 1` | numeric sweep |
| `-i` / `--ignore-failure` | keep going when a command fails |
| `-N` | bypass `sh -c` (more accurate, no shell startup overhead) |
| `--export-markdown out.md` | export results as Markdown table |
| `--export-json out.json` | structured output |
| `--show-output` | print stdout/stderr of each run (debug) |

## Common patterns

```bash
# Compare two implementations with warmup
hyperfine --warmup 3 'sd "a" "b" file' 'sed -i "s/a/b/g" file'

# Sweep parameter values
hyperfine -L n 10,100,1000 'fd -e ts | head -{n}'

# Reset disk cache between runs (Linux only)
hyperfine --prepare 'sync; echo 3 | sudo tee /proc/sys/vm/drop_caches' 'cmd'

# Benchmark a cold-start scenario (Node, Python)
hyperfine -N --warmup 1 'node script.js' 'bun script.ts'

# Export to share with team
hyperfine --warmup 3 --export-markdown bench.md 'cmd-a' 'cmd-b'
```

## Output

Hyperfine reports: mean ± stddev, min/max, ratio between commands ("X.X times faster than Y"), and warns if `stddev > 0.5 * mean` (results noisy → re-run with more samples or `--prepare`).

## Links

- Repo: https://github.com/sharkdp/hyperfine
