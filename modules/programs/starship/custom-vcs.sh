#!/usr/bin/env bash

if jj root --ignore-working-copy >/dev/null 2>&1; then
  jj log --revisions "heads(::@ & bookmarks())" --no-graph --ignore-working-copy --color always --template '
    surround(
      "on ",
      "",
      label(
        "bookmarks prefix",
        surround(
          " ",
          "",
          bookmarks
        )
      )
    )
  '
  jj log --revisions @ --no-graph --ignore-working-copy --color always --limit 1 --template '
    surround(
      " ",
      "",
      separate(
        label("bookmarks", "󰤃"),
        label(
          "error heading prefix",
          concat(
            if(conflict, "󰈸"),
            if(divergent, "⇕"),
            if(hidden, "󰘓"),
            if(immutable, "󰌾"),
          ),
      ),
        label(
          if(diff.files().filter(|i| i.status() == "modified").len() > 0,
            "diff modified",
            "rest"
          ),
          concat(
            label("prefix", ""),
            pad_start(
              2,
              diff.files().filter(|i| i.status() == "modified").len(),
              0
            )
          )
        ),
        label(
          if(diff.files().filter(|i| i.status() == "added").len() > 0,
            "diff modified",
            "rest"
          ),
          concat(
            label("prefix", ""),
            pad_start(
              2,
              diff.files().filter(|i| i.status() == "added").len(),
              0
            )
          )
        ),
        label(
          if(diff.files().filter(|i| i.status() == "copied").len() > 0,
            "diff modified",
            "rest"
          ),
          concat(
            label("prefix", ""),
            pad_start(
              2,
              diff.files().filter(|i| i.status() == "copied").len(),
              0
            )
          )
        ),
        label(
          if(diff.files().filter(|i| i.status() == "removed").len() > 0,
            "diff modified",
            "rest"
          ),
          concat(
            label("prefix", ""),
            pad_start(
              2,
              diff.files().filter(|i| i.status() == "removed").len(),
              0
            )
          )
        ),
        label(
          if(diff.files().filter(|i| i.status() == "renamed").len() > 0,
            "diff modified",
            "rest"
          ),
          concat(
            label("prefix", ""),
            pad_start(
              2,
              diff.files().filter(|i| i.status() == "renamed").len(),
              0
            )
          )
        ),
        label(
          if(diff.stat().total_added() > 0,
            "diff added",
            "rest"
          ),
          concat(
            label("prefix", ""),
            pad_start(
              3,
              diff.stat().total_added(),
              0
            )
          )
        ),
        label(
          if(diff.stat().total_removed() > 0,
            "diff removed",
            "rest"
          ),
          concat(
            label("prefix", ""),
            pad_start(
              3,
              diff.stat().total_removed(),
              0
            )
          )
        ),
      )
    )
  '
else
  # starship module vcs
  starship module git_branch
  starship module git_commit
  starship module git_state
  starship module git_status
fi
