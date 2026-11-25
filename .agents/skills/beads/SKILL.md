---
name: beads
description: Use when triaging, claiming, updating, or closing beads issues in this repo with br and bv. Covers bv --robot-triage entry points, the br claim/close command set, and the sync/flush loop that keeps the JSONL export current for bv.
---

# Beads Issue Tracking (br / bv)

Issues live in `.beads/`. This repo uses the Rust `br` CLI as its tracker — never run both trackers against the same workspace, and do not infer the tracker from JSONL filenames. `bv` (beads_viewer) is a graph-aware triage sidecar: it answers _what to work on_; `br` creates, claims, modifies, and closes beads. Source policy: PRIME.md in the beads workspace.

CRITICAL: invoke `bv` ONLY with `--robot-*` flags. Bare `bv` launches an interactive TUI that blocks your session.

## Triage with bv

`bv --robot-triage` is the single entry point. Its `triage` object carries `quick_ref` (counts + top 3 picks), `recommendations` (ranked actionable items with scores, reasons, unblock info), `quick_wins`, `blockers_to_clear`, `project_health`, and `commands` (copy-paste shell commands for next steps).

```bash
bv --robot-triage # THE MEGA-COMMAND: start here
bv --robot-next # Minimal: just the single top pick + claim command
```

By default, `triage.recommendations` and `triage.quick_ref.top_picks` surface ready, actionable leaf work (`--robot-include-inactive` inspects blocked, deferred, parked, or umbrella epic items; assigned `in_progress` items stay `claimable=false`). A suggested action records its original local ID and tracker route — use that route, not a namespaced display ID or an unrelated working directory. Triage does not reserve work or guarantee a later claim succeeds; verify tracker state before claiming.

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

Scoping: `--label backend` (scope to a label's subgraph), `--as-of HEAD~30` (point-in-time), `--recipe actionable` (no blockers), `--recipe high-impact` (top PageRank).

TOON output (`--format toon`) is a compact tabular encoding but is not always smaller — it shells out to the `tru` binary and silently falls back to JSON without it. Run with `--stats` to compare sizes before adopting TOON for a payload.

## Mutation with br

Use `br` when executing saved claim commands — it rechecks deferred status and future `defer_until` values when the claim runs, so a recommendation captured before a deferral cannot bypass it.

```bash
br ready --json # Issues ready to work (no blockers)
br list --status=open --json # All open issues
br show <id> --json # Full issue details with dependencies
br create --title="..." --type=task --priority=2 --json
br update <id> --claim --json # Claim for the current actor and start work
br close <id> --reason="Completed" --json
br close <id1> <id2> --reason="Completed" --json
br dep add <issue> <depends-on> # Add dependencies
br sync --flush-only # Export DB to JSONL after any mutation
```

## Workflow

1. **Triage**: Run `bv --robot-triage` to find the highest-impact actionable work
2. **Verify**: Check `br show` / `br ready` output before claiming
3. **Claim**: `br update <id> --claim --json`
4. **Work**: Implement the task
5. **Close**: `br close <id> --reason="..."`
6. **Refresh for bv**: `br sync --flush-only` so the JSONL export `bv` auto-discovers stays current

Priorities use numbers 0-4 (P0=critical … P4=backlog), not words. Types: task, bug, feature, epic, chore, docs, question.

Tracker commands do not grant permission to commit or push application code. Follow this repository's own git and tracker instructions (see `AGENTS.md` and `.rpiv/guidance/`) before staging, committing, syncing, or pushing.
