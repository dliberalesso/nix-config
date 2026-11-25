## Beads Workflow Integration

This project uses a Beads tracker (the Rust `br` CLI) for issue tracking, plus [beads_viewer](https://github.com/Dicklesworthstone/beads_viewer) (`bv`) for graph-aware triage. Issues are stored in `.beads/`. `bv` auto-discovers supported JSONL exports, including `.beads/issues.jsonl` and legacy `.beads/beads.jsonl`.

**Choose the tracker CLI from this repository's instructions and configuration.** Use `br` commands in a beads_rust workspace. Do not run both trackers against the same workspace or infer the tracker solely from the JSONL filename.

### Using bv as an AI sidecar

bv is a graph-aware triage engine for Beads projects. Instead of parsing .beads/issues.jsonl / .beads/beads.jsonl directly or hallucinating graph traversal, use robot flags for deterministic, dependency-aware outputs with precomputed metrics (PageRank, betweenness, critical path, cycles, HITS, eigenvector, k-core).

**Scope boundary:** bv handles _what to work on_ (triage, priority, planning). The selected tracker CLI (`br`) handles creating, claiming, modifying, and closing beads.

_*CRITICAL: Use ONLY --robot-* flags. Bare bv launches an interactive TUI that blocks your session._*

#### The Workflow: Start With Triage

**`bv --robot-triage` is your single entry point.** Its `triage` object contains:

- `quick_ref`: at-a-glance counts + top 3 picks
- `recommendations`: ranked actionable items with scores, reasons, unblock info
- `quick_wins`: low-effort high-impact items
- `blockers_to_clear`: items that unblock the most downstream work
- `project_health`: status/type/priority distributions, graph metrics
- `commands`: copy-paste shell commands for next steps

```bash
bv --robot-triage        # THE MEGA-COMMAND: start here
bv --robot-next          # Minimal: just the single top pick + claim command

# TOON output (--format toon): a compact tabular encoding. Measured on this
# repository it is 7% smaller than JSON for --robot-graph but 9-15% LARGER for
# nested payloads (--robot-triage, --robot-plan, --robot-insights,
# --robot-label-health); use --stats to see both sizes before adopting it.
# TOON encoding shells out to the tru binary. With no encoder installed,
# --format toon prints a fallback warning, emits JSON with output_format "json",
# and --stats prints no sizes at all.
bv --robot-graph --format toon
bv --robot-triage --format toon --stats
```

By default, `triage.recommendations` and `triage.quick_ref.top_picks` surface ready, actionable leaf work (pass `--robot-include-inactive` to inspect blocked, deferred, parked, or umbrella epic items; assigned `in_progress` items remain marked `claimable=false`). A suggested action records its original local ID, working directory, and tracker route. Use that route rather than a namespaced display ID or an unrelated current directory. Inspect current tracker state before execution: analysis does not reserve work or guarantee that a later claim succeeds.

#### Other bv Commands

| Command                                             | Returns                                                                               |
| --------------------------------------------------- | ------------------------------------------------------------------------------------- |
| `--robot-plan`                                      | Parallel execution tracks with unblocks lists                                         |
| `--robot-priority`                                  | Priority misalignment detection with confidence                                       |
| `--robot-insights`                                  | Full metrics: PageRank, betweenness, HITS, eigenvector, critical path, cycles, k-core |
| `--robot-alerts`                                    | Stale issues, blocking cascades, priority mismatches                                  |
| `--check-drift --robot-drift`                       | Baseline drift evaluation + live issue health alerts                                  |
| `--robot-suggest`                                   | Hygiene: duplicates, missing deps, label suggestions, cycle breaks                    |
| `--robot-diff --diff-since <ref>`                   | Changes since ref: new/closed/modified issues                                         |
| `--bead-history <id>`                               | Single-bead lifecycle events and correlated git commits                               |
| `--robot-graph [--graph-format=json\|dot\|mermaid]` | Dependency graph export                                                               |

Robot analysis commands default to JSON; `--format toon` selects TOON, and `--robot-help` defaults to text. In JSON mode, `--graph-format=dot` or `mermaid` puts diagram text in the `graph` field (`bv --robot-graph --graph-format=dot | jq -r .graph`).

#### Scoping & Filtering

```bash
bv --robot-plan --label backend              # Scope to label's subgraph
bv --robot-insights --as-of HEAD~30          # Historical point-in-time
bv --recipe actionable --robot-plan          # Pre-filter: ready to work (no blockers)
bv --recipe high-impact --robot-triage       # Pre-filter: top PageRank scores
```

### Tracker Commands for Issue Management

Use `br` when executing saved claim commands. It rechecks deferred status and future `defer_until` values when the claim runs, so a recommendation captured before a deferral cannot bypass it. This requirement applies to executing tracker claims.

```bash
br ready --json                       # Show issues ready to work (no blockers)
br list --status=open --json          # All open issues
br show <id> --json                   # Full issue details with dependencies
br create --title="..." --type=task --priority=2 --json
br update <id> --claim --json         # Claim for the current actor and start work
br close <id> --reason="Completed" --json
br close <id1> <id2> --reason="Completed" --json
br sync --flush-only                  # Export DB to JSONL after Beads mutations
```

### Workflow Pattern

1. **Triage**: Run `bv --robot-triage` to find the highest-impact actionable work
2. **Verify**: Check the selected tracker's `show`/`ready` output before claiming
3. **Claim**: Use `br update <id> --claim --json`
4. **Work**: Implement the task
5. **Complete**: Use the selected tracker's `close` command
6. **Refresh for bv**: Run `br sync --flush-only` command above so the JSONL export is current

### Key Concepts

- **Dependencies**: Issues can block other issues. `br ready --json` show unblocked work.
- **Priority**: P0=critical, P1=high, P2=medium, P3=low, P4=backlog (use numbers 0-4, not words)
- **Types**: task, bug, feature, epic, chore, docs, question
- **Blocking**: Use `br dep add <issue> <depends-on>` to add dependencies

### Git Policy

Tracker commands do not grant permission to commit or push application code. Follow this repository's own git and tracker instructions before staging, committing, syncing, or pushing. If the repository says "commit only when asked," that rule overrides any generic workflow advice.
