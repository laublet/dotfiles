# jq — JSON query CLI

> Scriptable JSON processor. Use for one-shot queries, pipelines, and CI. Switch to [`fx`](fx.md) when exploring an unknown payload interactively.

## Everyday usage

```bash
cat file.json | jq                              # pretty-print
jq . file.json                                  # same, file arg
jq -c . file.json                               # compact (one line)
jq -r '.field' file.json                        # raw output (no quotes) — pipe-friendly
jq --slurp '.' a.json b.json                    # combine multiple files into an array
jq -n '{ok: true, ts: now}'                     # no input, build from scratch
```

## Selecting

```bash
jq '.users[0].name'                             # array index
jq '.users[].name'                              # all names (stream)
jq '.users | .[0]'                              # equivalent pipe form
jq '.config // {}'                              # default value if null
jq '.. | .id? // empty'                         # recursive descent, only objects with id
jq '.users[] | select(.active)'                 # filter
jq '.users[] | select(.age > 30) | .email'      # filter + project
jq '.users[] | select(.role | test("admin"))'   # regex match
```

## Transforming

```bash
jq '.users | map(.email)'                       # array → array
jq '.users | map({name, age})'                  # shorthand object construction
jq '.users | length'                            # count
jq '.users | sort_by(.age)'                     # sort
jq '.users | group_by(.role) | map({role: .[0].role, count: length})'  # group + count
jq '.events | unique_by(.id)'                   # dedupe
jq '. + {ts: now}'                              # merge object
jq 'del(.password)'                             # delete a key
jq '.users[] |= (.active = true)'               # update each in place
```

## Output formats

```bash
jq -r '.users[].email'                          # raw string per line (pipe to xargs etc.)
jq -c '.users[]'                                # one JSON object per line (JSONL)
jq -s '[.users[]]'                              # slurp: collect inputs into array
jq -R 'split(",")'                              # raw input (CSV-ish)
jq -Rrn '[inputs | split(",")] | .[1:] | map({col1: .[0], col2: .[1]})'   # CSV → array of objects
```

## CloudWatch / AWS patterns

```bash
aws logs filter-log-events ... --output json \
  | jq -r '.events[] | "\(.timestamp) \(.message)"'

aws lambda list-functions --output json \
  | jq -r '.Functions[] | select(.Runtime | startswith("nodejs")) | .FunctionName'

aws stepfunctions get-execution-history ... --output json \
  | jq '.events[] | select(.type == "TaskFailed") | .taskFailedEventDetails'
```

## Composing

```bash
jq '.users[] | select(.active) | .email' file.json \
  | xargs -n1 -I{} echo "send to {}"

curl -s api/orders \
  | jq -r '.[] | [.id, .total] | @csv'                  # → CSV
```

## When to use what

| Need | Tool |
|------|------|
| One-shot scriptable query | `jq` |
| Explore unknown payload (live, vim keys) | [`fx`](fx.md) |
| JS expressions instead of jq DSL | `fx` expression mode |
| Pretty-print + colorize | `jq .` (auto) |
| Format YAML | `yq` (separate tool, not installed by default) |

## Tips

- `jq -r` is essential before piping to `xargs` / shell loops (strips JSON quoting).
- Try expressions interactively with `jq` REPL at https://jqplay.org or `nvim`'s `:JqxList` if you ever install the plugin.
- For very large files: `jq --stream` parses lazily without loading everything.

## Links

- Manual: https://jqlang.org/manual/
- Cookbook: https://github.com/jqlang/jq/wiki/Cookbook
