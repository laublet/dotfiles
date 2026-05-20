#!/usr/bin/env bash
# Deprecated — use ./bootstrap or `just bootstrap` (Brewfile + dotbot + mac helpers).
# Kept as a thin alias for old muscle memory.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$ROOT/bootstrap"
